import WEPersonalization
class WEProperty{
    var id:Int
    var screenName:String
    var propertyID:Int
    var campaignData : WECampaignData? = nil
    
    public init(id: Int, screenName: String, propertyID: Int) {
        self.id = id
        self.screenName = screenName
        self.propertyID = propertyID
    }
    
    
    
    
}
