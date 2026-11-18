package org.simplemessaging.androidaudioaec;

import android.content.Context;
import android.media.AudioManager;
import android.util.Log;

/**
 * Small static API for changing Android's audio mode.
 */
public final class AndroidAudioAEC {
    private static final String TAG = "AndroidAudioAEC";

    private static AudioManager audioManager;
    private static int previousMode = AudioManager.MODE_NORMAL;
    private static boolean previousModeCaptured = false;

    private AndroidAudioAEC() {
    }

    static synchronized void initialize(Context context) {
        if (context == null) {
            Log.e(TAG, "Cannot initialize without an Android context.");
            return;
        }

        Context appContext = context.getApplicationContext();
        audioManager = (AudioManager) appContext.getSystemService(Context.AUDIO_SERVICE);

        if (audioManager == null) {
            Log.e(TAG, "AudioManager service is unavailable.");
        }
    }

    /**
     * Sets AudioManager's mode. The original mode is saved on the first call
     * so restore_audio_mode() can put it back when the Godot node exits.
     */
    public static synchronized void set_audio_mode(int mode) {
        if (audioManager == null) {
            Log.e(TAG, "AudioManager is not initialized.");
            return;
        }

        if (!previousModeCaptured) {
            previousMode = audioManager.getMode();
            previousModeCaptured = true;
        }

        audioManager.setMode(mode);
    }

    public static synchronized void restore_audio_mode() {
        if (audioManager == null || !previousModeCaptured) {
            return;
        }

        audioManager.setMode(previousMode);
        previousModeCaptured = false;
    }
}
