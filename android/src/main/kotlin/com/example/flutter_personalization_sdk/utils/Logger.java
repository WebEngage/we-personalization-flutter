package com.example.flutter_personalization_sdk.utils;


import android.util.Log;

public class Logger {
    public static final int SILENT = -2;
    public static final int QUIET = -1;
    public static final int NORMAL = 0;
    public static final int DEBUG = 1;
    public static final int VERBOSE = 2;

    private static int sLogLevel = SILENT;

    public static void setLogLevel(int _sLogLevel) {
        sLogLevel = _sLogLevel;
    }

    public static void v(String c, String s) {
        if (sLogLevel >= VERBOSE && s != null) {
            Log.v(transformTAG(c), s);
        }
    }

    public static void d(String c, String s) {
        if (sLogLevel >= DEBUG && s != null) {
            Log.d(transformTAG(c), s);
        }
    }

    public static void i(String c, String s) {
        if (sLogLevel >= NORMAL) {
            Log.i(transformTAG(c), s);
        }
    }

    public static void w(String c, String s) {
        if (sLogLevel >= QUIET && s != null) {
            Log.w(transformTAG(c), s);
        }
    }

    public static void w(String c, String s, Throwable tr) {
        if (sLogLevel >= QUIET && s != null && tr != null) {
            Log.w(transformTAG(c), s, tr);
        }
    }

    public static void e(String c, String s) {
        if (sLogLevel >= SILENT && s != null) {
            Log.e(transformTAG(c), s);
        }
    }

    public static void e(String c, String s, Throwable tr) {
        if (sLogLevel >= SILENT && s != null && tr != null) {
            Log.e(transformTAG(c), s, tr);
        }
    }
    
    private static String transformTAG(String c){
        return  "WEP H : "+c;
    }

}