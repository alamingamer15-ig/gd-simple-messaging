# Simple Messaging

A Godot-based messaging and voice-chat application. The project is currently in active development.

> **Development status:** This repository is a work in progress. Features, networking behavior, and export settings may change. Do not assume a development build is production-ready.

## Project overview

Simple Messaging is intended for direct peer-to-peer messaging and voice communication. The repository currently contains the Godot project and an Android-specific native audio plugin.

- Engine: Godot **4.7** (see `project.godot`)
- Main language: GDScript
- Android native integration: Java, packaged as a Godot Android plugin (AAR)
- License: **GNU Affero General Public License v3.0** — see [LICENSE](LICENSE)

## Getting started

### Requirements

- Godot 4.7
- Git

Clone the repository:

```sh
git clone https://github.com/alamingamer15-ig/gd-simple-messaging.git
cd gd-simple-messaging
```

Open the folder containing `project.godot` in Godot 4.7, allow the editor to import the project, and run the project from the editor.

## Android builds

Android exports need the Android build environment configured in Godot. Install and configure the Android SDK, JDK, and Godot export templates using the official [Godot Android export documentation](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_android.html).

This project includes **AndroidAudioAEC**, a native Android plugin. Build its AAR before exporting:

```sh
cd addons/AndroidAudioAEC/android
gradle copyDebugAar
```

For a release AAR, use:

```sh
gradle copyReleaseAar
```

Then open the Android export preset and enable **Gradle Build**. Godot's Android export process uses Gradle to package the generated AAR into the application APK.

See [AndroidAudioAEC documentation](addons/AndroidAudioAEC/README.md) for build requirements, output locations, and GDScript usage. Generated AAR files are build outputs; do not commit them.

## Repository layout

```text
Application/
  Chat.gd                 Messaging UI script
  VoiceChat/
    v1/                   Voice-chat platform scripts
addons/
  AndroidAudioAEC/        Native Android audio plugin and Godot export integration
Main.tscn                 Main scene
PlayerScene.tscn          Player scene
project.godot             Godot project configuration
export_presets.cfg        Export preset configuration
```

## Contributing

Bug reports, fixes, documentation, and improvements are welcome. For changes that affect networking or platform-specific behavior, include the Godot version, target platform, steps to reproduce, and relevant logs.

Please keep platform-specific code isolated where practical, and document any new native dependencies or export steps.

## Privacy and networking

The project is designed around direct communication between peers. Network behavior is still under development, so review the current implementation and only test with people and networks you trust. Do not share private addresses, credentials, or chat content in public bug reports.

## License

Simple Messaging is distributed under the terms of the **GNU AGPL v3.0**. See the [LICENSE](LICENSE) file for the complete terms.
