package com.webengage.we_personalization_flutter.view

import android.content.Context
import android.util.DisplayMetrics
import android.util.Log
import android.util.TypedValue
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.ViewTreeObserver
import android.widget.FrameLayout
import com.webengage.we_personalization_flutter.R
import com.webengage.we_personalization_flutter.extension.isVisible
import com.webengage.we_personalization_flutter.handler.WEPluginCallbackHandler
import com.webengage.we_personalization_flutter.handler.ScreenNavigatorCallback
import com.webengage.we_personalization_flutter.model.WEProperty
import com.webengage.we_personalization_flutter.registry.WEPropertyRegistry
import com.webengage.we_personalization_flutter.utils.*
import com.webengage.personalization.WEInlineView
import com.webengage.personalization.WEPersonalization
import com.webengage.personalization.callbacks.WECampaignControlInternalCallback
import com.webengage.personalization.callbacks.WEPlaceholderCallback
import com.webengage.personalization.data.WECampaignData

class WEInlineViewWidget(
    context: Context,
    private val payload: HashMap<String, Any>?,
    private val parentWidget: WEInlineWidget

) : FrameLayout(context), WEPlaceholderCallback, ScreenNavigatorCallback, WECampaignControlInternalCallback{

    private val weProperty: WEProperty
    var weInlineView: WEInlineView? = null
    var tag = ""

    init {
        setLayerType(LAYER_TYPE_NONE, null);
        weProperty = generateWEInline()
        initView(payload)
    }

    fun getWEGInlineView(): WEProperty {
        return weProperty
    }



    private fun initView(payload: HashMap<String, Any>?) {
        tag = payload?.get(PAYLOAD_ANDROID_PROPERTY_ID) as String
        val viewWidth = payload[PAYLOAD_VIEW_WIDTH] as Double
        val viewHeight = payload[PAYLOAD_VIEW_HEIGHT] as Double
        WEPluginCallbackHandler.instance.setScreenNavigatorCallback(
            payload[PAYLOAD_SCREEN_NAME] as String, this
        )
        val view = LayoutInflater.from(context).inflate(
            R.layout.layout_inlineviewwidget, this, false
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

    private fun generateWEInline(): WEProperty {
        return WEProperty(
            id = payload!![PAYLOAD_ID] as Int,
            screenName = payload[PAYLOAD_SCREEN_NAME] as String,
            propertyID = payload[PAYLOAD_ANDROID_PROPERTY_ID] as String
        )
    }

    private fun loadView(weInlineView: WEInlineView) {
        WEPersonalization.get().registerCampaignControlGroupCallback(tag,this)
        weInlineView.load(tag, this)
        monitorVisibilityAndFireEvent()
    }

    override fun onControlGroupTriggered(propertyID : String){
        monitorVisibilityAndFireEvent()
    }

    override fun onDataReceived(data: WECampaignData) {
        weProperty.weCampaignData = data
        parentWidget.sendCallback(
            METHOD_NAME_ON_DATA_RECEIVED, WEUtils.generateMap(weProperty, data)
        )
    }

    override fun onPlaceholderException(
        campaignId: String?, targetViewId: String, error: Exception
    ) {
        parentWidget.sendCallback(
            METHOD_NAME_ON_PLACEHOLDER_EXCEPTION,
            WEUtils.generateMap(weProperty, campaignId, targetViewId, error)
        )
    }

    override fun onRendered(data: WECampaignData) {
        weProperty.weCampaignData = data
        if (!WEPropertyRegistry.instance.isImpressionAlreadyTracked(
                data.targetViewId, data.campaignId
            )
        ) {
            sendImpression(data)
        } else {
            // for cg
            monitorVisibilityAndFireEvent()
        }
        try {
            val view =
                weInlineView!!.findViewById<FrameLayout>(com.webengage.personalization.R.id.we_parent_card_view)

            val map = getShadowDetails(data)
            view?.let {
                val layoutParams: ViewGroup.MarginLayoutParams =
                    view.layoutParams as ViewGroup.MarginLayoutParams
                layoutParams.setMargins(
                    layoutParams.marginStart,
                    layoutParams.topMargin,
                    layoutParams.marginEnd,
                    layoutParams.bottomMargin
                )
            }
            val width = pxToDp(weInlineView!!.context, view.width)
            val height = pxToDp(weInlineView!!.context, view.height)
            map["w"] = width
            map["h"] = height

            parentWidget.sendCallback(
                METHOD_NAME_ON_RENDERED, WEUtils.generateMap(weProperty, data, map)
            )
        }catch (e:Exception){

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
                            val shadow = it.toString().replace("dp", "").toInt()
                            val roundedCorner = data.properties.get("cr")
                            var roundedCorners = 0
                            roundedCorner?.let { it ->
                                if (it.toString().isNotEmpty()) {
                                    roundedCorners = it.toString().replace("dp", "").toInt()
                                }
                            }
                            if (shadow > 0) {
                                map["elevation"] = shadow
                                map["corners"] = roundedCorners
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
        return map
    }

    fun removeDpText(text: String, convertPxToDp: Boolean = false): Int {
        if (text.isEmpty()) return 0
        return if (convertPxToDp) pxToDp(weInlineView!!.context, text.replace("dp", "").toInt())
        else text.replace("dp", "").toInt()
    }

    fun pxToDp(context: Context, px: Int): Int {
        val displayMetrics: DisplayMetrics = context.resources.displayMetrics
        return Math.round(px / (displayMetrics.xdpi / DisplayMetrics.DENSITY_DEFAULT)).toInt()
    }

    var isCGViewListenerAlreadyAttach = false;
    private var globalLayoutListenerForViewImpression: ViewTreeObserver.OnGlobalLayoutListener? = null
    private fun monitorVisibilityAndFireEvent(data: WECampaignData? = null) {
      //onrendered
        data?.let {
            if (isVisible()) {
                it.trackImpression()
                WEPropertyRegistry.instance.setImpressionTrackedDetails(
                    it.targetViewId, it.campaignId
                )
                fireCGevent();
            }else{
                val v = this
                // Remove any existing listener
                globalLayoutListenerForViewImpression?.let { listener ->
                    v.viewTreeObserver?.removeOnGlobalLayoutListener(listener)
                }
                globalLayoutListenerForViewImpression = object : ViewTreeObserver.OnGlobalLayoutListener {
                    override fun onGlobalLayout() {
                        if (v.isVisible()) {
                            data.trackImpression()
                            WEPropertyRegistry.instance.setImpressionTrackedDetails(
                                data.targetViewId, data.campaignId
                            )
                            fireCGevent()
                            v?.viewTreeObserver?.let {
                                it.removeOnGlobalLayoutListener(this)
                            }
                            globalLayoutListenerForViewImpression = null // Clear reference
                        }
                    }
                }

                v.viewTreeObserver?.addOnGlobalLayoutListener(globalLayoutListenerForViewImpression)
            }
        }
        // For CG
        if(data == null) {

            if (isVisible()) {
                fireCGevent()
            } else {
                if(isCGViewListenerAlreadyAttach)
                    return;
                val v = this
                isCGViewListenerAlreadyAttach = true;
                v?.viewTreeObserver?.addOnGlobalLayoutListener(object :
                    ViewTreeObserver.OnGlobalLayoutListener {
                    override fun onGlobalLayout() {
                        if (v.isVisible()) {
                            fireCGevent()
                            v?.viewTreeObserver?.let {
                                it.removeOnGlobalLayoutListener(this)
                            }
                            isCGViewListenerAlreadyAttach = false;
                        }
                    }
                })
            }
        }
    }

    private fun fireCGevent() {
        WELogger.v("WEInlineViewWidget", "Fire CG event ====> $tag")
        WEPersonalization.get().trackCGEvents(tag)
    }




    private fun sendImpression(data: WECampaignData) {
       monitorVisibilityAndFireEvent(data)
    }

    override fun screenNavigated(screenName: String) {
        parentWidget.sendCallback(METHOD_NAME_RESET_SHADOW_DETAILS, null)
        loadView(weInlineView!!)
    }

    override fun onDetachedFromWindow() {
        WELogger.v("WEInlineViewWidget", "onDetachedFromWindow called for TAG = $tag")
        WEPersonalization.get().unregisterCampaignControlGroupCallback(tag)
        payload?.let {
            WEPluginCallbackHandler.instance.removeScreenNavigatorCallback(
                it[PAYLOAD_SCREEN_NAME] as String, this
            )
        }
        super.onDetachedFromWindow()
    }


}