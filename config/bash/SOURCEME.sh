CPDS_BASHFILES="$HOME/.config/bash"

files_to_source=("aesthetics.sh" "aliases.sh")
for file in ${files_to_source[@]}; do
  if [ -f "${CPDS_BASHFILES}/${file}" ]; then
    source "${CPDS_BASHFILES}/${file}"
  else 
    echo "${CPDS_BASHFILES}/${file} not found. Make sure it's there?"
  fi
done
#source "${CPDS_BASHFILES}/aesthetics.sh"
#source "${CPDS_BASHFILES}/aliases.sh"

