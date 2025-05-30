import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: Center(
            child: Text(
              "设置",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontSize: 24,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Divider(
              height: 1,
              color: const Color.fromARGB(255, 44, 44, 44),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text("应用名称"),
                  subtitle: Text("SMusicPlayer"),
                ),
                Divider(
                  height: 1,
                  color: const Color.fromARGB(255, 44, 44, 44),
                ),
                ListTile(
                  leading: Icon(Icons.code),
                  title: Text("版本号"),
                  subtitle: Text("v1.0.0"),
                ),
                Divider(
                  height: 1,
                  color: const Color.fromARGB(255, 44, 44, 44),
                ),
                ListTile(
                  leading: Icon(Icons.people_alt_outlined),
                  title: Text("开发者"),
                  subtitle: Text("YourName"),
                ),
                Divider(
                  height: 1,
                  color: const Color.fromARGB(255, 44, 44, 44),
                ),
                ListTile(
                  leading: Icon(Icons.copyright_outlined),
                  title: Text("版权信息"),
                  subtitle: Text("2024 All rights reserved"),
                ),
              ],
            ),
          ],
        ));
  }
}
