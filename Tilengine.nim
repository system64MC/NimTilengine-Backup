##
##  Tilengine - The 2D retro graphics engine with raster effects
##  Copyright (C) 2015-2019 Marc Palacios Domenech <mailto:megamarc@hotmail.com>
##  All rights reserved
## 
##  Nim binding by System64
##
##  This Source Code Form is subject to the terms of the Mozilla Public
##  License, v. 2.0. If a copy of the MPL was not distributed with this
##  file, You can obtain one at http://mozilla.org/MPL/2.0/.
##

{.deadCodeElim: on.}
when defined(windows):
  const
    tilenginedll* = "tilengine.dll"
elif defined(macosx):
  const
    tilenginedll* = "tilengine.dylib"
else:
  const
    tilenginedll* = "libTilengine.so"

##  version

type
  int8T* = char
    ## !< signed 8-bit wide data
type
    int16T* = cshort
    ## !< signed 16-bit wide data
type
    int32T* = cint
    ## !< signed 32-bit wide data
type
    uint8T* = cuchar
    ## !< unsigned 8-bit wide data
type
    uint16T* = cushort
    ## !< unsigned 16-bit wide data
type
    uint32T* = cuint

const
  TILENGINE_VER_MAJ* = 2
  TILENGINE_VER_MIN* = 8
  TILENGINE_VER_REV* = 5
  TILENGINE_HEADER_VERSION* = ((Tilengine_Ver_Maj shl 16) or
      (Tilengine_Ver_Min shl 8) or Tilengine_Ver_Rev)

template bitval*(n: untyped): untyped =
  (1 shl (n))

## ! tile/sprite flags. Can be none or a combination of the following:

type
  TLN_TileFlags* {.size: sizeof(cint).} = enum
    FLAG_NONE = 0,              ## !< no flags
    FLAG_MASKED = bitval(11)    ## !< sprite won't be drawn inside masked region
    FLAG_PRIORITY = bitval(12), ## !< tile goes in front of sprite layer
    FLAG_ROTATE = bitval(13),   ## !< row/column flip (unsupported, Tiled compatibility)
    FLAG_FLIPY = bitval(14),    ## !< vertical flip
    FLAG_FLIPX = bitval(15),    ## !< horizontal flip


## !
##  layer blend modes. Must be one of these and are mutually exclusive:
##

type
  TLN_Blend* {.size: sizeof(cint).} = enum
    BLEND_NONE,               ## !< blending disabled
    BLEND_MIX25,              ## !< color averaging 1
    BLEND_MIX50,              ## !< color averaging 2
    BLEND_MIX75,              ## !< color averaging 3
    BLEND_ADD,                ## !< color is always brighter (simulate light effects)
    BLEND_SUB,                ## !< color is always darker (simulate shadow effects)
    BLEND_MOD,                ## !< color is always darker (simulate shadow effects)
    BLEND_CUSTOM,             ## !< user provided blend function with TLN_SetCustomBlendFunction()
    MAX_BLEND, 


## ! Affine transformation parameters

type
  TLN_Affine* {.bycopy.} = object
    angle*: cfloat             ## !< rotation in degrees
    dx*: cfloat                ## !< horizontal translation
    dy*: cfloat                ## !< vertical translation
    sx*: cfloat                ## !< horizontal scaling
    sy*: cfloat                ## !< vertical scaling


## ! Tile item for Tilemap access methods

type
  INNER_C_STRUCT_Tilengine_132* {.bycopy.} = object
    index*: uint16T            ## !< tile index
    flags*: uint16T            ## !< attributes (FLAG_FLIPX, FLAG_FLIPY, FLAG_PRIORITY)

  Tile* {.bycopy, union.} = object
    value*: uint32T
    anoTilengine132*: INNER_C_STRUCT_Tilengine_132


## ! frame animation definition

type
  TLN_SequenceFrame* {.bycopy.} = object
    index*: cint               ## !< tile/sprite index
    delay*: cint               ## !< time delay for next frame


## ! color strip definition

type
  TLN_ColorStrip* {.bycopy.} = object
    delay*: cint               ## !< time delay between frames
    first*: uint8T             ## !< index of first color to cycle
    count*: uint8T             ## !< number of colors in the cycle
    dir*: uint8T               ## !< direction: 0=descending, 1=ascending


## ! sequence info returned by TLN_GetSequenceInfo

type
  TLN_SequenceInfo* {.bycopy.} = object
    name*: array[32, char]      ## !< sequence name
    numFrames*: cint           ## !< number of frames


## ! Sprite creation info for TLN_CreateSpriteset()

type
  TLN_SpriteData* {.bycopy.} = object
    name*: array[64, char]      ## !< entry name
    x*: cint                   ## !< horizontal position
    y*: cint                   ## !< vertical position
    w*: cint                   ## !< width
    h*: cint                   ## !< height


## ! Sprite information

type
  TLN_SpriteInfo* {.bycopy.} = object
    w*: cint                   ## !< width of sprite
    h*: cint                   ## !< height of sprite


## ! Tile information returned by TLN_GetLayerTile()

type
  TLN_TileInfo* {.bycopy.} = object
    index*: uint16T            ## !< tile index
    flags*: uint16T            ## !< attributes (FLAG_FLIPX, FLAG_FLIPY, FLAG_PRIORITY)
    row*: cint                 ## !< row number in the tilemap
    col*: cint                 ## !< col number in the tilemap
    xoffset*: cint             ## !< horizontal position inside the title
    yoffset*: cint             ## !< vertical position inside the title
    color*: uint8T             ## !< color index at collision point
    `type`*: uint8T            ## !< tile type
    empty*: bool               ## !< cell is empty


## ! Object item info returned by TLN_GetObjectInfo()

type
  TLN_ObjectInfo* {.bycopy.} = object
    id*: uint16T               ## !< unique ID
    gid*: uint16T              ## !< graphic ID (tile index)
    flags*: uint16T            ## !< attributes (FLAG_FLIPX, FLAG_FLIPY, FLAG_PRIORITY)
    x*: cint                   ## !< horizontal position
    y*: cint                   ## !< vertical position
    width*: cint               ## !< horizontal size
    height*: cint              ## !< vertical size
    `type`*: uint8T            ## !< type property
    visible*: bool             ## !< visible property
    name*: array[64, char]      ## !< name property


