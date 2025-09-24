#!/usr/bin/env bash
set -e

echo "=== AutoHotkey Mac-Style Layer Installer for Windows (Terminal + Alacritty) ==="

# Your confirmed PowerShell path (Windows PowerShell 5.1)
POWERSHELL="/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"

# ---------- 1) Ensure WSL interop (append only missing lines) ----------
INTEROP_SECTION=false

ENABLED_LINE=false
APPEND_PATH_LINE=false

if [[ -f /etc/wsl.conf ]]; then
  grep -q "^\[interop\]" /etc/wsl.conf && INTEROP_SECTION=true || true
  grep -q "^enabled\s*=\s*true" /etc/wsl.conf && ENABLED_LINE=true || true

  grep -q "^appendWindowsPath\s*=\s*true" /etc/wsl.conf && APPEND_PATH_LINE=true || true
fi

if $INTEROP_SECTION && $ENABLED_LINE && $APPEND_PATH_LINE; then
  echo "✔ /etc/wsl.conf already contains interop settings."
else
  read -p "Add missing interop settings to /etc/wsl.conf? (y/n) " choice
  if [[ "$choice" =~ ^[yY]$ ]]; then

    {
      [[ $INTEROP_SECTION == false ]] && echo "[interop]"
      [[ $ENABLED_LINE == false ]] && echo "enabled=true"
      [[ $APPEND_PATH_LINE == false ]] && echo "appendWindowsPath=true"
    } | sudo tee -a /etc/wsl.conf > /dev/null
    echo "✔ Updated interop config in /etc/wsl.conf."
    echo "⚠ Run 'wsl --shutdown' from PowerShell/CMD to apply changes, then rerun this script."
    exit 0
  else
    echo "⚠ Skipping interop config update."
  fi
fi

# ---------- 2) Ensure AutoHotkey is installed (don’t bail if already installed) ----------
echo "Installing/ensuring AutoHotkey via winget..."
if ! "$POWERSHELL" -NoProfile -Command "winget install --id=AutoHotkey.AutoHotkey -e --accept-package-agreements --silent" ; then
  echo "⚠ winget did not report success (already installed or other issue). Continuing anyway."

fi


# ---------- 3) AHK v2 script (Shift-aware; Windows Terminal + Preview + Alacritty) ----------
AHK_SCRIPT=$(cat <<'EOD'
#SingleInstance Force

; Limit to these apps (single line; no backslashes)
#HotIf WinActive("ahk_exe WindowsTerminal.exe") || WinActive("ahk_exe WindowsTerminalPreview.exe") || WinActive("ahk_exe alacritty.exe")

; ----- Shift-aware handlers -----

; Cmd+Z = Undo, Cmd+Shift+Z = Redo
LWin & z:: {
    if GetKeyState("Shift","P")
        Send("^y")
    else
        Send("^z")
}

; Cmd+Tab = next tab, Cmd+Shift+Tab = prev tab
LWin & Tab:: {
    if GetKeyState("Shift","P")

        Send("^+{Tab}")
    else
        Send("^{Tab}")
}

; Cmd+T = new tab, Cmd+Shift+T = reopen closed tab
LWin & t:: {
    if GetKeyState("Shift","P")

        Send("^+t")
    else

        Send("^t")
}


; ----- Basic editing (Ctrl+Shift variants; safer for terminals) -----
LWin & c:: Send("^+c")
LWin & v:: Send("^+v")
LWin & x:: Send("^+x")
LWin & a:: Send("^+a")

; File ops
LWin & s:: Send("^s")
LWin & o:: Send("^o")
LWin & n:: Send("^n")

LWin & p:: Send("^p")

; Find

LWin & f:: Send("^f")
LWin & g:: Send("^g")

; Close/Quit
LWin & w:: Send("^w")
LWin & q:: Send("!{F4}")

; Navigation
LWin & Left::      Send("^{Left}")
LWin & Right::     Send("^{Right}")
LWin & Up::        Send("^{Up}")
LWin & Down::      Send("^{Down}")

LWin & Backspace:: Send("^Backspace")

; Numbered tab switching (Cmd+1 .. Cmd+9)
LWin & 1:: Send("^1")
LWin & 2:: Send("^2")
LWin & 3:: Send("^3")
LWin & 4:: Send("^4")
LWin & 5:: Send("^5")
LWin & 6:: Send("^6")
LWin & 7:: Send("^7")

LWin & 8:: Send("^8")
LWin & 9:: Send("^9")

#HotIf
EOD
)

