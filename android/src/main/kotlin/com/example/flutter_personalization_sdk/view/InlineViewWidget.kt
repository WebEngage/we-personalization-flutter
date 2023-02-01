package com.example.flutter_personalization_sdk.view

import android.content.Context
import android.util.TypedValue
import android.view.LayoutInflater
import android.view.ViewTreeObserver
import android.widget.FrameLayout
import com.example.flutter_personalization_sdk.R
import com.example.flutter_personalization_sdk.extension.isVisible
import com.example.flutter_personalization_sdk.handler.CallbackHandler
import com.example.flutter_personalization_sdk.handler.ScreenNavigatorCallback
import com.example.flutter_personalization_sdk.model.WEGInline
import com.example.flutter_personalization_sdk.registry.DataRegistry
import com.example.flutter_personalization_sdk.utils.*
import com.webengage.personalization.WEInlineView
import com.webengage.personalization.callbacks.WEPlaceholderCallback
import com.webengage.personalization.data.WECampaignData
import java.lang.Exception

class InlineViewWidget(
    context: Context,
    val payload: HashMap<String, Any>?,
    val parentWidget: InlineWidget

) : FrameLayout(context), WEPlaceholderCallback, ScreenNavigatorCallback {

    val wegInline: WEGInline;

    init {
        wegInline = generateWEInline()
        initView(payload)
    }

    private fun initView(payload: HashMap<String, Any>?) {

        val tag = payload?.get(PAYLOAD_ANDROID_PROPERTY_ID) as String
        val viewWidth = payload[PAYLOAD_VIEW_WIDTH] as Double
        val viewHeight = payload[PAYLOAD_VIEW_HEIGHT] as Double
        CallbackHandler.instance.setScreenNavigatorCallback(
            payload[PAYLOAD_SCREEN_NAME] as String,
            this
        )
        var view = LayoutInflater.from(context).inflate(
            R.layout.layout_inlineviewwidget,
            this, false
        )

        val weInlineView = view.findViewById<WEInlineView>(R.id.weinline_widget)
        weInlineView.tag = tag

        val param = weInlineView.layoutParams

        if (viewHeight > 0) {
            val height = TypedValue.applyDimension(
                TypedValue.COMPLEX_UNIT_DIP,
                (viewHeight as Double).toFloat(),
                resources.displayMetrics
            )
            param.height = height.toInt()
        }

        if (viewWidth > 0) {
            val width = TypedValue.applyDimension(
                TypedValue.COMPLEX_UNIT_DIP,
                (viewWidth as Double).toFloat(),
                resources.displayMetrics
            )
            param.width = width.toInt()
        }

        addView(view)
        loadView(weInlineView)
    }

    private fun generateWEInline(): WEGInline {
        return WEGInline(
            id = payload!![PAYLOAD_ID] as Int,
            screenName = payload!![PAYLOAD_SCREEN_NAME] as String,
            propertyID = payload!![PAYLOAD_ANDROID_PROPERTY_ID] as String
        )
    }

    private fun loadView(weInlineView: WEInlineView) {
        Logger.e("loadView", "${weInlineView.tag} ${wegInline.id} ${wegInline.screenName}")
        weInlineView.load(weInlineView.tag as String, this)
    }

    override fun onDataReceived(data: WECampaignData) {
        Logger.e("onDataReceived", "${data.targetViewId}")
        parentWidget.sendCallback(METHOD_NAME_ON_DATA_RECEIVED, Utils.generateMap(wegInline, data))
    }

    override fun onPlaceholderException(
        campaignId: String?,
        targetViewId: String,
        error: Exception
    ) {
        Logger.e("onPlaceholderException", error.message)
        parentWidget.sendCallback(
            METHOD_NAME_ON_PLACEHOLDER_EXCEPTION,
            Utils.generateMap(wegInline, campaignId, targetViewId, error)
        )
    }

    override fun onRendered(data: WECampaignData) {
        Logger.e("onRendered", "${data.targetViewId}")
        sendImpression(data)
        parentWidget.sendCallback(METHOD_NAME_ON_RENDERED, Utils.generateMap(wegInline, data))
    }

    private fun sendImpression(data: WECampaignData) {
        if (isVisible()) {
            data.trackImpression()
            Logger.e("sendImpression", "${data.targetViewId}")
        } else {
            viewTreeObserver.addOnGlobalLayoutListener(object :
                ViewTreeObserver.OnGlobalLayoutListener {
                override fun onGlobalLayout() {
                    if (isVisible()) {
                        Logger.e("sendImpression", "${data.targetViewId}")
                        data.trackImpression()
                        viewTreeObserver.removeOnGlobalLayoutListener(this)
                    }
                }

            })
        }
    }

    override fun screenNavigated(screenName: String) {
        loadView(findViewById(R.id.weinline_widget))
    }

    override fun onDetachedFromWindow() {
        payload?.let {
            CallbackHandler.instance.removeScreenNavigatorCallback(
                it[PAYLOAD_SCREEN_NAME] as String,
                this
            )
        }

        super.onDetachedFromWindow()
    }

}