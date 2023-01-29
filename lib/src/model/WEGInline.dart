import '../callbacks/WEPlaceholderCallback.dart';
import '../utils/Utils.dart';

class WEGInline{
  int id = -1;
  String screenName;
  String propertyID;
  Function? callback;
  WEPlaceholderCallback? wePlaceholderCallback;

  WEGInline({
    required this.screenName,
    required this.propertyID,this.callback}){
    id  = Utils().getCurrentNewIndex();
  }

  dynamic toJSON(){
    return {
      "id":id,
      "screenName":screenName,
      "propertyID":propertyID
    };
  }

}