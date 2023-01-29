import 'package:flutter/material.dart';
import 'package:flutter_personalization_sdk_example/src/models/customScreen/CustomModel.dart';
import 'package:flutter_personalization_sdk_example/src/utils/ScreenNavigator.dart';
import 'package:flutter_personalization_sdk_example/src/utils/Utils.dart';
import 'package:flutter_personalization_sdk_example/src/widgets/customWidgets/Edittext.dart';

class CustomModelWidget extends StatefulWidget {
  CustomModel? customModel;

  CustomModelWidget({Key? key, this.customModel}) : super(key: key);

  @override
  State<CustomModelWidget> createState() => _CustomModelWidgetState();
}

class _CustomModelWidgetState extends State<CustomModelWidget> {
  @override
  void initState() {
   init();
   super.initState();

  }

  Future<void> init()  async {
    widget.customModel = await Utils.getScreenData();
    print("${widget.customModel?.screenName}");
    setState(() {
      widget.customModel = widget.customModel;
    });

  }


  @override
  Widget build(BuildContext context) {
    return widget.customModel == null ? SizedBox() : Column(
      children: [
        Edittext(
          title: "Enter the List Size",
          defaultValue: getValue(widget.customModel!.listSize),
          textInputType: TextInputType.number,
          onChange: (text) {
            if (text.toString().isNotEmpty) {
              widget.customModel?.listSize = int.parse(text);
            }
          },
        ),
        Edittext(
          title: "Enter Screen Name",
          defaultValue: getValue(widget.customModel!.screenName),
          onChange: (text) {
            if (text.toString().isNotEmpty) {
              widget.customModel?.screenName = text;
            }
          },
        ),
       ElevatedButton(onPressed: _addData, child: Text("Add data")),
        widget.customModel == null ? SizedBox() : Expanded(
          child: ListView.builder(
              itemCount: widget.customModel?.list.length,
              itemBuilder: (context, index) {
                return draw(widget.customModel!.list[index]);
              }),
        ),
        ElevatedButton(onPressed: (){
          Utils.saveScreenData(widget.customModel!);
        }, child: Text("Save for Future")),
        ElevatedButton(onPressed: (){
          ScreenNavigator.gotoCustomListScreen(context, widget.customModel!);
        }, child: Text("Test")),
      ],
    );
  }

  Widget draw(CustomWidgetData customWidgetData) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("position - ${customWidgetData.position}"),
                Text("Android property id - ${customWidgetData.androidPropertyId}"),
                Text("ios property id - ${customWidgetData.iosPropertyID}"),
                Text("View Height - ${customWidgetData.viewHeight}")
              ],
            ),
          ),
          ElevatedButton(onPressed: (){
            showDialogToAddData(customWidgetData);
          }, child: Text("Edit"))
        ],
      ),
    );
  }

  void _addData() {
    var _customWidgetData = CustomWidgetData();
    showDialogToAddData(_customWidgetData);
  }

  void showDialogToAddData(CustomWidgetData _customWidgetData){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: DataEntry(
              customWidgetData: _customWidgetData,
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    if(widget.customModel!.list.contains(_customWidgetData)){
                      setState(() {

                      });
                    }else
                    setState(() {
                      widget.customModel?.list.add(_customWidgetData);
                    });
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.pop(context);
                  },
                  child: Text("save")),
              ElevatedButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.pop(context);
                  },
                  child: Text("cancel"))
            ],
          );
        });
  }
}

class DataEntry extends StatefulWidget {
  CustomWidgetData? customWidgetData;

  DataEntry({Key? key, this.customWidgetData}) : super(key: key);

  @override
  State<DataEntry> createState() => _DataEntryState();
}

class _DataEntryState extends State<DataEntry> {
  @override
  void initState() {
    widget.customWidgetData ?? CustomWidgetData();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Edittext(
          defaultValue: getValue(widget.customWidgetData?.position),
          title: "Position to display",
          textInputType: TextInputType.number,
          onChange: (text) {
            if (text.toString().isNotEmpty) {
              widget.customWidgetData?.position = int.parse(text);
            }
          },
        ),
        Edittext(
          defaultValue: getValue(widget.customWidgetData?.viewHeight),
          title: "View Height",
          textInputType: TextInputType.number,
          onChange: (text) {
            if (text.toString().isNotEmpty) {
              widget.customWidgetData?.viewHeight = int.parse(text);
            }
          },
        ),
        Edittext(
          defaultValue: getValue(widget.customWidgetData?.androidPropertyId),
          title: "Android Property Id",
          onChange: (text) {
            widget.customWidgetData?.androidPropertyId = text;
          },
        ),
        Edittext(
          defaultValue: getValue(widget.customWidgetData?.iosPropertyID),
          title: "IOS Property Id",
          textInputType: TextInputType.number,
          onChange: (text) {
            if (text.toString().isNotEmpty) {
              widget.customWidgetData?.iosPropertyID = int.parse(text);
            }
          },
        )
      ],
    );
  }
}
String getValue(dynamic data){
  if(data is int){
    if(data == -1) {
      return "";
    } else return "$data";
  }else if(data is String){
    return data;
  }
  return "";
}