## ! Tileset attributes for TLN_CreateTileset()

type
  TLN_TileAttributes* {.bycopy.} = object
    `type`*: uint8T            ## !< tile type
    priority*: bool            ## !< priority flag set


## ! overlays for CRT effect

type
  TLN_Overlay* {.size: sizeof(cint).} = enum
    TLN_OVERLAY_NONE,         ## !< no overlay
    TLN_OVERLAY_SHADOWMASK,   ## !< Shadow mask pattern
    TLN_OVERLAY_APERTURE,     ## !< Aperture grille pattern
    TLN_OVERLAY_SCANLINES,    ## !< Scanlines pattern
    TLN_OVERLAY_CUSTOM,       ## !< User-provided when calling TLN_CreateWindow()
    TLN_MAX_OVERLAY


## ! pixel mapping for TLN_SetLayerPixelMapping()

type
  TLN_PixelMap* {.bycopy.} = object
    dx*: int16T                ## ! horizontal pixel displacement
    dy*: int16T                ## ! vertical pixel displacement

#  TLN_Engine* = ptr engine

type
  TLN_Engine* = ptr object


## !< Engine context

#type
#  TLN_Tile* = ptr tile

type
  TLN_Tile* = ptr object

## !< Tile reference

#type
#  TLN_Tileset* = ptr tileset

type
  TLN_Tileset* = ptr object

## !< Opaque tileset reference

#type
#  TLN_Tilemap* = ptr tilemap

type
  TLN_Tilemap* = ptr object

## !< Opaque tilemap reference

#type
#  TLN_Palette* = ptr palette

type
  TLN_Palette* = ptr object

## !< Opaque palette reference

#type
#  TLN_Spriteset* = ptr spriteset

type
  TLN_Spriteset* = ptr object

## !< Opaque sspriteset reference

#type
#  TLN_Sequence* = ptr sequence

type
  TLN_Sequence* = ptr object

## !< Opaque sequence reference

#type
#  TLN_SequencePack* = ptr sequencePack

type
  TLN_SequencePack* = ptr object

## !< Opaque sequence pack reference

#type
#  TLN_Bitmap* = ptr bitmap

type
  TLN_Bitmap* = ptr object

## !< Opaque bitmap reference

#type
#  TLN_ObjectList* = ptr objectList

type
  TLN_ObjectList* = ptr object

## !< Opaque object list reference
## ! Image Tile items for TLN_CreateImageTileset()

type
  TLN_TileImage* {.bycopy.} = object
    bitmap*: TLN_Bitmap
    id*: uint16T
    `type`*: uint8T


## ! Sprite state

type
  TLN_SpriteState* {.bycopy.} = object
    x*: cint                   ## !< Screen position x
    y*: cint                   ## !< Screen position y
    w*: cint                   ## !< Actual width in screen (after scaling)
    h*: cint                   ## !< Actual height in screen (after scaling)
    flags*: uint32T            ## !< flags
    palette*: TLN_Palette      ## !< assigned palette
    spriteset*: TLN_Spriteset  ## !< assigned spriteset
    index*: cint               ## !< graphic index inside spriteset
    enabled*: bool             ## !< enabled or not
    collision*: bool           ## !< per-pixel collision detection enabled or not


##  callbacks

type
  SDLEvent {.importc: "SDL_Event", bycopy.} = object
  TLN_VideoCallback* = proc (scanline: cint) {.cdecl.}
  TLN_BlendFunction* = proc (src: uint8T; dst: uint8T): uint8T {.cdecl.}
  TLN_SDLCallback* = proc (a1: ptr SDL_Event) {.cdecl.}

## ! Player index for input assignment functions

type
  TLN_Player = enum
    PLAYER1
    PLAYER2
    PLAYER3
    PLAYER4

type
  TLN_Input* {.size: sizeof(cint).} = enum
    INPUT_NONE
    INPUT_UP
    INPUT_DOWN
    INPUT_LEFT
    INPUT_RIGHT
    INPUT_BUTTON1
    INPUT_BUTTON2
    INPUT_BUTTON3
    INPUT_BUTTON4
    INPUT_BUTTON5
    INPUT_BUTTON6
    INPUT_START
    INPUT_QUIT
    INPUT_CRT

    INPUT_P2 = (PLAYER2.int shl 5)
    INPUT_P3 = (PLAYER3.int shl 5)
    INPUT_P4 = (PLAYER4.int shl 5)

const
    INPUT_P1 = (PLAYER1.int shl 5) # Duplicate value, was equal to zer
    INPUT_A = INPUT_BUTTON1
    INPUT_B = INPUT_BUTTON2
    INPUT_C = INPUT_BUTTON3
    INPUT_D = INPUT_BUTTON4
    INPUT_E = INPUT_BUTTON5
    INPUT_F = INPUT_BUTTON6


## ! CreateWindow flags. Can be none or a combination of the following:

const
  CWF_FULLSCREEN* = (1 shl 0)     ## !< create a fullscreen window
  CWF_VSYNC* = (1 shl 1)          ## !< sync frame updates with vertical retrace
  CWF_S1* = (1 shl 2)             ## !< create a window the same size as the framebuffer
  CWF_S2* = (2 shl 2)             ## !< create a window 2x the size the framebuffer
  CWF_S3* = (3 shl 2)             ## !< create a window 3x the size the framebuffer
  CWF_S4* = (4 shl 2)             ## !< create a window 4x the size the framebuffer
  CWF_S5* = (5 shl 2)             ## !< create a window 5x the size the framebuffer
  CWF_NEAREST* = (1 shl 6)        ## <! unfiltered upscaling

## ! Error codes

