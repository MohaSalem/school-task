import 'package:flutter/material.dart';
import 'package:task/DIoHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'history.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Generator());
  DioHelper.init();
}

class Generator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RandomGenerator(),
    );
  }
}

class RandomGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: //Padding(
      GenerationWidget(),
    );
  }
}

class GenerationWidget extends StatefulWidget {
  @override
  _GenerationWidgetState createState() => _GenerationWidgetState();
}

class _GenerationWidgetState extends State<GenerationWidget> {
  String result = '';
  static List<String> historyList = [];


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(9),
            child: ElevatedButton(
                child: Text("Get New Random Number"),
                onPressed: () {
                  DioHelper.getData(
                    url: "csrng/csrng.php",
                    query: {
                      'min': '0',
                      'max': '1000',
                    },
                  ).then((value) {
                    setState(() {
                      result = (value.data[0]['random']).toString();
                      historyList.add(result + ' retrieved at ' + DateTime.now().toString());
                    });
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Text(
              "$result",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 33),
            ),
          )
        ],
      ),
    );
  }
  setAll(){
    var map = Map.fromIterable(historyList);
    FirebaseFirestore.instance.collection('numbers').doc('RH6848WDISrU4FIkk1gJ').set(map);

  }
}
