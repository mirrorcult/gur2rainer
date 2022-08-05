# `gtas` File Specification v1.0

`gtas` is a file format intended for use by GUR2aser. It defines how inputs should be processed on a frame-by-frame basis for TAS playback. `gtas` files are plain-text and are easily parsable by humans and machines. Their file extension is `.gtas`.

In GUR2aser, the names of `gtas` files matters for figuring out how to parse them. Information on how these names are structured is listed below.

Individual commands in `gtas` files are separated using newlines. One command does not necessarily correspond to one frame of TAS playback.

## Commands

### Input Command

Input commands can be in two forms:

```
[KEYS]
[KEYS],[FRAMEHOLD]
```

where `KEYS` define the keys to hold down with no spaces between them (or nothing, if no keys are to be held). The valid keys are as follows:

```
R (right)
L (left)
U (up / jump)
D (down)
A (grapple)
Z (grapple)
X (jump)
S (jump)
```

`FRAMEHOLD` defines how many frames the given input should last for. It defaults to **1** if no framehold is listed, as in the first case.

An empty line is a valid input command.

### Modify Timescale Command

The modify timescale command comes in one form:

```
*[MODIFIER]
```

This command is always performed immediately after the world update processing of the previous frame's inputs.

`MODIFIER` defines how much to modify the game's timescale by. A modifier of **3** would speed the game's execution up by 3x, whereas **0.25** would slow down the game by 4x. A modifier of **0** pauses the game and it can only be unpaused by the human playing back the file. Thus, the pause command mostly serves to aid an active TASer who is able to use unpause and frame advance.

## Miscellaneous Syntax

### Comments

Comments in the `gtas` format must be on their own line and must start with a pound sign, `#`.

Comments are entirely ignored and the next input is processed immediately with no delay. They exist only to aid human observers in understanding the file, and are not ever emitted by TAS recording inputs to a file.

## File Naming Format

`gtas` files are named in the following format:

```
[MODE][LEVEL]_[FRAMECOUNT].gtas
```

`MODE` and `LEVEL` respectively can be the following, level number inclusive:

- `L` (normal): 1 to 61
- `H` (hard): 1 to 13
- `S` (world start): 2 to 3
- `E` (world end): 1 to 3

`FRAMECOUNT` is the exact number of frames required to complete the level. This is not checked or enforced by playback, but will always be set when a TAS file is saved.

## Example `.gtas` file

This is a TAS file for Level 6 of Give Up Robot 1 converted into the `.gtas` format, with added comments that also explain what the file name should be.

```python
# FILENAME: L6_149.gtas

# All GUR1 TASes must start with 18 frames of inactivity, due to spawn delay.
,18
R,18
# First jump over lava.
RU
R,46
# Second jump over lava.
RU
R,33
# This grapple gives us max downwards y-speed and halts our h movement.
Z,2
LU
L,16
# Wallkick inputs.
ZU
RU
# Preserve the wallkick momentum into the end goal.
R,11
```