type
  TLN_Error* {.size: sizeof(cint).} = enum
    TLN_ERR_OK,               ## !< No error
    TLN_ERR_OUT_OF_MEMORY,    ## !< Not enough memory
    TLN_ERR_IDX_LAYER,        ## !< Layer index out of range
    TLN_ERR_IDX_SPRITE,       ## !< Sprite index out of range
    TLN_ERR_IDX_ANIMATION,    ## !< Animation index out of range
    TLN_ERR_IDX_PICTURE,      ## !< Picture or tile index out of range
    TLN_ERR_REF_TILESET,      ## !< Invalid TLN_Tileset reference
    TLN_ERR_REF_TILEMAP,      ## !< Invalid TLN_Tilemap reference
    TLN_ERR_REF_SPRITESET,    ## !< Invalid TLN_Spriteset reference
    TLN_ERR_REF_PALETTE,      ## !< Invalid TLN_Palette reference
    TLN_ERR_REF_SEQUENCE,     ## !< Invalid TLN_Sequence reference
    TLN_ERR_REF_SEQPACK,      ## !< Invalid TLN_SequencePack reference
    TLN_ERR_REF_BITMAP,       ## !< Invalid TLN_Bitmap reference
    TLN_ERR_NULL_POINTER,     ## !< Null pointer as argument
    TLN_ERR_FILE_NOT_FOUND,   ## !< Resource file not found
    TLN_ERR_WRONG_FORMAT,     ## !< Resource file has invalid format
    TLN_ERR_WRONG_SIZE,       ## !< A width or height parameter is invalid
    TLN_ERR_UNSUPPORTED,      ## !< Unsupported function
    TLN_ERR_REF_LIST,         ## !< Invalid TLN_ObjectList reference
    TLN_MAX_ERR


## ! Debug level

type
  TLN_LogLevel* {.size: sizeof(cint).} = enum
    TLN_LOG_NONE,             ## !< Don't print anything (default)
    TLN_LOG_ERRORS,           ## !< Print only runtime errors
    TLN_LOG_VERBOSE           ## !< Print everything


## *@}

## *
##  \defgroup setup
##  \brief Basic setup and management
##  @{

proc tLN_Init*(hres: cint; vres: cint; numlayers: cint; numsprites: cint;
              numanimations: cint): TLN_Engine {.cdecl, importc: "TLN_Init",
    dynlib: tilenginedll.}
proc tLN_Deinit*() {.cdecl, importc: "TLN_Deinit", dynlib: tilenginedll.}
proc tLN_DeleteContext*(context: TLN_Engine): bool {.cdecl,
    importc: "TLN_DeleteContext", dynlib: tilenginedll.}
proc tLN_SetContext*(context: TLN_Engine): bool {.cdecl, importc: "TLN_SetContext",
    dynlib: tilenginedll.}
proc tLN_GetContext*(): TLN_Engine {.cdecl, importc: "TLN_GetContext",
                                  dynlib: tilenginedll.}
proc tLN_GetWidth*(): cint {.cdecl, importc: "TLN_GetWidth", dynlib: tilenginedll.}
proc tLN_GetHeight*(): cint {.cdecl, importc: "TLN_GetHeight", dynlib: tilenginedll.}
proc tLN_GetNumObjects*(): uint32T {.cdecl, importc: "TLN_GetNumObjects",
                                  dynlib: tilenginedll.}
proc tLN_GetUsedMemory*(): uint32T {.cdecl, importc: "TLN_GetUsedMemory",
                                  dynlib: tilenginedll.}
proc tLN_GetVersion*(): uint32T {.cdecl, importc: "TLN_GetVersion",
                               dynlib: tilenginedll.}
proc tLN_GetNumLayers*(): cint {.cdecl, importc: "TLN_GetNumLayers",
                              dynlib: tilenginedll.}
proc tLN_GetNumSprites*(): cint {.cdecl, importc: "TLN_GetNumSprites",
                               dynlib: tilenginedll.}
proc tLN_SetBGColor*(r: uint8T; g: uint8T; b: uint8T) {.cdecl,
    importc: "TLN_SetBGColor", dynlib: tilenginedll.}
proc tLN_SetBGColorFromTilemap*(tilemap: TLN_Tilemap): bool {.cdecl,
    importc: "TLN_SetBGColorFromTilemap", dynlib: tilenginedll.}
proc tLN_DisableBGColor*() {.cdecl, importc: "TLN_DisableBGColor",
                           dynlib: tilenginedll.}
proc tLN_SetBGBitmap*(bitmap: TLN_Bitmap): bool {.cdecl, importc: "TLN_SetBGBitmap",
    dynlib: tilenginedll.}
proc tLN_SetBGPalette*(palette: TLN_Palette): bool {.cdecl,
    importc: "TLN_SetBGPalette", dynlib: tilenginedll.}
proc tLN_SetRasterCallback*(a1: TLN_VideoCallback) {.cdecl,
    importc: "TLN_SetRasterCallback", dynlib: tilenginedll.}
proc tLN_SetFrameCallback*(a1: TLN_VideoCallback) {.cdecl,
    importc: "TLN_SetFrameCallback", dynlib: tilenginedll.}
proc tLN_SetRenderTarget*(data: ptr uint8T; pitch: cint) {.cdecl,
    importc: "TLN_SetRenderTarget", dynlib: tilenginedll.}
proc tLN_UpdateFrame*(frame: cint) {.cdecl, importc: "TLN_UpdateFrame",
                                  dynlib: tilenginedll.}
proc tLN_SetLoadPath*(path: cstring) {.cdecl, importc: "TLN_SetLoadPath",
                                    dynlib: tilenginedll.}
proc tLN_SetCustomBlendFunction*(a1: TLN_BlendFunction) {.cdecl,
    importc: "TLN_SetCustomBlendFunction", dynlib: tilenginedll.}
proc tLN_SetLogLevel*(logLevel: TLN_LogLevel) {.cdecl, importc: "TLN_SetLogLevel",
    dynlib: tilenginedll.}
proc tLN_OpenResourcePack*(filename: cstring; key: cstring): bool {.cdecl,
    importc: "TLN_OpenResourcePack", dynlib: tilenginedll.}
proc tLN_CloseResourcePack*() {.cdecl, importc: "TLN_CloseResourcePack",
                              dynlib: tilenginedll.}
