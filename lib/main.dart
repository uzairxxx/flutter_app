import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Contact List By Uzair Ahmed',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Contact List by Uzair'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = 'https://randomuser.me/api/?results=15';
List data;
  void makeRequest() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    
    setState(() {
      var extractData = json.decode(response.body);
      data = extractData["results"];
    });
  }

  @override
   void initState() { 
    super.initState();
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView.builder(
        itemCount: data == null?0 : data.length,
        itemBuilder: (BuildContext context, i){
          return new ListTile(
            title: new Text(data[i]["name"]["first"]),
            subtitle: new Text(data[i]["phone"]),
            leading: new CircleAvatar(
              backgroundImage: 
              new NetworkImage(data[i]["picture"]["thumbnail"]),
            ),
            onTap: (){
              Navigator.push(
                context, 
                new MaterialPageRoute(
                    builder: (BuildContext context) => 
                        new SecondPage(data[i])));
              
            },
          );
        }));
  }

  
}  

class SecondPage extends StatelessWidget {
  final data;
  SecondPage(this.data);

  @override
  Widget build(BuildContext context) => new Scaffold( 
    appBar: new AppBar(
      title: new Text("Contact Image by Uzair")
    ),
    body: new Center(
      child: new Container(
        width: 150.0,
        height: 150.0,
        decoration: new BoxDecoration(
          color: const Color(0xff7c94b6),
          image: new DecorationImage(
          image: new NetworkImage(data["picture"]["large"]),
          fit: BoxFit.cover,
          ),
          borderRadius: new BorderRadius.all(new Radius.circular(75.0)),
          border: new Border.all(
            color: Colors.redAccent,
            width: 4.0,
          ),
        ),
      ),
    )
  );
  }

  
