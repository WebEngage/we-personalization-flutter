import 'package:flutter/material.dart';
import 'package:flutter_personalization_sdk_example/src/screens/BaseScreen.dart';
import 'package:flutter_personalization_sdk_example/src/widgets/SimpleWidget.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "List Screen",
        body: Container(
      child: ListView.builder(
          itemCount: 20,
          itemBuilder: (c, i) {
            return SimpleWidget(
              index: i,
              widgetType: i % 2 == 0 ? WidgetType.image : WidgetType.text,
            );
          }),
    ));
  }
}
