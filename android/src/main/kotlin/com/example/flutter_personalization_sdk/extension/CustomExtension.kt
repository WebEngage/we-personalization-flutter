package com.example.flutter_personalization_sdk.extension

import android.graphics.Rect
import android.view.View
import com.example.flutter_personalization_sdk.utils.Logger


fun View.isVisible(): Boolean {
    if (!isShown) {
        return false
    }
//    val actualPosition = Rect()
//    val isGlobalVisible = getGlobalVisibleRect(actualPosition)
//    Logger.d("isVisible", "$isGlobalVisible $actualPosition")
//    val screenWidth = Resources.getSystem().displayMetrics.widthPixels
//    val screenHeight = Resources.getSystem().displayMetrics.heightPixels
//    val screen = Rect(0, 0, screenWidth, screenHeight)
//    return isGlobalVisible && Rect.intersects(actualPosition, screen)
    val actualPosition = Rect()
//    this.getGlobalVisibleRect(actualPosition)
//    val screen = Rect(0, 0, this.resources.displayMetrics.widthPixels, this.resources.displayMetrics.heightPixels)
//    Logger.d("isVisible", "${actualPosition.intersect(screen)}")
    val isVisible: Boolean = getGlobalVisibleRect(actualPosition)
    val isVisibleLocal: Boolean = getLocalVisibleRect(actualPosition)

    return isVisibleLocal
}