## *@}
## *
##  \defgroup errors
##  \brief Basic setup and management
##  @{

proc tLN_SetLastError*(error: TLN_Error) {.cdecl, importc: "TLN_SetLastError",
                                        dynlib: tilenginedll.}
proc tLN_GetLastError*(): TLN_Error {.cdecl, importc: "TLN_GetLastError",
                                   dynlib: tilenginedll.}
proc tLN_GetErrorString*(error: TLN_Error): cstring {.cdecl,
    importc: "TLN_GetErrorString", dynlib: tilenginedll.}
## *@}
## *
##  \defgroup windowing
##  \brief Built-in window and input management
##  @{

proc tLN_CreateWindow*(overlay: cstring; flags: cint): bool {.cdecl,
    importc: "TLN_CreateWindow", dynlib: tilenginedll.}
proc tLN_CreateWindowThread*(overlay: cstring; flags: cint): bool {.cdecl,
    importc: "TLN_CreateWindowThread", dynlib: tilenginedll.}
proc tLN_SetWindowTitle*(title: cstring) {.cdecl, importc: "TLN_SetWindowTitle",
                                        dynlib: tilenginedll.}
proc tLN_ProcessWindow*(): bool {.cdecl, importc: "TLN_ProcessWindow",
                               dynlib: tilenginedll.}
proc tLN_IsWindowActive*(): bool {.cdecl, importc: "TLN_IsWindowActive",
                                dynlib: tilenginedll.}
proc tLN_GetInput*(id: TLN_Input): bool {.cdecl, importc: "TLN_GetInput",
                                      dynlib: tilenginedll.}
proc tLN_EnableInput*(player: TLN_Player; enable: bool) {.cdecl,
    importc: "TLN_EnableInput", dynlib: tilenginedll.}
proc tLN_AssignInputJoystick*(player: TLN_Player; index: cint) {.cdecl,
    importc: "TLN_AssignInputJoystick", dynlib: tilenginedll.}
proc tLN_DefineInputKey*(player: TLN_Player; input: TLN_Input; keycode: uint32T) {.
    cdecl, importc: "TLN_DefineInputKey", dynlib: tilenginedll.}
proc tLN_DefineInputButton*(player: TLN_Player; input: TLN_Input; joybutton: uint8T) {.
    cdecl, importc: "TLN_DefineInputButton", dynlib: tilenginedll.}
proc tLN_DrawFrame*(frame: cint) {.cdecl, importc: "TLN_DrawFrame",
                                dynlib: tilenginedll.}
proc tLN_WaitRedraw*() {.cdecl, importc: "TLN_WaitRedraw", dynlib: tilenginedll.}
proc tLN_DeleteWindow*() {.cdecl, importc: "TLN_DeleteWindow", dynlib: tilenginedll.}
proc tLN_EnableBlur*(mode: bool) {.cdecl, importc: "TLN_EnableBlur",
                                dynlib: tilenginedll.}
proc tLN_EnableCRTEffect*(overlay: TLN_Overlay; overlayFactor: uint8T;
                         threshold: uint8T; v0: uint8T; v1: uint8T; v2: uint8T;
                         v3: uint8T; blur: bool; glowFactor: uint8T) {.cdecl,
    importc: "TLN_EnableCRTEffect", dynlib: tilenginedll.}
proc tLN_DisableCRTEffect*() {.cdecl, importc: "TLN_DisableCRTEffect",
                             dynlib: tilenginedll.}
proc tLN_SetSDLCallback*(a1: TLN_SDLCallback) {.cdecl,
    importc: "TLN_SetSDLCallback", dynlib: tilenginedll.}
proc tLN_Delay*(msecs: uint32T) {.cdecl, importc: "TLN_Delay", dynlib: tilenginedll.}
proc tLN_GetTicks*(): uint32T {.cdecl, importc: "TLN_GetTicks", dynlib: tilenginedll.}
proc tLN_GetWindowWidth*(): cint {.cdecl, importc: "TLN_GetWindowWidth",
                                dynlib: tilenginedll.}
proc tLN_GetWindowHeight*(): cint {.cdecl, importc: "TLN_GetWindowHeight",
                                 dynlib: tilenginedll.}
## *@}
## *
##  \defgroup spriteset
##  \brief Spriteset resources management for sprites
##  @{

proc tLN_CreateSpriteset*(bitmap: TLN_Bitmap; data: ptr TLN_SpriteData;
                         numEntries: cint): TLN_Spriteset {.cdecl,
    importc: "TLN_CreateSpriteset", dynlib: tilenginedll.}
proc tLN_LoadSpriteset*(name: cstring): TLN_Spriteset {.cdecl,
    importc: "TLN_LoadSpriteset", dynlib: tilenginedll.}
proc tLN_CloneSpriteset*(src: TLN_Spriteset): TLN_Spriteset {.cdecl,
    importc: "TLN_CloneSpriteset", dynlib: tilenginedll.}
proc tLN_GetSpriteInfo*(spriteset: TLN_Spriteset; entry: cint;
                       info: ptr TLN_SpriteInfo): bool {.cdecl,
    importc: "TLN_GetSpriteInfo", dynlib: tilenginedll.}
proc tLN_GetSpritesetPalette*(spriteset: TLN_Spriteset): TLN_Palette {.cdecl,
    importc: "TLN_GetSpritesetPalette", dynlib: tilenginedll.}
proc tLN_FindSpritesetSprite*(spriteset: TLN_Spriteset; name: cstring): cint {.cdecl,
    importc: "TLN_FindSpritesetSprite", dynlib: tilenginedll.}
proc tLN_SetSpritesetData*(spriteset: TLN_Spriteset; entry: cint;
                          data: ptr TLN_SpriteData; pixels: pointer; pitch: cint): bool {.
    cdecl, importc: "TLN_SetSpritesetData", dynlib: tilenginedll.}
proc tLN_DeleteSpriteset*(spriteset: TLN_Spriteset): bool {.cdecl,
    importc: "TLN_DeleteSpriteset", dynlib: tilenginedll.}