# ---------- 4) Resolve Windows vs WSL paths ----------
USER_DOCS_WIN="$("$POWERSHELL" -NoProfile -Command '[Environment]::GetFolderPath("MyDocuments")' | tr -d '\r')"

STARTUP_PATH_WIN="$("$POWERSHELL" -NoProfile -Command '[Environment]::GetFolderPath("Startup")'       | tr -d '\r')"


USER_DOCS_UNIX="$(wslpath -u "$USER_DOCS_WIN")"

AHK_PATH_UNIX="${USER_DOCS_UNIX}/mac_layer.ahk"
AHK_PATH_WIN="$(wslpath -w "$AHK_PATH_UNIX")"
AHK_DIR_WIN="$(wslpath -w "$(dirname "$AHK_PATH_UNIX")")"


mkdir -p "$USER_DOCS_UNIX"

# ---------- 5) Write/update mac_layer.ahk only if changed ----------
TMP_FILE="$(mktemp)"
printf "%s" "$AHK_SCRIPT" > "$TMP_FILE"

if [[ -f "$AHK_PATH_UNIX" ]] && cmp -s "$TMP_FILE" "$AHK_PATH_UNIX"; then
  echo "✔ mac_layer.ahk already up-to-date. No changes needed."
  rm -f "$TMP_FILE"
else
  mv -f "$TMP_FILE" "$AHK_PATH_UNIX"
  echo "✔ Wrote updated AutoHotkey script to: $AHK_PATH_UNIX"
fi

# ---------- 6) Launch (or reload) via file association ----------
echo "Launching/Reloading AutoHotkey using file association..."
# /D avoids UNC current-dir warning by setting a normal drive working directory

cmd.exe /c start "" /D "$AHK_DIR_WIN" "$AHK_PATH_WIN"


# ---------- 7) Create/overwrite Startup shortcut via tiny PowerShell script ----------
echo "Creating/Updating Startup shortcut in: $STARTUP_PATH_WIN"

PWSH_SCRIPT_UNIX="$(mktemp /tmp/make_ahk_shortcut.XXXXXX.ps1)"
cat > "$PWSH_SCRIPT_UNIX" <<'PWSH'
param([Parameter(Mandatory=$true)][string]$AhkPath)
$startup = [Environment]::GetFolderPath('Startup')
$dir     = [System.IO.Path]::GetDirectoryName($AhkPath)
$WshShell = New-Object -ComObject WScript.Shell

$lnk = Join-Path $startup 'mac_layer.lnk'
$Shortcut = $WshShell.CreateShortcut($lnk)

$Shortcut.TargetPath       = $AhkPath   # target the .ahk; file association launches AutoHotkey
$Shortcut.Arguments        = ''
$Shortcut.WorkingDirectory = $dir
$Shortcut.Save()
PWSH


PWSH_SCRIPT_WIN="$(wslpath -w "$PWSH_SCRIPT_UNIX")"
"$POWERSHELL" -NoProfile -ExecutionPolicy Bypass -File "$PWSH_SCRIPT_WIN" -AhkPath "$AHK_PATH_WIN"


echo
echo "✅ All done!"
echo "• Script (WSL path): $AHK_PATH_UNIX"
echo "• Script (Windows path): $AHK_PATH_WIN"
echo "• It should be running now (file association)."

echo "• It will auto-launch at login via a Startup shortcut."

