package com.azya.seiko.uc2000;

public class Log {
	public static final boolean LOG = false;
	public static final String TAG = "uc2000";

    public static void i(String tag, String string) {
        if (LOG) android.util.Log.i(tag, string);
    }
    public static void e(String tag, String string) {
        android.util.Log.e(tag, string);
    }
    public static void e(String string) {
        android.util.Log.e(TAG, string);
    }
    public static void e(String tag, String string, Throwable tr) {
        android.util.Log.e(tag, string, tr);
    }
    public static void e(String string, Throwable tr) {
        android.util.Log.e(TAG, string, tr);
    }
    public static void d(String tag, String string) {
        if (LOG) android.util.Log.d(tag, string);
    }
    public static void d(String string) {
        if (LOG) android.util.Log.d(TAG, string);
    }
    public static void v(String tag, String string) {
        if (LOG) android.util.Log.v(tag, string);
    }
    public static void w(String tag, String string) {
        if (LOG) android.util.Log.w(tag, string);
    }
}