## *@}
## *
##  \defgroup tileset
##  \brief Tileset resources management for background layers
##  @{

proc tLN_CreateTileset*(numtiles: cint; width: cint; height: cint;
                       palette: TLN_Palette; sp: TLN_SequencePack;
                       attributes: ptr TLN_TileAttributes): TLN_Tileset {.cdecl,
    importc: "TLN_CreateTileset", dynlib: tilenginedll.}
proc tLN_CreateImageTileset*(numtiles: cint; images: ptr TLN_TileImage): TLN_Tileset {.
    cdecl, importc: "TLN_CreateImageTileset", dynlib: tilenginedll.}
proc tLN_LoadTileset*(filename: cstring): TLN_Tileset {.cdecl,
    importc: "TLN_LoadTileset", dynlib: tilenginedll.}
proc tLN_CloneTileset*(src: TLN_Tileset): TLN_Tileset {.cdecl,
    importc: "TLN_CloneTileset", dynlib: tilenginedll.}
proc tLN_SetTilesetPixels*(tileset: TLN_Tileset; entry: cint; srcdata: ptr uint8T;
                          srcpitch: cint): bool {.cdecl,
    importc: "TLN_SetTilesetPixels", dynlib: tilenginedll.}
proc tLN_GetTileWidth*(tileset: TLN_Tileset): cint {.cdecl,
    importc: "TLN_GetTileWidth", dynlib: tilenginedll.}
proc tLN_GetTileHeight*(tileset: TLN_Tileset): cint {.cdecl,
    importc: "TLN_GetTileHeight", dynlib: tilenginedll.}
proc tLN_GetTilesetNumTiles*(tileset: TLN_Tileset): cint {.cdecl,
    importc: "TLN_GetTilesetNumTiles", dynlib: tilenginedll.}
proc tLN_GetTilesetPalette*(tileset: TLN_Tileset): TLN_Palette {.cdecl,
    importc: "TLN_GetTilesetPalette", dynlib: tilenginedll.}
proc tLN_GetTilesetSequencePack*(tileset: TLN_Tileset): TLN_SequencePack {.cdecl,
    importc: "TLN_GetTilesetSequencePack", dynlib: tilenginedll.}
proc tLN_DeleteTileset*(tileset: TLN_Tileset): bool {.cdecl,
    importc: "TLN_DeleteTileset", dynlib: tilenginedll.}
## *@}
## *
##  \defgroup tilemap
##  \brief Tilemap resources management for background layers
##  @{

proc tLN_CreateTilemap*(rows: cint; cols: cint; tiles: TLN_Tile; bgcolor: uint32T;
                       tileset: TLN_Tileset): TLN_Tilemap {.cdecl,
    importc: "TLN_CreateTilemap", dynlib: tilenginedll.}
proc tLN_LoadTilemap*(filename: cstring; layername: cstring): TLN_Tilemap {.cdecl,
    importc: "TLN_LoadTilemap", dynlib: tilenginedll.}
proc tLN_CloneTilemap*(src: TLN_Tilemap): TLN_Tilemap {.cdecl,
    importc: "TLN_CloneTilemap", dynlib: tilenginedll.}
proc tLN_GetTilemapRows*(tilemap: TLN_Tilemap): cint {.cdecl,
    importc: "TLN_GetTilemapRows", dynlib: tilenginedll.}
proc tLN_GetTilemapCols*(tilemap: TLN_Tilemap): cint {.cdecl,
    importc: "TLN_GetTilemapCols", dynlib: tilenginedll.}
proc tLN_GetTilemapTileset*(tilemap: TLN_Tilemap): TLN_Tileset {.cdecl,
    importc: "TLN_GetTilemapTileset", dynlib: tilenginedll.}
proc tLN_GetTilemapTile*(tilemap: TLN_Tilemap; row: cint; col: cint; tile: TLN_Tile): bool {.
    cdecl, importc: "TLN_GetTilemapTile", dynlib: tilenginedll.}
proc tLN_SetTilemapTile*(tilemap: TLN_Tilemap; row: cint; col: cint; tile: TLN_Tile): bool {.
    cdecl, importc: "TLN_SetTilemapTile", dynlib: tilenginedll.}
proc tLN_CopyTiles*(src: TLN_Tilemap; srcrow: cint; srccol: cint; rows: cint; cols: cint;
                   dst: TLN_Tilemap; dstrow: cint; dstcol: cint): bool {.cdecl,
    importc: "TLN_CopyTiles", dynlib: tilenginedll.}
proc tLN_DeleteTilemap*(tilemap: TLN_Tilemap): bool {.cdecl,
    importc: "TLN_DeleteTilemap", dynlib: tilenginedll.}
## *@}
## *
##  \defgroup palette
##  \brief Color palette resources management for sprites and background layers
##  @{

proc tLN_CreatePalette*(entries: cint): TLN_Palette {.cdecl,
    importc: "TLN_CreatePalette", dynlib: tilenginedll.}
proc tLN_LoadPalette*(filename: cstring): TLN_Palette {.cdecl,
    importc: "TLN_LoadPalette", dynlib: tilenginedll.}
proc tLN_ClonePalette*(src: TLN_Palette): TLN_Palette {.cdecl,
    importc: "TLN_ClonePalette", dynlib: tilenginedll.}
proc tLN_SetPaletteColor*(palette: TLN_Palette; color: cint; r: uint8T; g: uint8T;
                         b: uint8T): bool {.cdecl, importc: "TLN_SetPaletteColor",
    dynlib: tilenginedll.}
proc tLN_MixPalettes*(src1: TLN_Palette; src2: TLN_Palette; dst: TLN_Palette;
                     factor: uint8T): bool {.cdecl, importc: "TLN_MixPalettes",
    dynlib: tilenginedll.}
proc tLN_AddPaletteColor*(palette: TLN_Palette; r: uint8T; g: uint8T; b: uint8T;
                         start: uint8T; num: uint8T): bool {.cdecl,
    importc: "TLN_AddPaletteColor", dynlib: tilenginedll.}
