import 'package:flutter/material.dart';
import 'package:flutter_personalization_sdk_example/src/models/customScreen/CustomModel.dart';
import 'package:flutter_personalization_sdk_example/src/screens/BaseScreen.dart';
import 'package:flutter_personalization_sdk_example/src/utils/ScreenNavigator.dart';
import 'package:flutter_personalization_sdk_example/src/utils/Utils.dart';
import 'package:flutter_personalization_sdk_example/src/widgets/customWidgets/CustomModelWidget.dart';

class CustomInlineScreen extends StatefulWidget {
  bool isDialog = false;

  CustomInlineScreen({Key? key, this.isDialog = false}) : super(key: key);

  @override
  State<CustomInlineScreen> createState() => _CustomInlineScreenState();
}

enum ScreenType { list, detail }

class _CustomInlineScreenState extends State<CustomInlineScreen> {
  ScreenType screenType = ScreenType.list;

  List<CustomModel> list = Utils.getScreenDataList();
  CustomModel selectedCustomModel = Utils.getScreenDataList()[0];

  @override
  Widget build(BuildContext context) {
    return widget.isDialog
        ? _body()
        : BaseScreen(body: _body());
  }

  Widget _body() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          widget.isDialog
              ? SizedBox()
              : Container(
                  height: 50,
                  color: Colors.orange,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      screenType == ScreenType.detail ? IconButton(
                          onPressed: () {
                            if (screenType == ScreenType.detail) {
                              setState(() {
                                screenType = ScreenType.list;
                              });
                            }
                          },
                          icon: Icon(Icons.arrow_back)) : SizedBox(),
                      screenType == ScreenType.list
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  list.add(CustomModel());
                                });
                              },
                              child: Text("Add Screen"))
                          : SizedBox()
                    ],
                  ),
                ),
          Expanded(
            child: screenType == ScreenType.list
                ? ListView.builder(
                shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          if (widget.isDialog) return;
                          setState(() {
                            selectedCustomModel = list[i];
                            screenType = ScreenType.detail;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child:
                                      Text("Screen Name : ${list[i].screenName}"),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    if(widget.isDialog){
                                      Navigator.of(context).pop();
                                    }
                                    ScreenNavigator.gotoCustomListScreen(
                                        context, list[i]);
                                  },
                                  child: Text("OPEN"))
                            ],
                          ),
                        ),
                      );
                    })
                : CustomModelWidget(
                    save: _save,
                    customModel: selectedCustomModel,
                  ),
          )
        ],
      ),
    );
  }

  void _save(CustomModel customModel) {
    if (!list.contains(customModel)) {
      list.add(customModel);
    }
    Utils.saveScreenDataList(list);
  }
}
