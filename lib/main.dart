
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Generate(),
    );
  }
}

class Generate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GenerateState();
}

class GenerateState extends State<Generate> {
  Future<List<Model>> _list;

  @override
  void initState() {
    _list = _get();
    super.initState();
  }

  Future<List<Model>> _get() async {
    final response = await http.get(
      "https://csrng.net/csrng/csrng.php?min=1&max=100",
    );
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body) as List;
      return jsonBody.map((data) => new Model.fromJson(data)).toList();
    } else
      throw Exception("Unable to get data");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Model>>(
      future: _list,
      builder: (context, snapshot) {
        print(snapshot);
        if (snapshot.hasData)
          return _buildBody(snapshot.data);
        else if (snapshot.hasError)
          return _buildErrorPage(snapshot.error);
        else
          return _buildLoadingPage();
      },
    );
  }

  Widget _buildBody(List<Model> list) => Scaffold(

    appBar: AppBar(
      title: Text('Employee Title = ${list[0].random}'),
    ),
    body: ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(list[index].status),
        );
      },
    ),
  );

  Widget _buildErrorPage(error) => Material(
    child: Center(
      child: Text("ERROR: $error"),
    ),
  );

  Widget _buildLoadingPage() => Material(
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

class Model {
  int min;
  int max;
  String status;
  int random;

  Model({this.min, this.max, this.status, this.random});

  Model.fromJson(Map<String, dynamic> json) {
    min = json['min'];
    max = json['max'];
    status = json['status'];
    random = json['random'];
  }
}