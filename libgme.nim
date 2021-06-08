##  Simple game music file player

{.deadCodeElim: on.}
when defined(windows):
  const
    libgmedll* = "libgme.dll"
elif defined(macosx):
  const
    libgmedll* = "libgme.dylib"
else:
  const
    libgmedll* = "libgme.so"
##  Game music emulator library C interface (also usable from C++)
##  Game_Music_Emu 0.5.5

##  Error string returned by library functions, or NULL if no error (success)

type
  GmeErrT* = cstring

##  First parameter of most gme_ functions is a pointer to the Music_Emu

type
  MusicEmu* = ptr object

## ******* Basic operations *******
##  Create emulator and load game music file/data into it. Sets *out to new emulator.

proc gmeOpenFile*(path: ptr char; `out`: ptr ptr MusicEmu; sampleRate: cint): GmeErrT {.
    cdecl, importc: "gme_open_file", dynlib: libgmedll.}
##  Number of tracks available

proc gmeTrackCount*(a1: ptr MusicEmu): cint {.cdecl, importc: "gme_track_count",
    dynlib: libgmedll.}
##  Start a track, where 0 is the first track

proc gmeStartTrack*(a1: ptr MusicEmu; index: cint): GmeErrT {.cdecl,
    importc: "gme_start_track", dynlib: libgmedll.}
##  Generate 'count' 16-bit signed samples info 'out'. Output is in stereo.

proc gmePlay*(a1: ptr MusicEmu; count: cint; `out`: ptr cshort): GmeErrT {.cdecl,
    importc: "gme_play", dynlib: libgmedll.}
##  Finish using emulator and free memory

proc gmeDelete*(a1: ptr MusicEmu) {.cdecl, importc: "gme_delete", dynlib: libgmedll.}
## ******* Track position/length *******
##  Set time to start fading track out. Once fade ends track_ended() returns true.
## Fade time can be changed while track is playing.

proc gmeSetFade*(a1: ptr MusicEmu; startMsec: cint) {.cdecl, importc: "gme_set_fade",
    dynlib: libgmedll.}
##  True if a track has reached its end

proc gmeTrackEnded*(a1: ptr MusicEmu): cint {.cdecl, importc: "gme_track_ended",
    dynlib: libgmedll.}
##  Number of milliseconds (1000 = one second) played since beginning of track

proc gmeTell*(a1: ptr MusicEmu): cint {.cdecl, importc: "gme_tell", dynlib: libgmedll.}
##  Seek to new time in track. Seeking backwards or far forward can take a while.

proc gmeSeek*(a1: ptr MusicEmu; msec: cint): GmeErrT {.cdecl, importc: "gme_seek",
    dynlib: libgmedll.}
## ******* Informational *******
##  If you only need track information from a music file, pass gme_info_only for
## sample_rate to open/load.

const
  gmeInfoOnly* = -1

##  Most recent warning string, or NULL if none. Clears current warning after returning.
## Warning is also cleared when loading a file and starting a track.

proc gmeWarning*(a1: ptr MusicEmu): cstring {.cdecl, importc: "gme_warning",
    dynlib: libgmedll.}
##  Load m3u playlist file (must be done after loading music)

proc gmeLoadM3u*(a1: ptr MusicEmu; path: ptr char): GmeErrT {.cdecl,
    importc: "gme_load_m3u", dynlib: libgmedll.}
##  Clear any loaded m3u playlist and any internal playlist that the music format
## supports (NSFE for example).

proc gmeClearPlaylist*(a1: ptr MusicEmu) {.cdecl, importc: "gme_clear_playlist",
                                       dynlib: libgmedll.}
##  Gets information for a particular track (length, name, author, etc.).
## Must be freed after use.

#type
  #GmeInfoT* = ptr object


##  Frees track information


type
  GmeInfoT* {.bycopy.} = object
    length*: cint              ##  times in milliseconds; -1 if unknown
    ##  total length, if file specifies it
    introLength*: cint         ##  length of song up to looping section
    loopLength*: cint ##  length of looping section
                    ##  Length if available, otherwise intro_length+loop_length*2 if available,
                    ## 	otherwise a default of 150000 (2.5 minutes).
    playLength*: cint
    i4*: cint
    i5*: cint
    i6*: cint
    i7*: cint
    i8*: cint
    i9*: cint
    i10*: cint
    i11*: cint
    i12*: cint
    i13*: cint
    i14*: cint
    i15*: cint                 ##  reserved
             ##  empty string ("") if not available
    system*: cstring
    game*: cstring
    song*: cstring
    author*: cstring
    copyright*: cstring
    comment*: cstring
    dumper*: cstring
    s7*: cstring
    s8*: cstring
    s9*: cstring
    s10*: cstring
    s11*: cstring
    s12*: cstring
    s13*: cstring
    s14*: cstring
    s15*: cstring              ##  reserved

