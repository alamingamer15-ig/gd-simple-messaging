# AndroidAudioAEC

> **Important:** Despite living under Godot's `addons/` and having a small editor-plugin entry, this is **not a regular, self-contained Godot addon**. It is a native **Android plugin**. The editor integration only tells Godot's Android export system which compiled AAR to include. It does not provide Android audio functionality on desktop or other platforms.

This plugin exposes Android audio-mode control to GDScript in Godot 4.7.

## How it fits into the build

There are two Gradle stages:

1. This addon's Gradle project compiles the Java source into `AndroidAudioAEC.aar`.
2. Godot's Android export process (with **Gradle Build** enabled in the Android export preset) consumes that AAR and packages it into the final APK.

Building the AAR alone does not build the application APK.

## Java API

The plugin contains the static helper:

```java
AndroidAudioAEC.set_audio_mode(int mode);
```

The Godot singleton exposes the matching `set_audio_mode(int)` method, plus
`restore_audio_mode()` for restoring the mode captured before the first change.

## Build the AAR

Requirements: JDK 17, Android SDK (platform 35), and Gradle 8.9 or newer.

From the repository root:

```sh
cd addons/AndroidAudioAEC/android
gradle copyDebugAar
```

For a release AAR:

```sh
gradle copyReleaseAar
```

The tasks place the AAR at:

- `addons/AndroidAudioAEC/bin/debug/AndroidAudioAEC.aar`
- `addons/AndroidAudioAEC/bin/release/AndroidAudioAEC.aar`

The generated `bin/` directory is a build output and should not be committed. Build the AAR before exporting the Android application.

## GDScript

```gdscript
aec.set_audio_mode(aec.MODE_IN_COMMUNICATION)
```

Available mode constants are `MODE_NORMAL`, `MODE_RINGTONE`,
`MODE_IN_CALL`, and `MODE_IN_COMMUNICATION`.

The project enables the editor integration through `project.godot`. The Android export preset must use Godot's Gradle build process for the AAR to be included.
