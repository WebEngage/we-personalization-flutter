import 'package:flutter/material.dart';
import 'package:flutter_personalization_sdk_example/src/models/customScreen/CustomModel.dart';
import 'package:flutter_personalization_sdk_example/src/screens/BaseScreen.dart';
import 'package:flutter_personalization_sdk_example/src/widgets/customWidgets/CustomModelWidget.dart';

class CustomInlineScreen extends StatefulWidget {
  const CustomInlineScreen({Key? key}) : super(key: key);

  @override
  State<CustomInlineScreen> createState() => _CustomInlineScreenState();
}

class _CustomInlineScreenState extends State<CustomInlineScreen> {
  @override
  Widget build(BuildContext context) {
    return  BaseScreen(body: Container(
    child: CustomModelWidget(),
    ));
  }
}


/**
 * list size - int
 * screen name
 * --------------------
 * android property id
 * ios property id
 * int position
 */