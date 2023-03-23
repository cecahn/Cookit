import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

class HomePage extends StatefulWidget {
    const HomePage({Key? key}) : super(key: key);
    
  
    @override
    _HomePageState createState() => _HomePageState();
}


Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}


class _HomePageState extends State<HomePage> {

final _textController = TextEditingController();
String _textInput = '';
final List<String> _list = [];
late Future<Album> futureAlbum = fetchAlbum();


void _addItem(String item) {
  setState(() {
    _list.add(item);
    });
}

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("CookIt",
          style: TextStyle(
            color: Colors.teal,
            fontSize:30,
          )),
            ),
            backgroundColor: Colors.white,
      ),
        body: Padding(
            padding: const EdgeInsets.all(100.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Skriv QR kod för din mat',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                        onPressed: () {
                            _textController.clear();
                        },
                        icon: const Icon(Icons.clear),
                    ),
                    ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _textInput = _textController.text;
                    });
                    _addItem(_textInput);
                  },
                  child: const Text('Save Text Input'),
                ),
              Expanded(
              // child: ListView.builder(
              //   //itemCount: _list.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     return ListTile(
              //       title: Text(_list[index]),
              //     );
              //   }
              // ), 
              child: FutureBuilder<Album>(
                future:futureAlbum,
                builder:  (context, snapshot) {
                  if (snapshot.hasData){
                    return Text(snapshot.data!.title);
                  } else if (snapshot.hasError) {
                return Text('${snapshot.error}');}
                return const CircularProgressIndicator();
                },
              ),
              ),

              
               
                //Text('Saved Text Input: $_textInput'),
            ],
        ),
        )
    );
  }

}