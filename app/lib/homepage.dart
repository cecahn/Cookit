import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
    const HomePage({Key? key}) : super(key: key);

    @override
    _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

final _textController = TextEditingController();
String _textInput = '';
final List<String> _list = [];

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
              child: ListView.builder(
                itemCount: _list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_list[index]),
                  );
                }
              ),
              ),
                //Text('Saved Text Input: $_textInput'),
            ],
        ),
        )
    );
  }

}