proc tLN_SubPaletteColor*(palette: TLN_Palette; r: uint8T; g: uint8T; b: uint8T;
                         start: uint8T; num: uint8T): bool {.cdecl,
    importc: "TLN_SubPaletteColor", dynlib: tilenginedll.}
proc tLN_ModPaletteColor*(palette: TLN_Palette; r: uint8T; g: uint8T; b: uint8T;
                         start: uint8T; num: uint8T): bool {.cdecl,
    importc: "TLN_ModPaletteColor", dynlib: tilenginedll.}
proc tLN_GetPaletteData*(palette: TLN_Palette; index: cint): ptr uint8T {.cdecl,
    importc: "TLN_GetPaletteData", dynlib: tilenginedll.}
proc tLN_DeletePalette*(palette: TLN_Palette): bool {.cdecl,
    importc: "TLN_DeletePalette", dynlib: tilenginedll.}
## *@}
## *
##  \defgroup bitmap
##  \brief Bitmap management
##  @{

proc tLN_CreateBitmap*(width: cint; height: cint; bpp: cint): TLN_Bitmap {.cdecl,
    importc: "TLN_CreateBitmap", dynlib: tilenginedll.}
proc tLN_LoadBitmap*(filename: cstring): TLN_Bitmap {.cdecl,
    importc: "TLN_LoadBitmap", dynlib: tilenginedll.}
proc tLN_CloneBitmap*(src: TLN_Bitmap): TLN_Bitmap {.cdecl,
    importc: "TLN_CloneBitmap", dynlib: tilenginedll.}
proc tLN_GetBitmapPtr*(bitmap: TLN_Bitmap; x: cint; y: cint): ptr uint8T {.cdecl,
    importc: "TLN_GetBitmapPtr", dynlib: tilenginedll.}
proc tLN_GetBitmapWidth*(bitmap: TLN_Bitmap): cint {.cdecl,
    importc: "TLN_GetBitmapWidth", dynlib: tilenginedll.}
proc tLN_GetBitmapHeight*(bitmap: TLN_Bitmap): cint {.cdecl,
    importc: "TLN_GetBitmapHeight", dynlib: tilenginedll.}
proc tLN_GetBitmapDepth*(bitmap: TLN_Bitmap): cint {.cdecl,
    importc: "TLN_GetBitmapDepth", dynlib: tilenginedll.}
proc tLN_GetBitmapPitch*(bitmap: TLN_Bitmap): cint {.cdecl,
    importc: "TLN_GetBitmapPitch", dynlib: tilenginedll.}
proc tLN_GetBitmapPalette*(bitmap: TLN_Bitmap): TLN_Palette {.cdecl,
    importc: "TLN_GetBitmapPalette", dynlib: tilenginedll.}
proc tLN_SetBitmapPalette*(bitmap: TLN_Bitmap; palette: TLN_Palette): bool {.cdecl,
    importc: "TLN_SetBitmapPalette", dynlib: tilenginedll.}
proc tLN_DeleteBitmap*(bitmap: TLN_Bitmap): bool {.cdecl,
    importc: "TLN_DeleteBitmap", dynlib: tilenginedll.}
## *@}
## *
##  \defgroup objects
##  \brief ObjectList resources management
##  @{

proc tLN_CreateObjectList*(): TLN_ObjectList {.cdecl,
    importc: "TLN_CreateObjectList", dynlib: tilenginedll.}
proc tLN_AddTileObjectToList*(list: TLN_ObjectList; id: uint16T; gid: uint16T;
                             flags: uint16T; x: cint; y: cint): bool {.cdecl,
    importc: "TLN_AddTileObjectToList", dynlib: tilenginedll.}
proc tLN_LoadObjectList*(filename: cstring; layername: cstring): TLN_ObjectList {.
    cdecl, importc: "TLN_LoadObjectList", dynlib: tilenginedll.}
proc tLN_CloneObjectList*(src: TLN_ObjectList): TLN_ObjectList {.cdecl,
    importc: "TLN_CloneObjectList", dynlib: tilenginedll.}
proc tLN_GetListNumObjects*(list: TLN_ObjectList): cint {.cdecl,
    importc: "TLN_GetListNumObjects", dynlib: tilenginedll.}
proc tLN_GetListObject*(list: TLN_ObjectList; info: ptr TLN_ObjectInfo): bool {.cdecl,
    importc: "TLN_GetListObject", dynlib: tilenginedll.}
proc tLN_DeleteObjectList*(list: TLN_ObjectList): bool {.cdecl,
    importc: "TLN_DeleteObjectList", dynlib: tilenginedll.}
## *@}
## *
##  \defgroup layer
##  \brief Background layers management
##  @{

proc tLN_SetLayer*(nlayer: cint; tileset: TLN_Tileset; tilemap: TLN_Tilemap): bool {.
    cdecl, importc: "TLN_SetLayer", dynlib: tilenginedll.}
proc tLN_SetLayerTilemap*(nlayer: cint; tilemap: TLN_Tilemap): bool {.cdecl,
    importc: "TLN_SetLayerTilemap", dynlib: tilenginedll.}
proc tLN_SetLayerBitmap*(nlayer: cint; bitmap: TLN_Bitmap): bool {.cdecl,
    importc: "TLN_SetLayerBitmap", dynlib: tilenginedll.}
proc tLN_SetLayerPalette*(nlayer: cint; palette: TLN_Palette): bool {.cdecl,
    importc: "TLN_SetLayerPalette", dynlib: tilenginedll.}
proc tLN_SetLayerPosition*(nlayer: cint; hstart: cint; vstart: cint): bool {.cdecl,
    importc: "TLN_SetLayerPosition", dynlib: tilenginedll.}
proc tLN_SetLayerScaling*(nlayer: cint; xfactor: cfloat; yfactor: cfloat): bool {.cdecl,
    importc: "TLN_SetLayerScaling", dynlib: tilenginedll.}
proc tLN_SetLayerAffineTransform*(nlayer: cint; affine: ptr TLN_Affine): bool {.cdecl,
    importc: "TLN_SetLayerAffineTransform", dynlib: tilenginedll.}
