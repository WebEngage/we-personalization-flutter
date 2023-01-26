import 'package:flutter/material.dart';
import 'package:flutter_personalization_sdk_example/src/screens/BaseScreen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(body: Container(
      color: Colors.red,
    ));
  }
}
