import 'package:flutter/material.dart';

class LatestPostPage extends StatefulWidget {
  const LatestPostPage({Key? key}) : super(key: key);

  @override
  State<LatestPostPage> createState() => _LatestPostPageState();
}

class _LatestPostPageState extends State<LatestPostPage> {
  String selectedValue = "USA";

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(key: Key("key-usa"), child: Text("USA"), value: "USA"),
      DropdownMenuItem(key: Key("key-canada"),child: Text("Canada"), value: "Canada"),
      DropdownMenuItem(key: Key("key-brazil"),child: Text("Brazil"), value: "Brazil"),
      DropdownMenuItem(key: Key("key-english"),child: Text("England"), value: "England"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest Posts'),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Text("All latest posts will display here"),
            ),
            SizedBox(height: 40),
            DropdownButton(
              key: Key("key-dropdown-button"),
              value: selectedValue,
              items: dropdownItems,
              isExpanded: true,
              onChanged: (String? value) {
                selectedValue = value!;
              },
            ),
          ],
        ),
      ),
    );
  }
}
