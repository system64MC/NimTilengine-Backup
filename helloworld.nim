import Tilengine

echo "hello Gensokyo!"

var a = tLN_Init(400, 240, 3, 64, 64)

var fg = tLN_LoadTilemap("assets/sonic/Sonic_md_fg1.tmx", "")



var c = tLN_SetLayerTilemap(0, fg)

if(not c):
    echo(c)

var b = tLN_CreateWindow("Flandre", 0)
while(tLN_ProcessWindow()):
    tLN_DrawFrame(0)
