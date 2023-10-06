# Wollok

As third language, and final one, we use Wollok. Wollok is a purely object oriented language, and its developed by [uqbar foundation](https://uqbar.org/#/). You can check the language documentation [here](https://www.wollok.org/en/documentation/wollokdoc/).

## Just one problem...

I actually like this language and I find the fact that it was developed by our professors really engaging and interesting. Though, there is one problem, the stable, or maybe I should say the preferred, solution for using the language is through their integrated IDE which uses eclipse. And, like many people, I don't like eclipse and I would much rather be working on vscode.

Well, they are actually developing a vscode implementation which they haven't released yet but it works. I could not find any documentation or guide about its installment, so I had to figure it out a little bit (wasn't that hard tbh) so I built a script that automates that installation.

## How to wollok in vscode

### Prerequisites

-   Nodejs installed: if you don't have it, follow the instructions [here](https://nodejs.org/en).
-   If you are on windows, you need to install some bash emulator. If you installed git, you probably already have git bash!

### Steps

1. **Clone this project**: `git clone https://github.com/MarcosNicolau/miniature-sniffle`
2. **cd into the wollok folder**: `cd ./miniature-sniffle/wollok`
3. **Run the project**:
    - **linux/macos**: if you are on linux you'd have to give it permission to execute first: `chmod +x ./setup_code.sh && ./setup_code.sh`
    - **windows**: if you are on windows you'd have to run git bash with administrator permissions and the run the script: `./setup_code.sh`
4. **Check that everything went fine**: type `wollok` in the terminal and you should see usage instructions.
5. **Run your wollok apps**: `wollok repl ./<PATH_TO_WLK_FILE>`
6. That's it! So yes that is pretty much everything there is to it, you thank me later ;)

### What will this script do for you

This script does a bunch of things:

-   **Install wollok interpreter**: the cli tool to run your apps
-   **Install wollok lsp ide**: The wollok language server protocol for autocompletion, error-checking, jump-to-definition, and many other features.
-   **Install wollok highlighting**: Adds colors to the reserved language words.