proc gmeTrackInfo*(a1: ptr MusicEmu; `out`: ptr ptr GmeInfoT; track: cint): GmeErrT {.
    cdecl, importc: "gme_track_info", dynlib: libgmedll.}

proc gmeFreeInfo*(a1: ptr GmeInfoT) {.cdecl, importc: "gme_free_info",
                                  dynlib: libgmedll.}


## ******* Advanced playback *******
##  Adjust stereo echo depth, where 0.0 = off and 1.0 = maximum. Has no effect for
## GYM, SPC, and Sega Genesis VGM music

proc gmeSetStereoDepth*(a1: ptr MusicEmu; depth: cdouble) {.cdecl,
    importc: "gme_set_stereo_depth", dynlib: libgmedll.}
##  Disable automatic end-of-track detection and skipping of silence at beginning
## if ignore is true

proc gmeIgnoreSilence*(a1: ptr MusicEmu; ignore: cint) {.cdecl,
    importc: "gme_ignore_silence", dynlib: libgmedll.}
##  Adjust song tempo, where 1.0 = normal, 0.5 = half speed, 2.0 = double speed.
## Track length as returned by track_info() assumes a tempo of 1.0.

proc gmeSetTempo*(a1: ptr MusicEmu; tempo: cdouble) {.cdecl, importc: "gme_set_tempo",
    dynlib: libgmedll.}
##  Number of voices used by currently loaded file

proc gmeVoiceCount*(a1: ptr MusicEmu): cint {.cdecl, importc: "gme_voice_count",
    dynlib: libgmedll.}
##  Name of voice i, from 0 to gme_voice_count() - 1

proc gmeVoiceName*(a1: ptr MusicEmu; i: cint): cstring {.cdecl,
    importc: "gme_voice_name", dynlib: libgmedll.}
##  Mute/unmute voice i, where voice 0 is first voice

proc gmeMuteVoice*(a1: ptr MusicEmu; index: cint; mute: cint) {.cdecl,
    importc: "gme_mute_voice", dynlib: libgmedll.}
##  Set muting state of all voices at once using a bit mask, where -1 mutes all
## voices, 0 unmutes them all, 0x01 mutes just the first voice, etc.

proc gmeMuteVoices*(a1: ptr MusicEmu; mutingMask: cint) {.cdecl,
    importc: "gme_mute_voices", dynlib: libgmedll.}
##  Frequency equalizer parameters (see gme.txt)

type
  GmeEqualizerT* {.bycopy.} = object
    treble*: cdouble           ##  -50.0 = muffled, 0 = flat, +5.0 = extra-crisp
    bass*: cdouble             ##  1 = full bass, 90 = average, 16000 = almost no bass
    d2*: cdouble
    d3*: cdouble
    d4*: cdouble
    d5*: cdouble
    d6*: cdouble
    d7*: cdouble
    d8*: cdouble
    d9*: cdouble               ##  reserved


##  Get current frequency equalizater parameters

proc gmeEqualizer*(a1: ptr MusicEmu; `out`: ptr GmeEqualizerT) {.cdecl,
    importc: "gme_equalizer", dynlib: libgmedll.}
##  Change frequency equalizer parameters

proc gmeSetEqualizer*(a1: ptr MusicEmu; eq: ptr GmeEqualizerT) {.cdecl,
    importc: "gme_set_equalizer", dynlib: libgmedll.}
##  Enables/disables most accurate sound emulation options

proc gmeEnableAccuracy*(a1: ptr MusicEmu; enabled: cint) {.cdecl,
    importc: "gme_enable_accuracy", dynlib: libgmedll.}
## ******* Game music types *******
##  Music file type identifier. Can also hold NULL.

type
  GmeTypeT* = ptr object

##  Emulator type constants for each supported file type

var
  gmeAyType*: GmeTypeT
  gmeGbsType*: GmeTypeT
  gmeGymType*: GmeTypeT
  gmeHesType*:GmeTypeT
  gmeKssType*: GmeTypeT
  gmeNsfType*: GmeTypeT
  gmeNsfeType*: GmeTypeT
  gmeSapType*: GmeTypeT
  gmeSpcType*: GmeTypeT
  gmeVgmType*: GmeTypeT
  gmeVgzType*: GmeTypeT

