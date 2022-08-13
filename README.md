# Give Up Robot, 2 Speedrunning Tools

This repository is primarily for the `GUR2rainer` speedrunning tool, though there are others here as well. You can find all downloads of them listed below and in the `Releases` section above. Contact mirrorcult#9528 in the Give Up Robot speedrunning discord if you have issues. 

A basic explanation of how to get started is listed below. All projects here were created by decompiling the original GUR2 SWF (located [here](https://github.com/mirrorcult/gur2rainer/blob/master/src/assets/Give_Up_Robot_2.swf)) in the repository), re-embedding assets, replacing the decompiled `FlashPunk` engine with the exact source version used, and recompiling the game with edits until it functioned.

## Projects

This repository hosts three separate projects, all based on the same SWF recompilation process mentioned above. The branch here lists what Git branch the code is located on. The latest release is the GitHub Releases for the latest tagged release, which contains an executable download as well as source download.

### GUR2rainer

**Branch:** `master`

**Latest release:** [v1.5](https://github.com/mirrorcult/gur2rainer/releases/tag/v1.5)

**Valid for full runs:** *No*

**Valid for IL runs:** *Yes*

GUR2rainer is the primary project contained in this repository, and its commits are located on the master branch. It's a modified version of vanilla GUR2 featuring level select, a debug overlay, pause & frame advance, and a practice mode with individual-level timing.

---

### GUR2exe

**Branch:** `exe`

**Latest release:** [e2.0](https://github.com/mirrorcult/gur2rainer/releases/tag/e2.0)

**Valid for full runs:** *Yes*

**Valid for IL runs:** *Yes, but recommended to use GUR2rainer*

GUR2exe is a completely stripped down fork of GUR2rainer with no special features, outside of simple visual QoL like fullscreen mode and removal of Adult Swim branding. It also is the only version that works with the official autosplitter for LiveSplit (`e2.0` and above)

---

### GUR2aser

**Branch:** `tas`

**Latest release:** [t1.0-pre](https://github.com/mirrorcult/gur2rainer/releases/tag/t1.0-pre)

**Valid for full runs:** *No*

**Valid for IL runs:** *No*

GUR2aser is fork of GUR2rainer featuring TAS tools. It can save TAS files after successfully completed runs, and it can play back custom TAS files on any level in the game. It features a TAS debugger, frame advance, timescale modification, and much more. **GUR2aser is watermarked and is not considered valid for ANY runs of Give Up Robot, 2.**

v1.0 of the file specification for the `gtas` files used by GUR2aser is located [here](https://github.com/mirrorcult/gur2rainer/blob/tas/GTAS_SPEC.md).

---

## Compiling it Yourself

TODO sorry lol just talk to me in discord or something and i'll walk you through it

