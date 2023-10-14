cd  /tmp/
mkdir game
cd game
git clone https://github.com/pdepmartestm/2023-tpgame-dulce-de-leche-tentacion.git . 
rm -rf ./sr
c
cp -r ~/Documents/college/4_programming/pdep/wollok/assignments/game/src ./src/
git add .
read $COMMIT_MESSAGE $COMMIT_DESCRIPTION
git commit -m $COMMIT_MESSAGE -m $COMMIT_DESCRIPTION 

cp ~/Documents/college/4_programming/pdep/wollok/assignments/game/readme.md ./todo.md