##  Type of this emulator

proc gmeType*(a1: ptr MusicEmu): GmeTypeT {.cdecl, importc: "gme_type",
                                       dynlib: libgmedll.}
##  Pointer to array of all music types, with NULL entry at end. Allows a player linked
## to this library to support new music types without having to be updated.

proc gmeTypeList*(): ptr GmeTypeT {.cdecl, importc: "gme_type_list", dynlib: libgmedll.}
##  Name of game system for this music file type

proc gmeTypeSystem*(a1: GmeTypeT): cstring {.cdecl, importc: "gme_type_system",
    dynlib: libgmedll.}
##  True if this music file type supports multiple tracks

proc gmeTypeMultitrack*(a1: GmeTypeT): cint {.cdecl, importc: "gme_type_multitrack",
    dynlib: libgmedll.}
## ******* Advanced file loading *******
##  Error returned if file type is not supported

var gmeWrongFileType*: cstring

##  Same as gme_open_file(), but uses file data already in memory. Makes copy of data.

proc gmeOpenData*(data: pointer; size: clong; `out`: ptr ptr MusicEmu; sampleRate: cint): GmeErrT {.
    cdecl, importc: "gme_open_data", dynlib: libgmedll.}
##  Determine likely game music type based on first four bytes of file. Returns
## string containing proper file suffix (i.e. "NSF", "SPC", etc.) or "" if
## file header is not recognized.

proc gmeIdentifyHeader*(header: pointer): cstring {.cdecl,
    importc: "gme_identify_header", dynlib: libgmedll.}
##  Get corresponding music type for file path or extension passed in.

proc gmeIdentifyExtension*(pathOrExtension: ptr char): GmeTypeT {.cdecl,
    importc: "gme_identify_extension", dynlib: libgmedll.}
##  Determine file type based on file's extension or header (if extension isn't recognized).
## Sets *type_out to type, or 0 if unrecognized or error.

proc gmeIdentifyFile*(path: ptr char; typeOut: ptr GmeTypeT): GmeErrT {.cdecl,
    importc: "gme_identify_file", dynlib: libgmedll.}
##  Create new emulator and set sample rate. Returns NULL if out of memory. If you only need
## track information, pass gme_info_only for sample_rate.

proc gmeNewEmu*(a1: GmeTypeT; sampleRate: cint): ptr MusicEmu {.cdecl,
    importc: "gme_new_emu", dynlib: libgmedll.}
##  Load music file into emulator

proc gmeLoadFile*(a1: ptr MusicEmu; path: ptr char): GmeErrT {.cdecl,
    importc: "gme_load_file", dynlib: libgmedll.}
##  Load music file from memory into emulator. Makes a copy of data passed.

proc gmeLoadData*(a1: ptr MusicEmu; data: pointer; size: clong): GmeErrT {.cdecl,
    importc: "gme_load_data", dynlib: libgmedll.}
##  Load music file using custom data reader function that will be called to
## read file data. Most emulators load the entire file in one read call.

type
  GmeReaderT* = proc (yourData: pointer; `out`: pointer; count: cint): GmeErrT {.cdecl.}

proc gmeLoadCustom*(a1: ptr MusicEmu; a2: GmeReaderT; fileSize: clong; yourData: pointer): GmeErrT {.
    cdecl, importc: "gme_load_custom", dynlib: libgmedll.}
##  Load m3u playlist file from memory (must be done after loading music)

proc gmeLoadM3uData*(a1: ptr MusicEmu; data: pointer; size: clong): GmeErrT {.cdecl,
    importc: "gme_load_m3u_data", dynlib: libgmedll.}
## ******* User data *******
##  Set/get pointer to data you want to associate with this emulator.
## You can use this for whatever you want.

proc gmeSetUserData*(a1: ptr MusicEmu; newUserData: pointer) {.cdecl,
    importc: "gme_set_user_data", dynlib: libgmedll.}
proc gmeUserData*(a1: ptr MusicEmu): pointer {.cdecl, importc: "gme_user_data",
    dynlib: libgmedll.}
##  Register cleanup function to be called when deleting emulator, or NULL to
## clear it. Passes user_data to cleanup function.

type
  GmeUserCleanupT* = proc (userData: pointer) {.cdecl.}

proc gmeSetUserCleanup*(a1: ptr MusicEmu; `func`: GmeUserCleanupT) {.cdecl,
    importc: "gme_set_user_cleanup", dynlib: libgmedll.}