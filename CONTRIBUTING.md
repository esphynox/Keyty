# Contributing

Thanks for considering a contribution to Keyty.

## Before You Start

Read the relevant project docs:

- Local setup and workflow: [Docs/DEVELOPING.md](Docs/DEVELOPING.md)
- Build and test commands: [Docs/BUILD.md](Docs/BUILD.md)
- macOS permissions: [Docs/PERMISSIONS.md](Docs/PERMISSIONS.md)
- Privacy model: [Docs/PRIVACY.md](Docs/PRIVACY.md)
- Release process: [Docs/RELEASING.md](Docs/RELEASING.md)

## Development Workflow

The main app lives in `Apps/Keyty`.

From `Apps/Keyty`:

```bash
tuist generate
xcodebuild build \
  -project Keyty.xcodeproj \
  -scheme Keyty \
  -configuration Debug

xcodebuild test \
  -project Keyty.xcodeproj \
  -scheme Keyty \
  -destination 'platform=macOS'
```

Run `tuist generate` after changing Tuist manifests, dependencies, build settings, resources, or generated project structure.

## Tests

Add or update focused XCTest coverage for behavior changes.

Match test paths to source areas under `Apps/Keyty/Tests/KeytyTests`.

Event transformer tests may depend on keyboard layout behavior. Preserve existing assumptions unless the change intentionally updates them.

## Pull Requests

Before opening a pull request:

- Run the relevant focused tests.
- Run the full test suite when practical.
- Include screenshots or screen recordings for visible UI changes.
- Update docs when behavior, setup, permissions, privacy, or release steps change.
- Call out any effect on input capture, local settings, update checks, signing, or macOS permissions.

Use the pull request template and keep the summary specific to the change.