proc tLN_SetLayerTransform*(layer: cint; angle: cfloat; dx: cfloat; dy: cfloat;
                           sx: cfloat; sy: cfloat): bool {.cdecl,
    importc: "TLN_SetLayerTransform", dynlib: tilenginedll.}
proc tLN_SetLayerPixelMapping*(nlayer: cint; table: ptr TLN_PixelMap): bool {.cdecl,
    importc: "TLN_SetLayerPixelMapping", dynlib: tilenginedll.}
proc tLN_SetLayerBlendMode*(nlayer: cint; mode: TLN_Blend; factor: uint8T): bool {.
    cdecl, importc: "TLN_SetLayerBlendMode", dynlib: tilenginedll.}
proc tLN_SetLayerColumnOffset*(nlayer: cint; offset: ptr cint): bool {.cdecl,
    importc: "TLN_SetLayerColumnOffset", dynlib: tilenginedll.}
proc tLN_SetLayerClip*(nlayer: cint; x1: cint; y1: cint; x2: cint; y2: cint): bool {.cdecl,
    importc: "TLN_SetLayerClip", dynlib: tilenginedll.}
proc tLN_DisableLayerClip*(nlayer: cint): bool {.cdecl,
    importc: "TLN_DisableLayerClip", dynlib: tilenginedll.}
proc tLN_SetLayerMosaic*(nlayer: cint; width: cint; height: cint): bool {.cdecl,
    importc: "TLN_SetLayerMosaic", dynlib: tilenginedll.}
proc tLN_DisableLayerMosaic*(nlayer: cint): bool {.cdecl,
    importc: "TLN_DisableLayerMosaic", dynlib: tilenginedll.}
proc tLN_ResetLayerMode*(nlayer: cint): bool {.cdecl, importc: "TLN_ResetLayerMode",
    dynlib: tilenginedll.}
proc tLN_SetLayerObjects*(nlayer: cint; objects: TLN_ObjectList; tileset: TLN_Tileset): bool {.
    cdecl, importc: "TLN_SetLayerObjects", dynlib: tilenginedll.}
proc tLN_SetLayerPriority*(nlayer: cint; enable: bool): bool {.cdecl,
    importc: "TLN_SetLayerPriority", dynlib: tilenginedll.}
proc tLN_SetLayerParent*(nlayer: cint; parent: cint): bool {.cdecl,
    importc: "TLN_SetLayerParent", dynlib: tilenginedll.}
proc tLN_DisableLayerParent*(nlayer: cint): bool {.cdecl,
    importc: "TLN_DisableLayerParent", dynlib: tilenginedll.}
proc tLN_DisableLayer*(nlayer: cint): bool {.cdecl, importc: "TLN_DisableLayer",
    dynlib: tilenginedll.}
proc tLN_GetLayerPalette*(nlayer: cint): TLN_Palette {.cdecl,
    importc: "TLN_GetLayerPalette", dynlib: tilenginedll.}
proc tLN_GetLayerTile*(nlayer: cint; x: cint; y: cint; info: ptr TLN_TileInfo): bool {.
    cdecl, importc: "TLN_GetLayerTile", dynlib: tilenginedll.}
proc tLN_GetLayerWidth*(nlayer: cint): cint {.cdecl, importc: "TLN_GetLayerWidth",
    dynlib: tilenginedll.}
proc tLN_GetLayerHeight*(nlayer: cint): cint {.cdecl, importc: "TLN_GetLayerHeight",
    dynlib: tilenginedll.}
## *@}
## *
##  \defgroup sprite
##  \brief Sprites management
##  @{

proc tLN_ConfigSprite*(nsprite: cint; spriteset: TLN_Spriteset; flags: uint32T): bool {.
    cdecl, importc: "TLN_ConfigSprite", dynlib: tilenginedll.}
proc tLN_SetSpriteSet*(nsprite: cint; spriteset: TLN_Spriteset): bool {.cdecl,
    importc: "TLN_SetSpriteSet", dynlib: tilenginedll.}
proc tLN_SetSpriteFlags*(nsprite: cint; flags: uint32T): bool {.cdecl,
    importc: "TLN_SetSpriteFlags", dynlib: tilenginedll.}
proc tLN_EnableSpriteFlag*(nsprite: cint; flag: uint32T; enable: bool): bool {.cdecl,
    importc: "TLN_EnableSpriteFlag", dynlib: tilenginedll.}
proc tLN_SetSpritePosition*(nsprite: cint; x: cint; y: cint): bool {.cdecl,
    importc: "TLN_SetSpritePosition", dynlib: tilenginedll.}
proc tLN_SetSpritePicture*(nsprite: cint; entry: cint): bool {.cdecl,
    importc: "TLN_SetSpritePicture", dynlib: tilenginedll.}
proc tLN_SetSpritePalette*(nsprite: cint; palette: TLN_Palette): bool {.cdecl,
    importc: "TLN_SetSpritePalette", dynlib: tilenginedll.}
proc tLN_SetSpriteBlendMode*(nsprite: cint; mode: TLN_Blend; factor: uint8T): bool {.
    cdecl, importc: "TLN_SetSpriteBlendMode", dynlib: tilenginedll.}
proc tLN_SetSpriteScaling*(nsprite: cint; sx: cfloat; sy: cfloat): bool {.cdecl,
    importc: "TLN_SetSpriteScaling", dynlib: tilenginedll.}
proc tLN_ResetSpriteScaling*(nsprite: cint): bool {.cdecl,
    importc: "TLN_ResetSpriteScaling", dynlib: tilenginedll.}
## TLNAPI bool TLN_SetSpriteRotation (int nsprite, float angle);
## TLNAPI bool TLN_ResetSpriteRotation (int nsprite);

proc tLN_GetSpritePicture*(nsprite: cint): cint {.cdecl,
    importc: "TLN_GetSpritePicture", dynlib: tilenginedll.}
proc tLN_GetAvailableSprite*(): cint {.cdecl, importc: "TLN_GetAvailableSprite",
                                    dynlib: tilenginedll.}
proc tLN_EnableSpriteCollision*(nsprite: cint; enable: bool): bool {.cdecl,
    importc: "TLN_EnableSpriteCollision", dynlib: tilenginedll.}
