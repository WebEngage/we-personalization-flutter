package com.example.flutter_personalization_sdk.extension

import android.graphics.Rect
import android.view.View


fun View.isVisible(): Boolean {
    if (!isShown) {
        return false
    }
    val actualPosition = Rect()
    return getLocalVisibleRect(actualPosition)
}

