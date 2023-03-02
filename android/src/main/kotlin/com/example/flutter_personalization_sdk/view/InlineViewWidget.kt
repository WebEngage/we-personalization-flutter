package com.example.flutter_personalization_sdk.view

import android.content.Context
import android.graphics.Color
import android.util.TypedValue
import android.view.LayoutInflater
import android.view.View
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
import com.webengage.personalization.utils.TAG
import com.webengage.sdk.android.Logger

class InlineViewWidget(
    context: Context,
    private val payload: HashMap<String, Any>?,
    private val parentWidget: InlineWidget

) : FrameLayout(context), WEPlaceholderCallback, ScreenNavigatorCallback {

    private val wegInline: WEGInline
    var weInlineView: WEInlineView? = null
    var tag = ""

    init {
        setLayerType(LAYER_TYPE_NONE, null);
        wegInline = generateWEInline()
        initView(payload)

    }

    fun getWEGInlineView(): WEGInline {
        return wegInline
    }


    private fun initView(payload: HashMap<String, Any>?) {
       // setLayerType(LAYER_TYPE_SOFTWARE, null);
        Logger.e("initView", "InitView called for $payload")
        tag = payload?.get(PAYLOAD_ANDROID_PROPERTY_ID) as String
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

        weInlineView = view.findViewById(R.id.weinline_widget)
        // weInlineView!!.tag = tag

        val param = weInlineView!!.layoutParams

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
        loadView(weInlineView!!)
    }

    private fun generateWEInline(): WEGInline {
        return WEGInline(
            id = payload!![PAYLOAD_ID] as Int,
            screenName = payload[PAYLOAD_SCREEN_NAME] as String,
            propertyID = payload[PAYLOAD_ANDROID_PROPERTY_ID] as String
        )
    }

    private fun loadView(weInlineView: WEInlineView) {
        Logger.e("loadView", "${weInlineView.tag} ${wegInline.id} ${wegInline.screenName}")
        weInlineView.load(tag, this)
    }

    override fun onDataReceived(data: WECampaignData) {
        Logger.e("onDataReceived", "${data.targetViewId}")
        wegInline.weCampaignData = data
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
        Logger.e("onRendered", data.targetViewId)
        wegInline.weCampaignData = data
        if (!DataRegistry.instance.isImpressionAlreadyTracked(data.targetViewId, data.campaignId)) {
            sendImpression(data)
        } else {
            Logger.d(TAG, "Impression for ${data.targetViewId} has already tracked")
        }
        parentWidget.sendCallback(METHOD_NAME_ON_RENDERED, Utils.generateMap(wegInline, data))
    }

    private fun sendImpression(data: WECampaignData) {
        Logger.d("sendImpression", "called exception123 ${wegInline.id}")
        if (isVisible()) {
            data.trackImpression()
            DataRegistry.instance.setImpressionTrackedDetails(data.targetViewId, data.campaignId)
            Logger.e("sendImpression isVisible", data.targetViewId)
        } else {
            val v = findViewWithTag<View>("INLINE_PERSONALIZATION_TAG")
            Logger.d("sendImpression", "inside viewTreeObserver ")
            v?.viewTreeObserver?.addOnGlobalLayoutListener(object :
                ViewTreeObserver.OnGlobalLayoutListener {
                override fun onGlobalLayout() {
                    if (v.isVisible()) {
                        Logger.e("sendImpression onGlobalLayout", "${data.targetViewId}")
                        data.trackImpression()
                        DataRegistry.instance.setImpressionTrackedDetails(
                            data.targetViewId,
                            data.campaignId
                        )
                        v.viewTreeObserver.removeOnGlobalLayoutListener(this)
                    }
                }
            })
        }
    }

    override fun screenNavigated(screenName: String) {
        loadView(weInlineView!!)
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