
export def saup [] {
  sudo apt update;
  sudo apt upgrade -y
}

alias sas = apt search
alias sai = sudo apt install -y
alias sar = sudo apt reinstall -y
alias saR = sudo apt remove -y
alias saa = sudo apt autoremove
alias sau = sudo apt update -y
alias saU = sudo apt upgrade -y
alias saf = sudo apt install --fix-broken
alias sal = sudo apt list --upgradable
alias sdc = sudo dpkg --configure -a
alias sdi = sudo dpkg --install

export def snup [] {
  sudo nala update;
  sudo nala upgrade -y
}

alias snap = sudo nala autopurge
alias snar = sudo nala autoremove
alias snf = sudo nala full-upgrade
alias snF = sudo nala full-upgrade -y
alias snh = sudo nala history
alias sni = sudo nala install -y
alias snl = sudo nala list
alias snp = sudo nala purge
alias snr = sudo nala remove
alias sns = sudo nala search
alias snS = sudo nala show
alias snu = sudo nala update
alias snU = sudo nala upgrade
