import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> messages = [];

  TextEditingController _textEditingController = TextEditingController();

  Future<String> getResponse(String message) async {
  var url =
      Uri.parse('https://api.openai.com/v1/engines/davinci-codex/completions');
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer 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',
  };
  var body = '{"prompt": "$message", "max_tokens": 50}';
  var response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to get response from API');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with ChatGPT'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(messages[index]),
                );
              },
            ),
          ),
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: 'Type your message...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  String message = _textEditingController.text;
                  setState(() {
                    messages.add(message);
                  });
                  _textEditingController.clear();

                  String response = await getResponse(message);
                  setState(() {
                    messages.add(response);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
