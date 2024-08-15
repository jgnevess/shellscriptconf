#!/bin/bash

echo "Instalando pacotes pacman"

sudo pacman -Syu --noconfirm

pacotes=(
    "jdk17-openjdk"
    "git"
    "intellij-idea-community-edition"
    "nodejs-lts-iron"
    "nano"
    "firefox"
    "docker"
    "docker-compose"
)

installSoftwares() {
    for pacote in "${pacotes[@]}"; do
        if ! pacman -Q $pacote &>/dev/null; then
            echo "Instalando $pacote..."
            sudo pacman -S --noconfirm --needed $pacote
        else
            echo "$pacote já está instalado."
        fi
    done
}

configurarGit() {

    if git config --global user.name >/dev/null 2>&1; then
        echo "O user.name está definido como: $(git config --global user.name)"
    else
        echo "Configurando user.name."
        git config --global user.name "Joao Gabriel"
    fi

    if git config --global user.email >/dev/null 2>&1; then
        echo "O user.name está definido como: $(git config --global user.email)"
    else
        echo "Configurando user.email."
        git config --global user.email "joaogabriel443@gmail.com"
    fi    
}

code() {
    mkdir -p /home/$USER/aur
    cd /home/$USER/aur
    if [ ! -d "visual-studio-code-bin" ]; then
        git clone https://aur.archlinux.org/visual-studio-code-bin.git
    else
        echo "O repositório já foi clonado."
    fi
}

postman() {
    cd /home/$USER/aur
    if [ ! -d "postman-bin" ]; then
        git clone https://aur.archlinux.org/postman-bin.git
    else
        echo "O repositório já foi clonado."
    fi
}

aur=(
    "/home/$USER/aur/visual-studio-code-bin"
    "/home/$USER/aur/postman-bin"
)

echo "Instalando pacotes aur"

aurInstall() {
    for package_dir in "${aur[@]}"; do
        if [ -d "$package_dir" ]; then
            echo "Navegando para o diretório $package_dir"
            cd "$package_dir" || exit
            echo "Executando makepkg -si --noconfirm em $package_dir"
            makepkg -si --noconfirm
        else
            echo "O diretório $package_dir não existe."
        fi
    done
    rm -rf /home/$USER/aur
}

angular() {
    sudo npm i --global @angular/cli
}

installSoftwares
configurarGit
code
postman
aurInstall
angular
