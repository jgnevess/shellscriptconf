#! /bin/bash

PACKAGES=(
    "curl"
    "openjdk-17-jdk"
    "keepassxc"
    "nodejs"
    "npm"
    "git"
    "wget"
    "docker-ce"
    "docker-ce-cli"
    "containerd.io"
    "docker-buildx-plugin"
    "docker-compose-plugin"
    "dotnet-sdk-8.0"
    "aspnetcore-runtime-8.0"
    )

PATH_DOWNLOAD="/home/$USER/Downloads/debs"

PACKAGES_DEB=(
        "https://vscode.download.prss.microsoft.com/dbazure/download/stable/fabdb6a30b49f79a7aba0f2ad9df9b399473380f/code_1.96.2-1734607745_amd64.deb"
        "https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb"
)

RESET='\e[0m'
ALERT='\e[033m'
OK='\e[032m'

updateAndUpgrade() {
    sudo apt update && sudo apt upgrade -y
    sudo apt autoremove
}


installApts() {
    updateAndUpgrade
    for p in "${PACKAGES[@]}"; do
        isInstalled "$p"
        res=$?
        if [ $res -eq 0 ]; then
            echo -e "${OK}[    OK   ]${RESET}O pacote $p já está instalado."
        else
            installApt "$p"
        fi
    done
}

isInstalled() {
    dpkg -l | grep -q "^ii\s\+$1"
    return $?
    
}

installApt() {
    echo -e "${ALERT}[ ATENÇÃO ]${RESET}O pacote $1 não está instalado."
    echo -e "${OK}[ ******* ]${RESET}Instalando pacote $1"
    sudo apt install $1 -y
}

dockerRemove() {
    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
}

dockerSetUpRepositories() {
    sudo apt update
    sudo apt install ca-certificates curl -y
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    updateAndUpgrade
}

dockerInstall() {
    dockerRemove
    dockerSetUpRepositories
}

downloadDebs() {
    for p in "${PACKAGES_DEB[@]}"; do
        wget $p
    done
}

installDebs() {
    downloadDebs
    archives=($(ls))
    for a in "${archives[@]}"; do 
        sudo apt install ./$a
    done
    rm *.deb
}


confirm() {
    while true; do
        echo -e "${ALERT}[ ATENÇÃO ]${RESET}O processo de instalação deve levar aproximadamente 5 minutos"
        echo "Deseja continuar ?(S/N)"
        read user_response

        if [[ "$user_response" == "s" || "$user_response" == "S" ]]; then
            init
            break
        elif [[ "$user_response" == "n" || "$user_response" == "N" ]]; then
            clear
            break
        else
            clear
            echo "Resposta inválida. Por favor, responda com 's' ou 'n'."
        fi
    done
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

init() {
    dockerInstall
    installApts
    confGit
    installDebs
}

main() {
    confirm
}

main