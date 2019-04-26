import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

void main() {
  runApp(new MaterialApp(
    home: new MyGetHttpData(),
  ));
}

class MyGetHttpData extends StatefulWidget {
  @override
  MyGetHttpDataState createState() => new MyGetHttpDataState();
}

class MyGetHttpDataState extends State<MyGetHttpData> {
  List data;
  bool _progressBarActive = true;

  Future<String> getData() async {
    var response = await http.get(Uri.encodeFull("https://swapi.co/api/people"),
        headers: {"Accept": "application/json"});

    //meka thinne ara class eken data ganna
    //class walin ganna widiya cheak kare
    //me kramen okkoma enawa
    //pahala thina clases balanna
    //okkoma clear

    final jsonResponse = json.decode(response.body);
    Student student = new Student.fromJson(jsonResponse);

    print(student.count);
    print(student.previous);
    print(student.next);

    for (var i = 0; i < student.results.length; i++) {
      print(student.results[i].name);
      print(student.results[i].height);
      for (var j = 0; j < student.results[i].films.length; j++) {
        print(student.results[i].films[j]);
      }
      try {
        print(student.results[i].films.isEmpty
            ? "Null"
            : student.results[i].films[0]);
      } catch (e) {
        print(e);
      }

      print(" ");
      print(student.results[i].url);
      print(" ");
    }

    //me thinne kelimma results eka map karapu eka..eken thamay app eka run wenne

    setState(() {
      if (response.statusCode == 200) {
        _progressBarActive = false;
        var dataConvertedToJSON = json.decode(response.body);
        data = dataConvertedToJSON['results'];
        // print(data);
      }
    });

    return "Successfull";
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Retrieve JSON Data via HTTP GET Method"),
      ),
      // Create a Listview and load the data when available
      body: _progressBarActive == true
          ? const CircularProgressIndicator()
          : new ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return new Container(
                  child: new Center(
                      child: new Column(
                    // Stretch the cards in horizontal axis
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      new Card(
                        child: Column(
                          children: <Widget>[
                            new Container(
                              child: new Text(
                                // Read the name field value and set it in the Text widget
                                data[index]['name'],
                                // set some style to text
                                style: new TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.lightBlueAccent),
                              ),
                              // added padding
                              padding: const EdgeInsets.all(15.0),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: new Container(
                                    child: new Text(
                                      data[index]['gender'],
                                      style: new TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.lightBlueAccent),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: new Container(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: new Text(
                                        data[index]['mass'],
                                        style: new TextStyle(
                                            fontSize: 10.0,
                                            color: Colors.lightBlueAccent),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: new Container(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: new Text(
                                        data[index]['films'][0],
                                        style: new TextStyle(
                                            fontSize: 10.0,
                                            color: Colors.lightBlueAccent),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: new Container(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: new Text(
                                        data[index]['species'][0] != null
                                            ? data[index]['species'][0]
                                            : "Null",
                                        style: new TextStyle(
                                            fontSize: 10.0,
                                            color: Colors.lightBlueAccent),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: new Container(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: new Text(
                                        data[4]['vehicles'][0] == null
                                            ? "aaa"
                                            : "bbb",
                                        style: new TextStyle(
                                            fontSize: 10.0,
                                            color: Colors.lightBlueAccent),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
                );
              }),
    );
  }
}

class Student {
  String previous;
  String next;
  int count;
  List<Result> results;

  Student({this.count, this.next, this.previous, this.results});

  factory Student.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['results'] as List;
    // print(list.runtimeType);
    List<Result> reslist = list.map((i) => Result.fromJson(i)).toList();

    return Student(
      previous: parsedJson['previous'],
      next: parsedJson['next'],
      count: parsedJson['count'],
      results: reslist,
    );
  }
}

class Result {
  String name;
  String height;
  List<String> films;
  String url;

  Result({this.films, this.name, this.height, this.url});

  factory Result.fromJson(Map<String, dynamic> parsedJson) {
    var filmsfromjson = parsedJson['vehicles'];
    List<String> filmlist = new List<String>.from(filmsfromjson);
    return Result(
      name: parsedJson['name'],
      height: parsedJson['height'],
      films: filmlist,
      url: parsedJson['url'],
    );
  }
}
