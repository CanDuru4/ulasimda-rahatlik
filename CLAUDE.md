@AGENTS.md

Compatible heavy committed-source checks prefer the gaming PC through `remote-run.py`, which handles bounded wake/connect automatically. Follow AGENTS.md for runtime/data exceptions, native checks and matching-result reuse. Do not ask for PC availability each time or silently fall back to the Mini.

## Claude Code

- After editing Swift, verify with the unsigned simulator `build` from AGENTS.md. Pass `-derivedDataPath` pointing at your scratchpad so build products stay out of `~/Library` and the repo.
- `xcodebuild` resolves SPM packages over the network on a cold cache. Allow a long timeout (up to 10 min) on the first build.
- `test` fails immediately if no iOS 17+ simulator runtime is installed (`xcrun simctl list runtimes`). Report that instead of trying to install one.
- Edit `project.pbxproj` only when it is truly needed, such as adding a file to a target. Keep the change minimal and rebuild afterward.
