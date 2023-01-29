import 'package:flutter/material.dart';
import 'package:flutter_personalization_sdk_example/src/models/customScreen/CustomModel.dart';
import 'package:flutter_personalization_sdk_example/src/screens/BaseScreen.dart';
import 'package:flutter_personalization_sdk_example/src/widgets/SimpleWidget.dart';

class CustomListScreen extends StatefulWidget {

  CustomModel customModel;

  CustomListScreen({Key? key, required this.customModel}) : super(key: key);

  @override
  State<CustomListScreen> createState() => _CustomListScreenState();
}

class _CustomListScreenState extends State<CustomListScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        title: "Custom List Screen",
        body: Container(
          child: ListView.builder(
              itemCount: widget.customModel.listSize + widget.customModel.list.length,
              itemBuilder: (c, i) {
                int pos = checkIfContains(i);
                if(pos != -1){
                  var data = widget.customModel.list[pos];
                  return Container(
                    child: Text("${data.androidPropertyId}"),
                  );
                } else {
                  return SimpleWidget(
                    index: i,
                    widgetType: i % 2 == 0 ? WidgetType.image : WidgetType.text,
                  );
                }
              }),
        ));
  }

  int checkIfContains(index){
    var list = widget.customModel.list;
    int count = 0;
    for(var data in list){
      if(data.position == index){
        return count;
      }
      count++;
    }
    return -1;
  }

}
