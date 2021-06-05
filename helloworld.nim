import Tilengine

echo "hello Gensokyo!"
var 
    frame = 0
    fg = tLN_LoadTilemap("assets/sonic/Sonic_md_fg1.tmx", nil)

discard tLN_Init(400, 240, 1, 0, 0)
discard tLN_SetLayer(0, nil, fg)
tLN_SetBGColor(32.cuchar, 32.cuchar, 128.cuchar)

var b = tLN_CreateWindow("Flandre", 0)
while(tLN_ProcessWindow()):
    discard tLN_SetLayerPosition(0, frame.cint, 0);
    tLN_DrawFrame(0)
    if(tLN_GetInput(TLN_Input.INPUT_RIGHT)):
        inc frame
    if(tLN_GetInput(TLN_Input.INPUT_LEFT)):
        dec frame
