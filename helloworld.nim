import Tilengine

echo "hello Gensokyo!"
var 
    frame = 0
    a = tLN_Init(400, 240, 1, 0, 0)
    fg = tLN_LoadTilemap("assets/sonic/Sonic_md_fg1.tmx", nil)
    c = tLN_SetLayer(0, nil, fg)

tLN_SetBGColor(32.cuchar, 32.cuchar, 128.cuchar)

var b = tLN_CreateWindow("Flandre", 0)
while(tLN_ProcessWindow()):
    discard tLN_SetLayerPosition(0, frame.cint, 0);
    tLN_DrawFrame(0)
    inc frame
