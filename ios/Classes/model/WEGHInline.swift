import WEPersonalization
class WEGHInline{
    var id:Int
    var screenName:String
    var propertyID:Int
    var campaignData : WEGCampaignData? = nil
    
    public init(id: Int, screenName: String, propertyID: Int) {
        self.id = id
        self.screenName = screenName
        self.propertyID = propertyID
    }
    
    
    
    
}
