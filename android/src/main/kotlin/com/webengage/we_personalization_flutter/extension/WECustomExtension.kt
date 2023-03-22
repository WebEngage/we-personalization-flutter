package com.webengage.we_personalization_flutter.extension

import android.graphics.Rect
import android.view.View


fun View.isVisible(): Boolean {
    if (!isShown) {
        return false
    }
    val actualPosition = Rect()
    return getLocalVisibleRect(actualPosition)
}

