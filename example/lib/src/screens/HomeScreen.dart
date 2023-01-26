import 'package:flutter/material.dart';
import 'package:flutter_personalization_sdk_example/src/utils/AppColor.dart';
import 'package:flutter_personalization_sdk_example/src/utils/ScreenNavigator.dart';
import 'package:flutter_personalization_sdk_example/src/widgets/SimpleWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text('Home Screen'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            sectionView("List Screen", () {
              ScreenNavigator.gotoListScreen(context);
            }),
            sectionView("Detail Screen", () {
              ScreenNavigator.gotoDetailScreen(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget sectionView(label, callback) => GestureDetector(
        onTap: callback,
        child: Container(
          decoration: BoxDecoration(
              color: index++ % 2 == 0 ? primaryColor : secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(10),
          child: Center(
              child: Text(
            "$label",
            style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )),
        ),
      );
}
