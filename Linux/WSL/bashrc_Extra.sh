#Environmental Varialbles
export WINHOME="/mnt/c/Users/$USER"
export ONEDRIVE="/mnt/c/Users/$USER/OneDrive"
export ONEDRIVE_PWSH="/mnt/c/Users/$USER/OneDrive/Documents/WindowsPowerShell"


#Homebrew Installation
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc


#brew PATH
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

#brew AUTOCOMPLETE
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi


#OH-MY-POSH
#brew install oh-my-posh
eval "$(oh-my-posh init bash --config "$ONEDRIVE_PWSH/ohmyposhCustome.omp.json")"
