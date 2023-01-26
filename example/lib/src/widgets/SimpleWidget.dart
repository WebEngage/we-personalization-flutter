import 'package:flutter/material.dart';
import 'package:flutter_personalization_sdk_example/src/utils/AppColor.dart';

class SimpleWidget extends StatefulWidget {
  const SimpleWidget({Key? key}) : super(key: key);

  @override
  State<SimpleWidget> createState() => _SimpleWidgetState();
}

class _SimpleWidgetState extends State<SimpleWidget> {
  @override

  void initState() {
    print("Init called");
    WidgetsBinding.instance.addPostFrameCallback((_) => onScreenReturn());
    super.initState();


  }

  void onScreenReturn() {
    print("On screen return");
  }



  @override
  void dispose() {

    print("Dispose called");
    super.dispose();
  }

  Widget build(BuildContext context) {
    return  Container(
      height: 100,
      width: 100,
      color: themeColor,
    );
  }
}
