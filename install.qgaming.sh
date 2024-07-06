#!/bin/bash

# Variables
REPO_URL="https://github.com/querzion/app.gaming-setup.git"
BRANCH_NAME="application"  # Change this to the branch you want to clone
APP_NAME="qGaming"
INSTALL_DIR="$HOME/GitHub/$APP_NAME"
DESKTOP_FILE="$HOME/.local/share/applications/$APP_NAME.desktop"
ICON_PATH="$INSTALL_DIR/Assets/desktop-icon.png" # Modify if you have a different icon path

# Function to detect the package manager
detect_package_manager() {
    if command -v apt &> /dev/null; then
        PKG_MANAGER="apt"
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
    else
        echo "Unsupported package manager. Please install dependencies manually."
        exit 1
    fi
}

# Function to install dependencies
install_dependencies() {
    echo "Installing dependencies..."
    case $PKG_MANAGER in
        apt)
            sudo apt update
            sudo apt install -y dotnet-sdk-7.0 git
            ;;
        dnf)
            sudo dnf install -y dotnet-sdk-7.0 git
            ;;
        pacman)
            sudo pacman -Syu --noconfirm dotnet-sdk git
            ;;
    esac
}

# Function to download and build the application
download_and_build() {
    echo "Downloading the application..."
    git clone --branch $BRANCH_NAME $REPO_URL $INSTALL_DIR
    cd $INSTALL_DIR

    echo "Building the application..."
    dotnet publish -c Release -r linux-x64 --self-contained
}

# Function to create a desktop icon
create_desktop_icon() {
    echo "Creating a desktop icon..."
    cat <<EOF > $DESKTOP_FILE
[Desktop Entry]
Name=$APP_NAME
Exec=$INSTALL_DIR/bin/Release/net7.0/linux-x64/publish/$APP_NAME
Icon=$ICON_PATH
Terminal=false
Type=Application
EOF
    chmod +x $DESKTOP_FILE
}

# Main script
detect_package_manager
install_dependencies
download_and_build
create_desktop_icon

echo "Installation complete. You can find the application in the Applications menu."
