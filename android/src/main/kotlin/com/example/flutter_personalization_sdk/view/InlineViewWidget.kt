package com.example.flutter_personalization_sdk.view

import android.content.Context
import android.util.DisplayMetrics
import android.util.Log
import android.util.TypedValue
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
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
        print("initView ${payload}");
        Log.e("initView", "InitView called for $payload")
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
        weInlineView!!.tag = tag

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
        Log.e("Webengage: ", "loadview 123")
        weInlineView.load(tag, this)
    }

    override fun onDataReceived(data: WECampaignData) {
        Log.e("onDataReceived: ", "${data.targetViewId} ${wegInline.id}")
        wegInline.weCampaignData = data
        parentWidget.sendCallback(METHOD_NAME_ON_DATA_RECEIVED, Utils.generateMap(wegInline, data))
    }

    override fun onPlaceholderException(
        campaignId: String?,
        targetViewId: String,
        error: Exception
    ) {
        Log.e("onPlaceholderException", error.message!!)
        parentWidget.sendCallback(
            METHOD_NAME_ON_PLACEHOLDER_EXCEPTION,
            Utils.generateMap(wegInline, campaignId, targetViewId, error)
        )
    }

    override fun onRendered(data: WECampaignData) {
        Log.e("onRendered", data.targetViewId)
        wegInline.weCampaignData = data
        if (!DataRegistry.instance.isImpressionAlreadyTracked(data.targetViewId, data.campaignId)) {
            sendImpression(data)
        } else {
            Log.d(TAG, "Impression for ${data.targetViewId} has already tracked")
        }

        val view = weInlineView!!.findViewById<FrameLayout>(R.id.we_parent_card_view)
        val map = getShadowDetails(data)
        val observer: ViewTreeObserver? = view?.viewTreeObserver
        observer?.let {
            val listener = object : ViewTreeObserver.OnGlobalLayoutListener {
                override fun onGlobalLayout() {
                    Log.e(TAG, "onGlobalLayout: _platformCallHandler $map")
                    val width = pxToDp(weInlineView!!.context, view.width)
                    val height = pxToDp(weInlineView!!.context, view.height)
                    map["w"] = width
                    map["h"] = height
                    parentWidget.sendCallback(
                        METHOD_NAME_ON_RENDERED,
                        Utils.generateMap(wegInline, data, map)
                    )

                    observer.removeOnGlobalLayoutListener(this)
                }
            }
            it.addOnGlobalLayoutListener(listener)
        }


    }


    private fun getShadowDetails(data: WECampaignData): HashMap<String, Any> {
        val map = hashMapOf<String, Any>()
        val children = data.content?.children
        if (children != null && children.size > 0) {
            for (data in children) {
                if (data.layoutType == "View") {
                    val shadow = data.properties?.get("shdw")
                    shadow?.let { it ->
                        if (it.toString().isNotEmpty()) {
                            val _shadow =
                                it.toString().replace("dp", "").toInt()
                            val roundedCorner = data.properties.get("cr")
                            var _roundedCorners = 0
                            roundedCorner?.let { it ->
                                if (it.toString().isNotEmpty()) {
                                    _roundedCorners =
                                        it.toString().replace("dp", "").toInt()
                                }
                            }
                            if (_shadow > 0) {
                                map["elevation"] = _shadow
                                map["corners"] = _roundedCorners
                                map["ml"] = removeDpText("${data.properties["ml"]}")
                                map["mr"] = removeDpText("${data.properties["mr"]}")
                                map["mt"] = removeDpText("${data.properties["mt"]}")
                                map["mb"] = removeDpText("${data.properties["mb"]}")
                            }
                        }
                    }
                }
            }
        }
        val view = weInlineView!!.findViewById<FrameLayout>(R.id.we_parent_card_view)
        val layoutParams: ViewGroup.MarginLayoutParams =
            view.layoutParams as ViewGroup.MarginLayoutParams
        layoutParams.setMargins(
            layoutParams.marginStart,
            layoutParams.topMargin,
            layoutParams.marginEnd,
            layoutParams.bottomMargin
        )
        return map
    }

    private fun sendShadowToHybrid(data: WECampaignData) {
        try {
            val view = weInlineView!!.findViewById<FrameLayout>(R.id.we_parent_card_view)

            val observer: ViewTreeObserver? = view?.viewTreeObserver
            observer?.let {
                val listener = object : ViewTreeObserver.OnGlobalLayoutListener {
                    override fun onGlobalLayout() {
                        Log.e(
                            TAG,
                            "onGlobalLayout: _platformCallHandler ${view.width} ${view.height}"
                        )
                        var width = pxToDp(weInlineView!!.context, view.width)
                        var height = pxToDp(weInlineView!!.context, view.height)
                        if (width > 0 && height > 0) {
                            var childern = data.content?.children
                            if (childern != null && childern!!.size > 0) {
                                for (data in childern!!) {
                                    if (data.layoutType == "View") {

                                        val shadow = data.properties?.get("shdw")
                                        shadow?.let { it ->
                                            if (it.toString().isNotEmpty()) {
                                                var _shadow =
                                                    it.toString().replace("dp", "").toInt()
                                                val roundedCorner = data?.properties?.get("cr")
                                                var _roundedCorners = 0
                                                roundedCorner?.let { it ->
                                                    if (it.toString().isNotEmpty()) {
                                                        _roundedCorners =
                                                            it.toString().replace("dp", "").toInt()
                                                    }
                                                }
                                                if (_shadow > 0) {
                                                    val map = hashMapOf<String, Any>()
                                                    map["width"] = width
                                                    map["height"] = height
                                                    map["elevation"] = _shadow
                                                    map["corners"] = _roundedCorners
                                                    map["margins"] =
                                                        removeDpText("${data.properties!!.get("ml")}")

                                                    Log.e(
                                                        TAG,
                                                        "onGlobalLayout: _platformCallHandler ${
                                                            data.properties!!.get("ml")
                                                        } $map"
                                                    )
//                                                    parentWidget.sendCallback(
//                                                        METHOD_NAME_SEND_SHADOW_DETAILS,
//                                                        map
//                                                    )

                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        observer.removeOnGlobalLayoutListener(this)
                    }
                }
                it.addOnGlobalLayoutListener(listener)
            }
        } catch (e: java.lang.Exception) {
            Log.e("sendShadowToHybrid", "Exception : ${e.message}")
        }

    }

    fun removeDpText(text: String, convertPxToDp: Boolean = false): Int {
        return if (convertPxToDp)
            pxToDp(weInlineView!!.context, text.replace("dp", "").toInt())
        else text.replace("dp", "").toInt()
    }

    fun dpToPx(context: Context, dp: Float): Int {
        val density = context.resources.displayMetrics.density
        return Math.round(dp * density)
    }

    fun pxToDp(context: Context, px: Int): Int {
        val displayMetrics: DisplayMetrics = context.resources.displayMetrics
        return Math.round(px / (displayMetrics.xdpi / DisplayMetrics.DENSITY_DEFAULT)).toInt()
    }


    private fun sendImpression(data: WECampaignData) {
        if (isVisible()) {
            data.trackImpression()
            DataRegistry.instance.setImpressionTrackedDetails(data.targetViewId, data.campaignId)
            Log.e("sendImpressionisVisible", data.targetViewId)
        } else {
            val v = findViewWithTag<View>("INLINE_PERSONALIZATION_TAG")
            Log.d("sendImpression", "inside viewTreeObserver ")
            v?.viewTreeObserver?.addOnGlobalLayoutListener(object :
                ViewTreeObserver.OnGlobalLayoutListener {
                override fun onGlobalLayout() {
                    if (v.isVisible()) {
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
        parentWidget.sendCallback(METHOD_NAME_RESET_SHADOW_DETAILS, null)
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