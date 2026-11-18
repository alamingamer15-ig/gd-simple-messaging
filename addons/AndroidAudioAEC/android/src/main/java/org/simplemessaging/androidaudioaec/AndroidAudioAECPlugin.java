package org.simplemessaging.androidaudioaec;

import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.GodotPlugin;
import org.godotengine.godot.plugin.UsedByGodot;

/**
 * Godot-facing bridge for the AndroidAudioAEC static helper.
 */
public final class AndroidAudioAECPlugin extends GodotPlugin {

    public AndroidAudioAECPlugin(Godot godot) {
        super(godot);
        AndroidAudioAEC.initialize(getActivity());
    }

    @Override
    public String getPluginName() {
        return "AndroidAudioAEC";
    }

    @UsedByGodot
    public void set_audio_mode(int mode) {
        AndroidAudioAEC.set_audio_mode(mode);
    }

    @UsedByGodot
    public void restore_audio_mode() {
        AndroidAudioAEC.restore_audio_mode();
    }
}
