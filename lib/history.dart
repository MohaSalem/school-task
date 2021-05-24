import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task/DIoHelper.dart';

class HistoryPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HistoryPage> {
  static List<String> ourList = ['All numbers:'];

  @override
  void initState() {
    super.initState();
    getAll();
  }

  @override
  void dispose() {
    super.dispose();
    getAll();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: ListView.builder(
        itemCount: ourList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(ourList[index]),
          );
        },
      ),
    );
  }

  getAll() async {
    ourList = FirebaseFirestore.instance.collection('numbers').doc('RH6848WDISrU4FIkk1gJ').get() as List<String>;

  }
}
