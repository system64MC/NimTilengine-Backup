import Tilengine
import Math
import libgme

var #Declaring the frame
    frame = 0
    fg = tLN_LoadTilemap("assets/sonic/Sonic_md_fg1.tmx", nil)

discard tLN_Init(400, 240, 1, 0, 0)
discard tLN_SetLayer(0, nil, fg)
tLN_SetBGColor(32.cuchar, 32.cuchar, 128.cuchar)
tLN_SetWindowTitle("Tilengine on Nim Language")

proc raster(line: cint){.cdecl.} =
    (
        # discard tLN_SetLayerPosition(0,cint(frame + line), 0)
        discard tLN_SetLayerPosition(0, (5 * sin(degToRad(float64(line)) * 5 + PI)).cint + frame.cint, 0)
    ) 


tLN_SetRasterCallback(TLN_VideoCallback(raster))

discard tLN_CreateWindow("Flandre", Tilengine.CWF_S3)
tLN_DisableCRTEffect()

# echo 1
# var a = gmeNewEmu(gmeSpcType, 41000)
# echo 2
# discard gmeLoadFile(a, "magica.spc")
# echo 3
# discard gmeStartTrack(a, 0)
# echo 4
# var shortval = 2.cshort
# echo 5
# discard gmePlay(a, 8.cint, addr(shortval))
# echo 6
# Game Loop
while(tLN_ProcessWindow()):
    (
        discard tLN_SetLayerPosition(0, frame.cint, 0);
        tLN_DrawFrame(0)
        if(tLN_GetInput(TLN_Input.INPUT_RIGHT)):
            inc frame
        if(tLN_GetInput(TLN_Input.INPUT_LEFT)):
            dec frame
    )