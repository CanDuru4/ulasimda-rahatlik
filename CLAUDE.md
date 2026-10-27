@AGENTS.md

## Claude Code

- After editing Swift, verify with the unsigned simulator `build` from AGENTS.md.
- `xcodebuild` resolves SPM packages over the network on a cold cache. Allow a long timeout (up to 10 min) on the first build.
- Edit `project.pbxproj` only when it is truly needed, such as adding a file to a target. Keep the change minimal and rebuild afterward.
