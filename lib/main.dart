import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:web_socket_channel/io.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(
    channel: IOWebSocketChannel.connect('ws://echo.websocket.org'),
  ));
}

class MyApp extends StatefulWidget {
  final WebSocketChannel channel;

  MyApp({@required this.channel});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("websocket"),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Form(
                child: TextFormField(
                  decoration: InputDecoration(labelText: "send any message"),
                  controller: editingController,
                ),
              ),
              StreamBuilder(
                stream: widget.channel.stream,
                builder: (context, snapshot) {
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                        snapshot.hasData ? '${snapshot.data}' : 'no data here'),
                  );
                },
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.send,
          ),
          onPressed: _sendMyMessage,
        ),
      ),
    );
  }

  void _sendMyMessage() {
    if (editingController.text.isNotEmpty) {
      widget.channel.sink.add(editingController.text);
    }
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}
