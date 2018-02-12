foo_vis_shpeck, Winamp visualisation plugin wrapper for foobar2000 v0.9.5+
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 (c) 2007-2009 by Yirkha <yirkha@fud.cz>

 For the latest version and discussion please visit:
   http://www.hydrogenaudio.org/forums/index.php?showtopic=59388
 HA knowledgebase page:
   http://wiki.hydrogenaudio.org/index.php?title=Foobar2000:Components_0.9/Shpeck_(foo_vis_shpeck)

Installation:
~~~~~~~~~~~~~
  Extract foo_vis_shpeck.dll to foobar2000's component directory,
   restart the player, check Shpeck's preferences page and enjoy.

Notes:
~~~~~~
  Winamp itself doesn't need to be installed, see wiki link above for details.
  Only one plugin can be active at once because of original design limitations.
  Not all plugins can be run in a panel. Most older ones will just create their own
   window or run in fullscreen.
  Known plugins embeddable in a panel are Milkdrop v1/v2, AVS and "Classic visualisation".
   For MilkDrops, "Integrate with Winamp" needs to be checked in their configuration.
   Embedded window toolbar buttons don't work for MilkDrop 1.
  One plugin can be selected to start in panel automatically - right click on the caption
   and use the popup menu.
  AVS and Milkdrop 1 are not compatible with DEP (Data Execution Prevention) and can
   randomly crash on systems where it's active.
  Milkdrop v1.04 can't be launched unless some music is playing. Patch vis_milk.dll at
   offset 0002A12B from 74h to EBh to override this.

Changelog:
~~~~~~~~~~
v0.3.7 [2009/09/28]
  Fixed: Wrong Winamp directory path sometimes given to the plugin during initialization,
          introduced in the previous version.

v0.3.6 [2009/09/24]
  Fixed: Occasional crash when closing a Shpeck panel in CUI.
  Fixed: Plugin windows z-order follows foobar2000's main window.
  Fixed: Paths are canonicalized now (e.g. relative "..\Winamp" doesn't change when current
          directory is changed by other component).
  New: Implemented IPC_WRITEPLAYLIST.
  Warning: Google Talk works now, but be sure that registry value HKCU\Software\Winamp\(Default)
            points to the same directory as you have set in Shpeck's preferences, otherwise it
            just hangs up because of some bug on their side.

v0.3.5 [2009/05/20]
  Removed plugin version check completely for greater compatibility.
  Changed window title when not playing to an empty string again.
  New: None of Shpeck's menu entries are shown under View > Visualisations when there is no plugins found.
  Fixed: Added a workaround for EvilLyrics brokeness.
  Fixed: Clicking on visualisation doesn't focus it.
  Fixed: Embedded window of some plugins cannot be focused by clicking (MilkDrop 1).

v0.3.4 [2009/04/22]
  Fixed: Crash when managing Shpeck's Columns UI panel.
  Added some call tracking code for easier crash report classification.

v0.3.3 [2009/04/12]
  Fixed: Small power of spectrum data.

v0.3.2 [2009/04/05]
  Fixed: Improved compatibility of fake Winamp window title - songs with a dot in artist/title name.
          (Note: What was changed is the default title formatting string for currently playing track.
          If you are upgrading from previous version of Shpeck, you ought to set it to
          "%tracknumber%. [%artist%' - ']%title%" manually in the Preferences.)
  Fixed: Only DLL files matching pattern "vis_*.dll" are searched during plugin scan.
  Startup nag message about multiple detected Winamps now appears only in console.

v0.3.1 [2009/02/07]
  New: Presence of plugins DLLs is checked at startup and they are removed from the list
        if missing (e.g. after transferring configuration to a different computer).
  New: Implemented IPC_GETRATING - returns %rating%, clamped to 0..5 for compatibility.
  New: Implemented IPC_GET_EXTENDED_FILE_INFO, IPC_GET_EXTENDED_FILE_INFOW,
        IPC_GET_EXTENDED_FILE_INFO_HOOKABLE, IPC_GET_EXTENDED_FILE_INFOW_HOOKABLE.
        Checks special cases first - "length", "year" (%date%), "type" (always 0), and
        "family" (%codec%) at the moment -, then meta fields, then technical info.
  Fix: Title formatting preview sometimes doesn't work in Preferences.
  Fix: Bug when shift+clicking on [...] in Preferences multiple times.
  Fix: "Current directory" temporarily reset to foobar2000's application directory when
        loading plugins to avoid unresolved DLL dependencies. (Bug with VST wrapper)

