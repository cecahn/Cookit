import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
    const HomePage({Key? key}) : super(key: key);

    @override
    _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

final _textController = TextEditingController();

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
                )
            ],
        ),
        )
    );
  }

}