# Contributing to Simple Messaging

Thank you for your interest in contributing! Bug reports, fixes, documentation, testing, and thoughtful improvements are welcome.

## Before making changes

1. Read the project [README](README.md) and [development notes](docs/DEVELOPMENT.md).
2. Check existing issues and pull requests to avoid duplicating work.
3. For substantial changes, open an issue or discussion first so the proposed direction can be agreed on.

## Development setup

- Use Godot 4.7 for the main project.
- Follow the Android build instructions in the README and the AndroidAudioAEC documentation when working on Android exports.
- Keep generated build outputs, such as compiled AAR files, out of commits.

## Making a contribution

1. Fork the repository and create a focused branch.
2. Make the smallest coherent change that addresses the issue.
3. Keep platform-specific code isolated where practical.
4. Update documentation when behavior, setup, dependencies, or export steps change.
5. Test the affected functionality and report exactly what you tested.
6. Open a pull request describing the motivation, changes, and test results.

## Bug reports

Include as much relevant information as possible:

- Godot version and target platform
- Device model and OS version, when relevant
- Steps to reproduce the problem
- Expected and actual behavior
- Relevant logs or error messages

Do not include private IP addresses, passwords, tokens, personal chat content, or other sensitive information in public reports.

## Code and documentation guidelines

- Prefer clear, maintainable GDScript and Java.
- Follow the conventions already used in the surrounding files.
- Avoid adding dependencies unless they are necessary; explain new dependencies in the pull request.
- Keep documentation accurate and do not claim a feature is tested unless it has actually been tested.

## Licensing

By submitting a contribution, you agree that it may be distributed as part of Simple Messaging under the project's **GNU Affero General Public License v3.0 (AGPL-3.0)**. Make sure you have the right to submit the code or other material you contribute.

Thank you for helping make Simple Messaging better!
