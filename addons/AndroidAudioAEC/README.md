# AndroidAudioAEC

Godot 4.7 Android plugin exposing Android audio-mode control to GDScript.

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

The generated `bin/` directory is intentionally not committed. Build the AAR
before exporting the Android application.

## GDScript

```gdscript
aec.set_audio_mode(aec.MODE_IN_COMMUNICATION)
```

Available mode constants are `MODE_NORMAL`, `MODE_RINGTONE`,
`MODE_IN_CALL`, and `MODE_IN_COMMUNICATION`.

The Android export preset must use the Gradle build process. The project enables
this editor plugin through `project.godot`.
