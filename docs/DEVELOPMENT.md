# Development notes

This guide covers the current repository setup. It is not a guarantee that every platform target is ready to ship.

## Godot project

- Open the repository root in Godot 4.7.
- The project entry point is configured in `project.godot`.
- The AndroidAudioAEC editor plugin is enabled in the project configuration.

## Android toolchain

Configure the Android SDK, JDK, and export templates in Godot's Editor Settings. The AndroidAudioAEC Gradle project currently targets Java 17 and Android SDK platform 35; its Gradle build file specifies Android Gradle Plugin 8.7.3.

Build the plugin AAR from the repository root:

```sh
cd addons/AndroidAudioAEC/android
gradle copyDebugAar
# or
gradle copyReleaseAar
```

The output files are:

- `addons/AndroidAudioAEC/bin/debug/AndroidAudioAEC.aar`
- `addons/AndroidAudioAEC/bin/release/AndroidAudioAEC.aar`

The generated `bin/` directory is not source code and should remain out of commits. Build the matching AAR before exporting the app.

In Godot, select the Android export preset and enable **Gradle Build**. The checked-in preset may need this option enabled locally; verify it in the editor before exporting.

## AndroidAudioAEC API

The plugin registers the Android singleton named `AndroidAudioAEC`. The GDScript wrapper is `Application/VoiceChat/v1/Android.gd` and defines:

- `aec.MODE_NORMAL`
- `aec.MODE_RINGTONE`
- `aec.MODE_IN_CALL`
- `aec.MODE_IN_COMMUNICATION`
- `aec.set_audio_mode(mode)`

Example:

```gdscript
aec.set_audio_mode(aec.MODE_IN_COMMUNICATION)
```

The Java helper exposes the static method `AndroidAudioAEC.set_audio_mode(int mode)`. The plugin also exposes `restore_audio_mode()`, which restores the audio mode saved before the first mode change.

**Important:** Setting Android's audio mode changes the platform audio behavior/routing mode. It does not, by itself, guarantee that acoustic echo cancellation is available or enabled on every device. Actual echo-cancellation behavior depends on the Android device, audio path, and audio effects supported by that device.

## Testing checklist

Before publishing an Android build:

1. Build the debug AAR and confirm the Gradle task succeeds.
2. Export a debug APK with Gradle Build enabled.
3. Install and launch the APK on a physical Android device.
4. Test microphone permission, speaker output, audio routing, and restoration when leaving the voice-chat scene.
5. Test network connectivity separately on the intended network types.
6. Record the Godot version, Android version, device model, and relevant logs when reporting a failure.

The plugin has not been validated on every Android device. A successful AAR build alone does not prove that the complete app export or runtime behavior works.
