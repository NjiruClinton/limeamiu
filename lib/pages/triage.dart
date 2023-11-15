import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;



class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;

  Message({
    required this.text,
    required this.date,
    required this.isSentByMe,
  });
}

class Triage extends StatefulWidget {
  const Triage({super.key});

  @override
  State<Triage> createState() => _TriageState();
}

class _TriageState extends State<Triage> {


  Future<void> getResponse(String prompt) async {
    var response = await http.post(
        Uri.parse('https://0f34-154-78-227-54.ngrok-free.app/chatbot'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt})
    );
    String botResponse = jsonDecode(response.body)['response'];
    print("response: $botResponse");
    setState(() {
      messages.add(
          Message(
              text: botResponse,
              date: DateTime.now(),
              isSentByMe: false
          )
      );
    });
  }

  List<Message> messages = [

    Message(
      text: 'John Doe',
      date: DateTime.now(),
      isSentByMe: true,
    ),
    Message(
      text: 'Jane Doe',
      date: DateTime.now(),
      isSentByMe: false,
    ),
    Message(
      text: 'John Doe',
      date: DateTime.now(),
      isSentByMe: true,
    ),
  ].reversed.toList();

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Triage'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey.shade200,
            height: 2.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: GroupedListView<Message, DateTime>(
            reverse: true,
            padding: EdgeInsets.all(8),
            order: GroupedListOrder.DESC,
            useStickyGroupSeparators: true,
            floatingHeader: true,
            elements: messages,
            groupBy: (message) => DateTime(
              message.date.year,
              message.date.month,
              message.date.day
            ),
            groupHeaderBuilder: (Message message) => SizedBox(
              height: 40,
              child: Center(
                child: Card(
                  color: Colors.grey.shade300,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      DateFormat.yMMMd().format(message.date),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            itemBuilder: (context, Message message) => Align(
              alignment: message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(message.text),
                ),
              ),
            )
          )),
          Container(
            color: Colors.grey.shade300,
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: 'Type your message here...',
              ),
                onSubmitted: (text) async {
                  final message = Message(
                      text: text,
                      date: DateTime.now(),
                      isSentByMe: true
                  );
                  setState(() {
                    messages.add(message);
                  });
                  await getResponse(text);
                }
            ),
          ),
        ],
      )
    );
  }


}
