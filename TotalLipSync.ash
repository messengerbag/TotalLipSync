//////////////////////////////////////////////////////////////////////////////////////////////////////////
// TOTAL LIP SYNC MODULE - Header
// by Gunnar Harboe (Snarky), v0.5
//
// Description:
// This module enables speech-based lip sync animation for any speech mode (while the AGS built-in 
// speech-based lip sync does not currently work for LucasArts-style speech), and supports a number of
// different file formats for the lip sync data files.
//
// Use:
// You need to generate and edit the synchronization data in an external application (see below),
// or with the AGS Lip Sync Manager plugin. This module then reads the data files created and plays
// back the animation in sync with the audio.
//
// To lip sync a character, give them a speech view where each frame has the mouth position
// for a particular sound (a "phoneme"). Frame 0 should be the "no sound"/"mouth closed" frame.
// Then set up the module to define the mapping from phonemes to frames. This is done similarly to
// the built-in speech-based lip sync described in the manual.
//
// When using this module, the built-in AGS lip sync should be set to "disabled".
//
// Configure the module on startup - for example:
// 
//     function game_start()
//     {
//       TotalLipSync.Init(eLipSyncPamelaIgnoreStress);
//       TotalLipSync.AddPhonemeMappings("None",0);
//       TotalLipSync.AddPhonemeMappings("AY/AA/AH/AE",1);
//       TotalLipSync.AddPhonemeMappings("W/OW/OY/UW",2);
//       // etc.
//     }
// 
// A default mapping for each format is also provided, and can be activated with:
//
//     TotalLipSync.AutoMapPhonemes();
//
// To use lip sync, simply call the function Character.SaySync(String message) with a speech clip
// prefix - for example:
//
//     function cOceanSpiritDennis_Interact()
//     {
//       cOceanSpiritDennis.SaySync("&13 No touching, or it's FIGHTS!");
//     }
//
// This will play speech file number 13, and (given the configuration settings above) lip sync the
// speech animation according to the data in the file ocea13.pam in the game installation directory.
// There's also Character.SayAtSync(), which works like Character.SayAt().
//
//
//
// The file formats supported by this module are:
//
// Pamela (.pam):
// This format is produced by PAMELA and the AGS Lip Sync Manager plugin.
// http://www-personal.monash.edu.au/~myless/catnap/pamela/
// http://www.adventuregamestudio.co.uk/forums/index.php?topic=37792.0
//
// Moho Switch (.dat)
// This format is used by Papagayo; PAMELA and other applications can also export to it.
// http://www.lostmarble.com/papagayo/
// 
// Annosoft (.anno)
// This is the format used by SAPI 5.1 Lipsync.
// http://www.annosoft.com/sapi_lipsync/docs/index.html
//
// Rhubarb Lip-Sync (.tsv)
// This is one format used by Rhubarb Lip-Sync, a tool developed for lip-syncing 'Thimbleweed Park'.
// https://github.com/DanielSWolf/rhubarb-lip-sync
//
//
//
// This work is licensed under a Creative Commons Attribution 4.0 International License.
// https://creativecommons.org/licenses/by/4.0/
//
// It is based on code by Steven Poulton (Calin Leafshade):
// http://www.adventuregamestudio.co.uk/forums/index.php?topic=36284.msg554642#msg554642
//
// And on AGS engine code:
// https://github.com/adventuregamestudio/ags/
// ags/Editor/AGS.Editor/Components/SpeechComponent.cs 
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////

/// The format of lip sync data files to parse
enum TotalLipSyncFileFormat
{
  /// Lip sync data in Pamela format, distinguishing vowel stress (.pam files)
  eLipSyncPamelaStressed,
  /// Lip sync data in Pamela format, ignoring vowel stress (.pam files)
  eLipSyncPamelaIgnoreStress,
  /// Lip sync data in Moho Switch format (used by e.g. Papagayo; .dat files)
  eLipSyncMoho,
  /// Lip sync data in Anno format (used by SAPI 5.1 Lipsync; .anno files)
  eLipSyncAnno, 
  /// Lip sync data in Rhubarb format (.tsv files)
  eLipSyncRhubarb
};

struct TotalLipSync
{
  /// Initializes TotalLipSync. This method should be called on startup.
  import static void Init(TotalLipSyncFileFormat lipSyncFormat);
  /// Sets the directory to read the lip sync data files from. Default "$INSTALLDIR$/sync" (a sync/ folder inside 
  import static void SetDataDirectory(String dataDirectory);
  /// Sets the file extension of the data files. Default depends on the lipSyncFormat set with TotalLipSync.Init()
  import static void SetFileExtension(String fileExtension);
  /// Sets the frame rate of the lip sync data file. Used by Pamela and Moho formats. Default 24
  import static void SetDataFileFrameRate(int frameRate);
  /// Sets a dummy view that is used to enable Sierra lip sync. This view must have exactly 1 loop and 1 frame, and should not be used for anything else (since it will be overwritten by this module).
  import static void SetSierraDummyView(int viewNumber);
  /// Sets up a default mapping of phonemes to animation frames, according to the lipSyncFormat set with TotalLipSync.Init()
  import static void AutoMapPhonemes();
  /// Adds a mapping from a phoneme to an animation frame that will be displayed for this phoneme. Phonemes are case-insensitive.
  import static void AddPhonemeMapping(String phoneme, int frame);
  /// Adds mappings from a set of phonemes to an animation frame that will be displayed for those phonemes, separated by a slash '/'. Phonemes are case-insensitive.
  import static void AddPhonemeMappings(String phonemes, int frame);
  /// Clears all phoneme mappings.
  import static void ClearPhonemeMappings();
  /// Returns the character that is currently being lip synced, or null if none.
  import static Character* GetCurrentLipSyncingCharacter();
  /// Returns the phoneme code that is currently active (i.e. the phoneme being spoken at this time). If lip sync not currently running, null. If running but no phoneme set yet, "".
  import static String GetCurrentPhoneme();
  /// Returns the animation frame (i.e. the mouth shape) that is currently being displayed. -1 if no character is currently being lip synced.
  import static int GetCurrentFrame();
};

/// Says the specified text using the character's speech settings, while playing a speech-based lip-sync animation. The line must have a speech clip prefix ("&N " where N is the number of the speech file), and there must be a matching lip-sync data file in the data directory.
import void SaySync(this Character*,  String message);
/// Says the specified text at the specified position of the screen using the character's speech settings, while playing a speech-based lip-sync animation. The line must have a speech clip prefix ("&N " where N is the number of the speech file), and there must be a matching lip-sync data file in the data directory.
import void SayAtSync(this Character*, int x, int y, int width, String message);