v0.3.0 [2008/12/01]
  New: Panel button images are now stored in theme configs (will partially break your current panel configuration).
  New: Plugin (re)scan spams useful messages to console to help with troubleshooting.
  New: Better message is shown when plugin claims to be for an incompatible version of Winamp.
  New: Instant preview for titleformatting in Preferences dialog.
  New: Alternate DLL load strategy - looks for additional libraries (e.g. NSCRT.DLL) directly in the Plugins directory as well.
  New: Works as an UI element in Default UI.
  Fixed: MSVC++ Runtime library is no longer needed.
  Fixed: Better Winamp compatibility (MilkDrop 2.0e).
  Fixed: Length of title formatting in Preferences is no longer limited to window width.
  Fixed: Startup nag-screen sometimes didn't appear.
  Fixed: Unicode titles in playlist (IPC_GETPLAYLISTTITLEW).
  Fixed: Endless loop when plugin in a panel failed to initialize.
  Fixed: Plugin in a panel with Auto-stop is not stopped when the panel is hidden.
  Fixed: Hiding a CUI panel with MilkDrop1 results in "OUT OF VIDEO MEMORY" message and lockup.
  Fixed: Titlebar of CUI panel is not painted when the sidebar was shown.
  Fixed: A few other cases where panels would behave in weird ways.
  Fixed: Message about only one plugin active at once not going away.
  Fixed: Crash when switching AVS in UI element to fullscreen.

v0.2.4 [2008/05/31]
  New: Plugins which use spectrum data now use the new FFT behavior for spectrum-generating methods
        available in v0.9.5.2 and newer (normalized output, Gauss window used instead of rectangular
        for better quality & less aliasing)
  New: Embedded window titlebar customizability - background color, text color, title font and
        button images.
        Button images can be loaded from external BMP file, whose width must be divisible by 5
        (for five buttons - prev., next, random, fullscreen and menu) and its height must be
        divisible by 3 (for three states - normal, hover and pushed).
        32bit format with alpha/opacity is supported (as is the default image).
        Windows desktop settings with adaptive semi-transparent buttons are used by default.
  New: Option to prevent running plugin's thread on lower priority (might help with random pauses)
  Fix: The playlist titleformatting code could not be edited.
        I believe this bug must have been present since the first version and nobody noticed.
        Another proof that nobody cares about hacking titleformatting strings.
  Fix: Some visualizations don't need to be clicked first to get keyboard input anymore
  Fix: "???" occassionally displayed as current song title
  Fix: Titlebar disappearing after stopping plugin in a panel
  Maybe something else I don't remember, like changing the default title formatting strings.

v0.2.3
  Keyboard shortcuts not processed by plugin are correctly forwarded to the main window now
  Blank spectrum data is used when not available instead of fake "gradient"
  Contents of the default Winamp installation directory is scanned automatically on first run
  Fixed preferences page layout ("Available plugins" listbox border, scrollbars, etc.)
  Using better method to get icon for "embedded windows"

v0.2.2
  Fix: Crash on files with sample rate < 44.1 kHz or on song change between files with different sample rate.
  Fix: Reporting possibly invalid waveform/spectrum data from files with non-standard channel count.

v0.2.1
  Reverted "feature" #3 of v0.2.0.

v0.2.0
  Optimized processing of multichannel audio & spectrum data.
  More acurate waveform data are now passed to the plugins.
  The command "Next" goes to random entry if random playlist order is selected. (but see above...)
  Fix: Milkdrop 1.04 fake fullscreen option results in close.
  Fix: Closing AVS window does not stop it completely, it has to be closed again by "Shpeck/Stop" command afterwards.
  Fix: Position of the fake Winamp's window is illegal. (Now uses v2.4 skin window size @ 0,0.)
  Panel integration improvements:
    Rewritten panel embedding interface for better compatibility.
    Fix: Context menu of some plugins is not accessible because it's being overriden by the Column UI's default one.
    Fix: MilkDrop2 in panel cannot be run twice ("Can't register window class.").
    Fix: MilkDrop2/AVS in panel creates multiple windows when switching to/from fullscreen mode.

v0.1.3
  Handling of "embedded windows" changed again (saving position only if moved around, occasional behaviour)
  Fixed random preset toggling
  Fixed and added commands (seeking backwards, non-standard previous song command, repeat, shuffle)
  Fixed fake Winamp window title for compatibility (e.g. GeekAmp)
  Known issue: MilkDrop v1.04 closes itself when attempted to enter the "fake fullscreen" mode. Uncheck
   "Integrate with Winamp skin" in MilkDrop configuration to rectify temporarily.

v0.1.2
  "Wasabi services API" has been partially implemented, MilkDrop v2.0d and "Nullsoft Tiny Fullscreen" work now
  Positioning of "embedded windows" has been rewritten, position of plugin windows should stay the same between
   runs and reflect what the plugin wants correctly.
   Warning: This could have a negative impact on usage inside a CUI/DUI panel, which I haven't tested much
  "Embedded windows" now have a fb2k icon instead of windows default
  Fixed bug which caused AVS to stay active after closing its window instead of invoking "Shpeck - stop" command
  Some things I don't remember

v0.1.1
  Fixed some crash issues

v0.1.0
  Each plugin now has its own menu item, there's no need to choose the "active one" in the preferences anymore.
   (Note: Plugin list isn't refreshed automatically anymore.)
  Plugins can now be changed without manual stop-start cycle
  Plugins running in a embedded window now have a toolbar with next/prev/random/fullscreen/menu buttons to send
   commands. Can be hidden in preferences or popup menu.
  Plugins running in a embedded window now get keyboard focus correctly and can be controlled
  Title is correctly reseted when playback is stopped
  Works in Columns UI panel now, too