proc tLN_GetSpriteCollision*(nsprite: cint): bool {.cdecl,
    importc: "TLN_GetSpriteCollision", dynlib: tilenginedll.}
proc tLN_GetSpriteState*(nsprite: cint; state: ptr TLN_SpriteState): bool {.cdecl,
    importc: "TLN_GetSpriteState", dynlib: tilenginedll.}
proc tLN_SetFirstSprite*(nsprite: cint): bool {.cdecl, importc: "TLN_SetFirstSprite",
    dynlib: tilenginedll.}
proc tLN_SetNextSprite*(nsprite: cint; next: cint): bool {.cdecl,
    importc: "TLN_SetNextSprite", dynlib: tilenginedll.}
proc tLN_EnableSpriteMasking*(nsprite: cint; enable: bool): bool {.cdecl,
    importc: "TLN_EnableSpriteMasking", dynlib: tilenginedll.}
proc tLN_SetSpritesMaskRegion*(topLine: cint; bottomLine: cint) {.cdecl,
    importc: "TLN_SetSpritesMaskRegion", dynlib: tilenginedll.}
proc tLN_SetSpriteAnimation*(nsprite: cint; sequence: TLN_Sequence; loop: cint): bool {.
    cdecl, importc: "TLN_SetSpriteAnimation", dynlib: tilenginedll.}
proc tLN_DisableSpriteAnimation*(nsprite: cint): bool {.cdecl,
    importc: "TLN_DisableSpriteAnimation", dynlib: tilenginedll.}
proc tLN_DisableSprite*(nsprite: cint): bool {.cdecl, importc: "TLN_DisableSprite",
    dynlib: tilenginedll.}
proc tLN_GetSpritePalette*(nsprite: cint): TLN_Palette {.cdecl,
    importc: "TLN_GetSpritePalette", dynlib: tilenginedll.}
## *@}
## *
##  \defgroup sequence
##  \brief Sequence resources management for layer, sprite and palette animations
##  @{

proc tLN_CreateSequence*(name: cstring; target: cint; numFrames: cint;
                        frames: ptr TLN_SequenceFrame): TLN_Sequence {.cdecl,
    importc: "TLN_CreateSequence", dynlib: tilenginedll.}
proc tLN_CreateCycle*(name: cstring; numStrips: cint; strips: ptr TLN_ColorStrip): TLN_Sequence {.
    cdecl, importc: "TLN_CreateCycle", dynlib: tilenginedll.}
proc tLN_CreateSpriteSequence*(name: cstring; spriteset: TLN_Spriteset;
                              basename: cstring; delay: cint): TLN_Sequence {.cdecl,
    importc: "TLN_CreateSpriteSequence", dynlib: tilenginedll.}
proc tLN_CloneSequence*(src: TLN_Sequence): TLN_Sequence {.cdecl,
    importc: "TLN_CloneSequence", dynlib: tilenginedll.}
proc tLN_GetSequenceInfo*(sequence: TLN_Sequence; info: ptr TLN_SequenceInfo): bool {.
    cdecl, importc: "TLN_GetSequenceInfo", dynlib: tilenginedll.}
proc tLN_DeleteSequence*(sequence: TLN_Sequence): bool {.cdecl,
    importc: "TLN_DeleteSequence", dynlib: tilenginedll.}
## *@}
## *
##  \defgroup sequencepack
##  \brief Sequence pack manager for grouping and finding sequences
##  @{

proc tLN_CreateSequencePack*(): TLN_SequencePack {.cdecl,
    importc: "TLN_CreateSequencePack", dynlib: tilenginedll.}
proc tLN_LoadSequencePack*(filename: cstring): TLN_SequencePack {.cdecl,
    importc: "TLN_LoadSequencePack", dynlib: tilenginedll.}
proc tLN_GetSequence*(sp: TLN_SequencePack; index: cint): TLN_Sequence {.cdecl,
    importc: "TLN_GetSequence", dynlib: tilenginedll.}
proc tLN_FindSequence*(sp: TLN_SequencePack; name: cstring): TLN_Sequence {.cdecl,
    importc: "TLN_FindSequence", dynlib: tilenginedll.}
proc tLN_GetSequencePackCount*(sp: TLN_SequencePack): cint {.cdecl,
    importc: "TLN_GetSequencePackCount", dynlib: tilenginedll.}
proc tLN_AddSequenceToPack*(sp: TLN_SequencePack; sequence: TLN_Sequence): bool {.
    cdecl, importc: "TLN_AddSequenceToPack", dynlib: tilenginedll.}
proc tLN_DeleteSequencePack*(sp: TLN_SequencePack): bool {.cdecl,
    importc: "TLN_DeleteSequencePack", dynlib: tilenginedll.}
## *@}
## *
##  \defgroup animation
##  \brief Color cycle animation
##  @{

proc tLN_SetPaletteAnimation*(index: cint; palette: TLN_Palette;
                             sequence: TLN_Sequence; blend: bool): bool {.cdecl,
    importc: "TLN_SetPaletteAnimation", dynlib: tilenginedll.}
proc tLN_SetPaletteAnimationSource*(index: cint; a2: TLN_Palette): bool {.cdecl,
    importc: "TLN_SetPaletteAnimationSource", dynlib: tilenginedll.}
proc tLN_GetAnimationState*(index: cint): bool {.cdecl,
    importc: "TLN_GetAnimationState", dynlib: tilenginedll.}
proc tLN_SetAnimationDelay*(index: cint; frame: cint; delay: cint): bool {.cdecl,
    importc: "TLN_SetAnimationDelay", dynlib: tilenginedll.}
proc tLN_GetAvailableAnimation*(): cint {.cdecl,
                                       importc: "TLN_GetAvailableAnimation",
                                       dynlib: tilenginedll.}
proc tLN_DisablePaletteAnimation*(index: cint): bool {.cdecl,
    importc: "TLN_DisablePaletteAnimation", dynlib: tilenginedll.}
## *@}

let bruh = "SNES is better than Genesis"