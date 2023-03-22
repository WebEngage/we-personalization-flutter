package com.webengage.we_personalization_flutter.utils

import android.util.Log

class WELogger {

    companion object {
        const val SILENT = -2
        const val QUIET = -1
        const val NORMAL = 0
        const val DEBUG = 1
        const val VERBOSE = 2
        private var sLogLevel = SILENT
        fun setLogLevel(_sLogLevel: Int) {
            sLogLevel = _sLogLevel
        }

        fun v(c: String?, s: String?) {
            if (sLogLevel >= VERBOSE && s != null) {
                Log.v(c, s)
            }
        }

        fun d(c: String?, s: String?) {
            if (sLogLevel >= DEBUG && s != null) {
                Log.d(c, s)
            }
        }

        fun i(c: String?, s: String?) {
            if (sLogLevel >= NORMAL) {
                Log.i(c, s!!)
            }
        }

        fun w(c: String?, s: String?) {
            if (sLogLevel >= QUIET && s != null) {
                Log.w(c, s)
            }
        }

        fun w(c: String?, s: String?, tr: Throwable?) {
            if (sLogLevel >= QUIET && s != null && tr != null) {
                Log.w(c, s, tr)
            }
        }

        fun e(c: String?, s: String?) {
            if (sLogLevel >= SILENT && s != null) {
                Log.e(c, s)
            }
        }

        fun e(c: String?, s: String?, tr: Throwable?) {
            if (sLogLevel >= SILENT && s != null && tr != null) {
                Log.e(c, s, tr)
            }
        }
    }

}