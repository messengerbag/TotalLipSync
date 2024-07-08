# TotalLipSync

TotalLipSync is a script module for [Adventure Game Studio (AGS)](http://www.adventuregamestudio.co.uk/). It provides voice-based lip sync by enabling games to play back speech animations that have been synchronized with voice clips.

TotalLipSync serves as an alternative to and replacement for the built-in AGS support for speech-based lip sync. The main advantages of TotalLipSync are:

* It works with LucasArts-style speech (where the on-screen character sprite animates), not just the various Sierra-style speech modes (where a portrait of the speaking character pops up)
* In addition to the PAMELA (.pam) and Moho Switch (.dat) file formats supported by AGS, it can read lip sync data in Annosoft SAPI 5.1 LipSync (.anno) and Rhubarb (.tsv) formats. This opens up a greater range of tools that can be used to do the lip syncing.

TotalLipSync is tested with AGS v3.4.1 to 3.6.1. Compatibility with versions outside this range is unknown.

## How to use: Example

1. Import the TotalLipSync module
2. Set a ten-frame lip sync animation as the character's SpeechView; it is recommended to make frame 0 the closed-mouth, silent frame (since AGS will display this frame when no animation is running)
3. Place the lip sync data files in a folder called "sync/" in the project directory*
4. In the AGS editor, add "sync" to the "Package custom data folder(s)" setting under General settings | Compiler
5. If you use a Sierra-style or full-screen speech mode, create a dummy View named `TLS_DUMMY` and give it exactly one loop and one frame.

(* In versions of AGS before 3.6.0, instead of steps 3. and 4. you must place the lip sync data files in a folder called "sync/" in the compiled game directory, e.g. "Compiled/Win/".)

Initialize TotalLipSync:

```adventure-game-studio
TotalLipSync.Init(eLipSyncRhubarb);
TotalLipSync.AutoMapPhonemes();
```

Say a lip-synced line:

```adventure-game-studio
cSnarky.SaySync("&1 This line will play a lip sync animation.");
```

As with `Character.Say()`, the "&1" prefix tells AGS to play this character, `cSnarky`'s, first speech clip. The filename of this clip should be `snar1.wav` (or .mp3 or .ogg), taking the first four letters of the character name (without the leading c), followed by the line number (with no leading zeroes). `Character.SaySync()` will also look for a corresponding lip sync file, `snar1.pam` (or .dat, .anno, .tsv, or some other extension - depending on configuration) to read the lip sync data from. If there is no "&N" speech clip prefix or no corresponding lip sync data file can be found, no animation will play.

Further documentation and support (including example animations and explanations of lip syncing) is available on the [AGS Forums](https://www.adventuregamestudio.co.uk/forums/index.php?topic=54722).

## API

### `void Character.SaySync(String message)`

Works like `Character.Say()`, but will also play a lip sync animation while the character speaks. The line must start with a "&N" speech clip prefix, and there must be a corresponding lip sync data file in the lip sync data directory.

### `void Character.SayAtSync(int x, int y, int width, String message)`

Works like `Character.SayAt()`, but will also play a lip sync animation while the character speaks. The line must start with a "&N" speech clip prefix, and there must be a corresponding lip sync data file in the lip sync data directory.

### `void TotalLipSync.Init(TotalLipSyncFileFormat lipSyncFormat, optional String fileExtension)`

Initializes TotalLipSync and selects a file format for the lip sync data to parse. This method should be called before any others. You may call it again to change to a different format. The lip sync data file format options supported (and the file extensions used by default) are:

* `eLipSyncPamelaStressed`  
  Lip sync data in Pamela format, distinguishing vowel stress (`.pam` files)
*  `eLipSyncPamelaIgnoreStress`  
  Lip sync data in Pamela format, ignoring vowel stress (`.pam` files)
*  `eLipSyncMoho`  
  Lip sync data in Moho Switch format (used by e.g. Papagayo; `.dat` files)
*  `eLipSyncAnno`  
  Lip sync data in Anno format (used by SAPI 5.1 Lipsync; `.anno` files)
*  `eLipSyncRhubarb`  
  Lip sync data in Rhubarb format (`.tsv` files)

The optional `fileExtension` parameter lets you override the expected file extension (without changing what format the file data needs to be in).

### `void TotalLipSync.SetDataDirectory(String dataDirectory)`

Sets the directory where TotalLipSync will look for lip sync data files. By defaults, this is "$DATA$/sync", which means a directory "sync" in the project folder that is packaged within the game data. (When running in AGS versions below 3.6.0, the default is instead "$INSTALLDIR$/sync".)

### `void TotalLipSync.SetFileExtension(String fileExtension)`

Sets the extension of the lip sync data files to be read by TotalLipSync. The default is one of `.pam`, `.dat`, `.anno` or `.tsv`, depending on the data format chosen in `TotalLipSync.Init()`.

### `void TotalLipSync.SetFileCasing(Casing fileCasing)`

Sets the casing (capitalization) to use when looking for lip sync data filenames. This doesn't make a difference if the system is case-insensitive (e.g. Windows) or if the directory is packaged within the game data, but does make a difference if the lip sync data files are read from the file system on a case-sensitive platform (e.g. Linux, MacOS).

The options are (using as an example the file for line &1 by character `cRoger`, with data format set to Moho ".dat" files):

* `eCasingLowerCase`
  Apply lowercase casing (`roge1.dat`)
* `eCasingDefaultCase`
  Retain default casing (the casing used in the character's script name; `Roge1.dat`)
* `eCasingUpperCase`
  Apply uppercase casing (`ROGE1.dat`)

The casing does not apply to the file extension, which should instead be set using, e.g.:

```TotalLipSync.SetFileExtension(".DAT");```

### `void TotalLipSync.SetDataFileFrameRate(int frameRate)`

Sets the frame rate of the lip sync data file. This value is used by the Pamela (.pam) and Moho Switch (.dat) formats. Default 24.

### `void TotalLipSync.SetSierraDummyView(int viewNumber)`

Sets a dummy view that is used to enable lip sync for Sierra-style and full-screen speech modes. This view must have exactly 1 loop and 1 frame, and should not be used for anything else (since it will be overwritten by this module).

This is a workaround necessary because of the way Sierra-style speech works in AGS.

### `void TotalLipSync.SetDefaultFrame(int frameNumber)`

Sets the speech view frame number to display when undefined in the sync file. (Typically corresponds to silence.) Should normally be 0.

### `void TotalLipSync.AutoMapPhonemes()`

Sets up a default ten-frame mapping of phoneme codes to animation frames. The mapping depends on the data format selected in `TotalLipSync.Init()` (because the different formats use different phoneme codes), but all map to a ten-frame SpeechView with the same ten frames.

See further documentation [here](http://www.adventuregamestudio.co.uk/forums/index.php?topic=54722.msg636559071#msg636559071).

### `void TotalLipSync.AddPhonemeMapping(String phoneme, int frame)`

Adds a mapping from a phoneme code to an animation frame that will be displayed for this phoneme. Phoneme codes are case-insensitive.

### `void TotalLipSync.AddPhonemeMappings(String phonemes, int frame)`

Adds mappings from a set of phoneme codes to an animation frame that will be displayed for those phonemes, separated by a slash '/'. Phonemes are case-insensitive.

### `void TotalLipSync.ClearPhonemeMappings()`

Clear all phoneme mappings.

### `Character* TotalLipSync.GetCurrentLipSyncingCharacter()`

Returns the character that is currently being lip synced, or `null` if none.

### `String TotalLipSync.GetCurrentPhoneme()`

Returns the phoneme code that is currently active (i.e. the phoneme being spoken at this time). Returns `null` if no character is being lip synced, and an empty String "" if a character is being lip synced but no phoneme has been set yet.

### `int TotalLipSync.GetCurrentFrame()`

Returns the animation frame (i.e. the mouth shape) that is currently being displayed. -1 if no character is currently being lip synced.

## Change Log

v0.6
-Fixed parsing of .anno files failed to close file after read
-Fixed TotalLipSync.Init() would reset Data Directory setting
-Changed sync timing to use AudioChannel.PositionMs for greater accuracy, if available
-Wrapped sync functions in Game.SkippingCutscene checks to improve game performance when skipping cut scenes
-Set to use packaged data directory ($DATA$) by default
-Added TotalLipSync.SetFileCasing() to API to support case-sensitive file systems
-Added TotalLipSync.TotalLipSync.SetDefaultFrame() to API to support arbitrary speech view setups
-Added optional file extension argument to TotalLipSync.Init() for convenience
-Reorganized code for improved readability
-Updated documentation

v0.5
-Added APIs to get the currently lip syncing character, the current phoneme and current frame

v0.4
-Fixed support for Sierra-style speech
-Minor bug fixes for edge-cases
-Documentation
