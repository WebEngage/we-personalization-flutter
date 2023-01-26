import 'package:flutter/material.dart';
import 'package:flutter_personalization_sdk_example/src/screens/BaseScreen.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(body: Container(
      color: Colors.green,
    ));
  }
}
