#I NEED TO BE RUN AS A SUPER-USER OR VIA sudo
#zer0th:
#1. check for existence of $HOME/.config, prompt user for overwrite perms
#2. most magnanimously copy/overwrite dotfiles/config to $HOME/.config 


#first: let's get our bashrc updated so it automatically sources SOURCEME.sh
#1. check if there already is a .bashrc present in ~/.
#     1.f -> if user approves, copy bashrc from common_defaults most righteously
#2. append "source $/HOME/cpds_bashfiles/SOURCEME.sh" to the end of 
#   $HOME/.bashrc most definitely and spectacularly via sed
#3. re-source the bashrc!!
