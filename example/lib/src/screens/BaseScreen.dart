import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {

  Widget body;

  BaseScreen({Key? key,required this.body}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.body,
    );
  }
}
