/*
 * MainActivity32768.java
 * Keyboard emulator Seiko UC-2000, see https://github.com/azya52/seiko
 * Copyright (c) 2017, Alexander Zakharyan
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package com.azya.seiko.uc2000;

import android.app.Activity;
import android.content.Context;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.os.Bundle;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.TextView;
import android.widget.ToggleButton;

public class MainActivity32768 extends Activity {

    public final Object[][] keys = {
            {0x31, "1"}, {0x32, "2"}, {0x33, "3"}, {0x34, "4"}, {0xA5, "5"},
            {0x36, "6"}, {0x37, "7"}, {0x38, "8"}, {0x39, "9"}, {0x30, "0"},
            {0x71, "q"}, {0x77, "w"}, {0x65, "e"}, {0x72, "r"}, {0x74, "t"},
            {0x79, "y"}, {0x75, "u"}, {0x69, "i"}, {0x6F, "o"}, {0x70, "p"},
            {0x61, "a"}, {0x73, "s"}, {0x64, "d"}, {0x66, "f"}, {0x67, "g"},
            {0x68, "h"}, {0x6A, "j"}, {0x6B, "k"}, {0x6C, "l"}, {0x3F, "?"},
            {0x7A, "z"}, {0x78, "x"}, {0x63, "c"}, {0x76, "v"}, {0x62, "b"},
            {0x6E, "n"}, {0x6D, "m"}, {0x2F, "/"}, {0x2A, "*"}, {0x3E, ">"},
            {0x2B, "+"}, {0x2D, "-"}, {0x7B, "×"}, {0x7D, "÷"}, {0x3D, "="},
            {0x2E, "."}, {0x5B, "["}, {0x5D, "]"}, {0x2C, ","}, {0x3A, ":"},
            {0x06, "M-A"}, {0x07, "M-B"}, {0x10, "CAL"}, {0x1F, "CNT▲"},
            {0x0A, "▲"}, {0x09, "▶"},
            {0x20, "SPACE"}, {0x08, "◀"}, {0x0B, "▼"}, {0x0D, "RETURN"}, {0x15, "STOP"}
    };

    public final Object[][] keysShift = {
            {0x21, "!"}, {0x2F, "/"}, {0x23, "#"}, {0x24, "$"}, {0x25, "%"},
            {0x26, "&"}, {0x27, "'"}, {0x28, "("}, {0x29, ")"}, {0x5E, "^"},
            {0x51, "Q"}, {0x57, "W"}, {0x45, "E"}, {0x52, "R"}, {0x54, "T"},
            {0x59, "Y"}, {0x55, "U"}, {0x49, "I"}, {0x4F, "O"}, {0x50, "P"},
            {0x41, "A"}, {0x53, "S"}, {0x44, "D"}, {0x46, "F"}, {0x47, "G"},
            {0x48, "H"}, {0x4A, "J"}, {0x4B, "K"}, {0x4C, "L"}, {0x5F, "_"},
            {0x5A, "Z"}, {0x58, "X"}, {0x43, "C"}, {0x56, "V"}, {0x42, "B"},
            {0x4E, "N"}, {0x4D, "M"}, {0x96, "\uD83D\uDD14"}, {0x40, "@"}, {0x3C, "<"},
            {0x9B, "✆"}, {0x9C, "✈"}, {0x9D, "*"}, {0x9E, "\uD83D\uDEB6"}, {0x9F, "*"},
            {0x97, "♠"}, {0x98, "♥"}, {0x99, "♦"}, {0x9A, "♣"}, {0x3B, ";"},
            {0x06, "M-A"}, {0x07, "M-B"}, {0x10, "CAL"}, {0x12, "CNT▼"},
            {0x0A, "▲"}, {0x09, "▶"},
            {0x20, "SPACE"}, {0x08, "◀"}, {0x0B, "▼"}, {0x0D, "RETURN"}, {0x15, "STOP"}
    };

    private static final double FREQUENCY = 16386;
    private static final double SAMPLE_RATE = AudioTrack.getNativeOutputSampleRate(AudioManager.STREAM_MUSIC);
    private static final double PERIODS = 8;
    private static final double MULTIPLIER = SAMPLE_RATE/FREQUENCY;
    private static final int WORD_SIZE = 11;
    private int SAMPLES_SIZE = (int) (WORD_SIZE*PERIODS*2* MULTIPLIER);

    private AudioTrack mAudioTrack;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        AudioManager mAudioManager = (AudioManager) this.getSystemService(Context.AUDIO_SERVICE);
        mAudioManager.setStreamVolume(AudioManager.STREAM_MUSIC, mAudioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC), 0);

        SAMPLES_SIZE++;
        mAudioTrack = new AudioTrack(AudioManager.STREAM_MUSIC, (int) SAMPLE_RATE,
                AudioFormat.CHANNEL_OUT_STEREO, AudioFormat.ENCODING_PCM_16BIT,
                SAMPLES_SIZE*(Short.SIZE/8)*2, AudioTrack.MODE_STATIC);

        mAudioTrack.setAuxEffectSendLevel(0);


        ToggleButton toggle = (ToggleButton) findViewById(R.id.shiftButton);
        toggle.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    setButtons(keysShift, keys);
                } else {
                    setButtons(keys, keysShift);
                }
            }
        });

        setButtons(keys, keysShift);
    }

    private void setButtons(Object[][] keys, Object[][] keysLabels) {
        final ViewGroup viewGroup = (ViewGroup) ((ViewGroup) this
                .findViewById(android.R.id.content)).getChildAt(0);
        updateButtons(viewGroup, keys, 0);
        updateLabels(viewGroup, keysLabels, 0);
    }

    private int updateButtons(ViewGroup v, Object[][] curKeys, int keyIndex) {
        for (int i = 0; i < v.getChildCount(); i++) {
            View child = v.getChildAt(i);
            if(child instanceof ViewGroup)
                keyIndex = updateButtons((ViewGroup)child, curKeys, keyIndex);
            else if(child.getClass()==Button.class)
                if(keyIndex<curKeys.length) {
                    ((Button) child).setTag(curKeys[keyIndex][0]);
                    ((Button) child).setText((CharSequence) curKeys[keyIndex][1]);
                    ((Button) child).setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            Log.d("onClick()");
                            sendByte((Integer) view.getTag());
                        }
                    });

                    keyIndex++;
                }
        }
        return keyIndex;
    }

    private int updateLabels(ViewGroup v, Object[][] curKeys, int keyIndex) {
        for (int i = 0; i < v.getChildCount(); i++) {
            View child = v.getChildAt(i);
            if(child instanceof ViewGroup)
                keyIndex = updateLabels((ViewGroup)child, curKeys, keyIndex);
            else if(child.getClass()==TextView.class)
                if(keyIndex<curKeys.length) {
                    if(((int)curKeys[keyIndex][0]<'A' || (int)curKeys[keyIndex][0]>'Z') && ((int)curKeys[keyIndex][0]<'a' || (int)curKeys[keyIndex][0]>'z') && keys[keyIndex][0]!=keysShift[keyIndex][0]) {
                        ((TextView) child).setText((CharSequence) curKeys[keyIndex][1]);
                    }
                    keyIndex++;
                }
        }
        return keyIndex;
    }

    View.OnTouchListener keyTouch = new View.OnTouchListener(){

        @Override
        public boolean onTouch(View view, MotionEvent motionEvent) {
            switch (motionEvent.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    int keyCode = (Integer) view.getTag();
                    sendByte(keyCode);
                    break;
                case MotionEvent.ACTION_UP: break;
            }
            return false;
        }
    };

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mAudioTrack.release();
    }

    private void sendByte(int sendByte) {
        Log.d("sendByte() "+sendByte);
        int parity = sendByte^(sendByte>>4);
        parity ^= parity>>2;
        parity ^= parity>>1;
        parity &= 0x01;

        int[] wordBuffer = new int[WORD_SIZE];
        wordBuffer[0] = 1;
        for(int i=1; i<9; i++) {
            wordBuffer[i] = ~(sendByte>>(i-1)) & 0x01;
        }
        wordBuffer[9] = ~parity & 0x01;
        wordBuffer[10] = 0;

        short[] samples = new short[SAMPLES_SIZE];
        for(int i = 0; i < SAMPLES_SIZE; i += 2) {
            if (wordBuffer[(int)(i/MULTIPLIER/(PERIODS*2)) % WORD_SIZE] == 1) {
                samples[i] = (short)(Math.sin((i)*Math.PI/MULTIPLIER) * Short.MAX_VALUE);
                samples[i+1] = (short)-samples[i];
            } else {
                samples[i] = 0;// (short)(Math.sin(i*Math.PI/MULTIPLIER) * Short.MAX_VALUE/10);
                samples[i+1] = samples[i];
            }
        }

        /*
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            mAudioTrack.setVolume(AudioTrack.getMaxVolume());
        } else {
            mAudioTrack.setStereoVolume(AudioTrack.getMaxVolume(),AudioTrack.getMaxVolume());
        }
        */
        mAudioTrack.write(samples, 0, SAMPLES_SIZE);
        mAudioTrack.play();
        try {
            Thread.sleep(20);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        mAudioTrack.stop();
        mAudioTrack.reloadStaticData();
    }

}
