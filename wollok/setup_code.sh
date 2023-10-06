#!/bin/bash
# Prompt for operating system, based on it we would use a different build of the cli
TYPE=""
PS3="Select your operating system: "
select opt in linux win macos; do
    case $opt in
        linux)
            TYPE=linux
            break
        ;;
        win)
            TYPE=win.exe
            break
        ;;
        macos)
            TYPE=macos
            break
        ;;
        *) 
        echo "Invalid option $REPLY"
        ;;
    esac
done


# Installing interpreter
WOLLOK_CLI_PATH=~/wollok-ts-cli
mkdir $WOLLOK_CLI_PATH
cd $WOLLOK_CLI_PATH
git clone https://github.com/uqbar-project/wollok-ts-cli.git .
npm install
npm run build
npm run pack
mkdir -p ~/.local/bin
mv ./dist/wollok-ts-cli-$TYPE ~/.local/bin/wollok
cd ..
rm -rf $WOLLOK_CLI_PATH

# Installing extensions

# Code highlighting
code --install-extension  uqbar.wollok-highlight --force

# Language server

WOLLOK_LSP_PATH=~/wollok-lsp
mkdir $WOLLOK_LSP_PATH
cd $WOLLOK_LSP_PATH
git clone https://github.com/uqbar-project/wollok-lsp-ide.git .
npm install
npm run package
# It will only match the packaged 
code --install-extension ./*.vsix
cd ..
rm -rf $WOLLOK_LSP_PATH