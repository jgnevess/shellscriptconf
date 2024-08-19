#!/bin/bash



upgradePackage() {
    echo "Atualizando pacotes...."
    sudo pacman -Syu --noconfirm
    echo "pacotes atualizados"
}

packages=(
    "jdk17-openjdk"
    "git"
    "intellij-idea-community-edition"
    "nodejs-lts-iron"
    "npm"
    "nano"
    "firefox"
    "docker"
    "docker-compose"
    "vim"
    "neovim"
    "keypassxc"
)

installPackagesPacman() {

    echo "Instalando pacotes..."

    for package in "${packages[@]}"; do
        if ! pacman -Q $package &>/dev/null; then
            echo "Instalando $package..."
            sudo pacman -S --noconfirm --needed $package
        else
            echo "$package já está instalado."
        fi
    done

    echo "pacotes instalados..."
}

confGit() {

    echo "Configurando Git..."

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

    echo "Git configurado com sucesso..."
}

code() {
    mkdir -p /home/$USER/aur
    cd /home/$USER/aur
    if [ ! -d "visual-studio-code-bin" ]; then
        echo "Clonando vscode..."
        git clone https://aur.archlinux.org/visual-studio-code-bin.git
    else
        echo "O repositório já foi clonado."
    fi
}

postman() {

    echo "Clonando postman..."

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


aurInstall() {

    echo "Instalando pacotes Arch User Repository..."

    for package_dir in "${aur[@]}"; do
        if [ -d "$package_dir" ]; then
            if pacman -Qs $package_dir > /dev/null; then
                echo "$package_dir já está instalado."
            else
                echo "Navegando para o diretório $package_dir"
                cd "$package_dir" || exit
                echo "Executando makepkg -si --noconfirm em $package_dir"
                makepkg -si --noconfirm
            fi
        else
            echo "O diretório $package_dir não existe."
        fi
    done
    rm -rf /home/$USER/aur

    echo "Instalações finalizadas..."
}

angular() {
    echo "Instalando angular..."
    sudo npm i --global @angular/cli
    echo "Angular instalado..."
}


confNeoVim() {

    echo "Configurações do nvim..."

    mkdir /home/$USER/.config/nvim/
    cd /home/$USER/.config/nvim/
    git clone git@github.com:Joaogneves/configuracoesnvim.git
    cd /home/$USER/.config/nvim/configuracoesnvim/
    mv coc-settings.json .. && mv init.vim ..
    rm -rf /home/$USER/.config/nvim/configuracoesnvim/

    echo "nvim configurado com sucesso..."
}


startDocker() {

    echo "Iniciando docker..."

    sudo systemctl enable docker
    sudo systemctl start docker

    echo "Docker iniciado...."
}

installPackagesPacman
confGit
#code
postman
aurInstall
angular
confNeoVim
startDocker

echo "Configurações de pós instalação do Arch Linux finalizadas..."
