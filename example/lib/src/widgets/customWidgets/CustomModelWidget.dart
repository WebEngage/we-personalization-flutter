import 'package:flutter/material.dart';
import 'package:flutter_personalization_sdk_example/src/models/customScreen/CustomModel.dart';
import 'package:flutter_personalization_sdk_example/src/widgets/customWidgets/Edittext.dart';

class CustomModelWidget extends StatefulWidget {
  CustomModel? customModel;

  CustomModelWidget({Key? key, this.customModel, this.save}) : super(key: key);
  Function? save;

  @override
  State<CustomModelWidget> createState() => _CustomModelWidgetState();
}

class _CustomModelWidgetState extends State<CustomModelWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.customModel == null
        ? Container(
            child: Text("NULL"),
          )
        : Container(
            margin: EdgeInsets.all(5),
            child: Column(
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
                Edittext(
                  title: "Enter Screen attribute",
                  defaultValue:
                      "${getValue(widget.customModel!.screenAttribute)}",
                  onChange: (text) {
                    if (text.toString().isNotEmpty) {
                      try {
                        widget.customModel?.screenAttribute = text;
                      } catch (e) {
                        print("ERROR : $e");
                      }
                    }
                  },
                ),
                Edittext(
                  title: "Enter Event Name",
                  defaultValue: getValue(widget.customModel!.event),
                  onChange: (text) {
                    if (text.toString().isNotEmpty) {
                      widget.customModel?.event = text;
                    }
                  },
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ), //SizedBox
                    Expanded(
                      child: Text(
                        'Recycled View',
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ), //Text
                    SizedBox(width: 10),
                    Checkbox(
                      value: widget.customModel!.isRecycledView,
                      onChanged: (value) {
                        widget.customModel?.isRecycledView = value as bool;
                        setState(() {});
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: _addData, child: Text("Add data")),
                    ElevatedButton(
                        onPressed: _addDataAutomatic, child: Text("10")),
                    ElevatedButton(
                        onPressed: _deleteAll, child: Text("Delete")),
                    ElevatedButton(
                        onPressed: () {
                          if (widget.customModel != null)
                            for (CustomWidgetData data
                                in widget.customModel!.list) {
                              data.screenName =
                                  widget.customModel?.screenName ?? "";
                            }

                          widget.save!(widget.customModel);
                          //Utils.saveScreenData(widget.customModel!);
                        },
                        child: Text("Save")),
                  ],
                ),
                widget.customModel == null
                    ? SizedBox()
                    : Expanded(
                        child: ListView.builder(
                            itemCount: widget.customModel?.list.length,
                            itemBuilder: (context, index) {
                              return draw(widget.customModel!.list[index]);
                            }),
                      ),
              ],
            ),
          );
  }

  Widget draw(CustomWidgetData customWidgetData) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("position     ->     ${customWidgetData.position}"),
                Text("is Custom View      -> ${customWidgetData.isCustomView}"),
                Text(
                  "Android property id  ->   ${customWidgetData.androidPropertyId}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "iOS property id    ->   ${customWidgetData.iosPropertyID}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("View Height     ->   ${customWidgetData.viewHeight}"),
                Text("View Width     ->   ${customWidgetData.viewWidth}")
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () {
                showDialogToAddData(customWidgetData);
              },
              child: Text("Edit")),
          ElevatedButton(
              onPressed: () {
                deleteData(customWidgetData);
              },
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ],
      ),
    );
  }

  void _addData() {
    var _customWidgetData = CustomWidgetData();
    showDialogToAddData(_customWidgetData);
  }

  void _deleteAll() {
    widget.customModel?.list.clear();
    setState(() {});
  }

  void _addDataAutomatic() {
    for (var i = 1; i <= 10; i++) {
      CustomWidgetData customWidgetData = CustomWidgetData()
        ..androidPropertyId = "S1P$i"
        ..position = i
        ..iosPropertyID = i
        ..isCustomView = false
        ..viewHeight = 100
        ..viewWidth = 0;
      widget.customModel?.list.add(customWidgetData);
    }
    setState(() {});
  }

  void deleteData(CustomWidgetData _customWidgetData) {
    widget.customModel!.list.remove(_customWidgetData);
    setState(() {});
  }

  void showDialogToAddData(CustomWidgetData _customWidgetData) {
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
                    if (widget.customModel!.list.contains(_customWidgetData)) {
                      setState(() {});
                    } else {
                      setState(() {
                        widget.customModel?.list.add(_customWidgetData);
                      });
                    }
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
    return SingleChildScrollView(
      child: Container(
        child: Column(
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
            Row(
              children: [
                SizedBox(
                  width: 10,
                ), //SizedBox
                Expanded(
                  child: Text(
                    'Is Custom View',
                    style: TextStyle(fontSize: 17.0),
                  ),
                ), //Text
                SizedBox(width: 10),
                Checkbox(
                  value: widget.customWidgetData!.isCustomView,
                  onChanged: (value) {
                    widget.customWidgetData!.isCustomView = value as bool;
                    setState(() {});
                  },
                ),
              ],
            ),
            Edittext(
              defaultValue:
                  getValue(widget.customWidgetData?.viewHeight.toInt()),
              title: "View Height",
              textInputType: TextInputType.number,
              onChange: (text) {
                if (text.toString().isNotEmpty) {
                  widget.customWidgetData?.viewHeight = double.parse(text);
                }
              },
            ),
            Edittext(
              defaultValue:
                  getValue(widget.customWidgetData?.viewWidth.toInt()),
              title: "View Width",
              textInputType: TextInputType.number,
              onChange: (text) {
                if (text.toString().isNotEmpty) {
                  widget.customWidgetData?.viewWidth = double.parse(text);
                }
              },
            ),
            Edittext(
              defaultValue:
                  getValue(widget.customWidgetData?.androidPropertyId),
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
        ),
      ),
    );
  }
}

String getValue(dynamic data) {
  if (data is int) {
    if (data == -1) {
      return "";
    } else {
      return "$data";
    }
  } else if (data is String) {
    return data;
  }
  return "";
}
