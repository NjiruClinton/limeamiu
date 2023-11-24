import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  Triage({super.key, required this.patient});
  final Map<String, dynamic> patient;
  @override
  State<Triage> createState() => _TriageState();
}

class _TriageState extends State<Triage> {



  Future<void> getResponse(String prompt) async {
    var response = await http.post(
        Uri.parse('http://clintonnjiru.pythonanywhere.com/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'sentence': prompt})
    );
    String botResponse = jsonDecode(response.body)['response'];
    print("response: $botResponse");
    // add to firestore collection triage with patient id
    await FirebaseFirestore.instance.collection('triage').add({
      'patient_id': widget.patient['id'],
      'text': botResponse,
      'date': DateTime.now(),
      'isSentByMe': false
    });
    getMessages();
  }

  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  void getMessages() async {

    final snapshots = await FirebaseFirestore.instance
        .collection('triage')
        .where('patient_id', isEqualTo: widget.patient['id'])
        .get();

    messages = snapshots.docs.map((doc) {
      return Message(
          text: doc['text'],
          date: doc['date'].toDate(),
          isSentByMe: doc['isSentByMe']
      );
    }).toList().reversed.toList();

    // messages.reversed;
    // sort messages by datetime
    messages.sort((a, b) => a.date.compareTo(b.date));
    setState(() {});

  }

  TextEditingController controller = TextEditingController();

  void onSendPressed(String text) async{
    final message = Message(
        text: text,
        date: DateTime.now(),
        isSentByMe: true
    );
    setState(() {
      // messages.add(message);
    });
    //   also add to firestore collection triage with patient id
    await FirebaseFirestore.instance.collection('triage').add({
      'patient_id': widget.patient['id'],
      'text': text,
      'date': DateTime.now(),
      'isSentByMe': true
    });
    await getResponse(text);
  }


  @override
  Widget build(BuildContext context) {
  print(widget.patient['name']);
  print(widget.patient['id']);
    return Scaffold(
      appBar: AppBar(
        title: Text('Triage assessment for ${widget.patient['name']}'),
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
              controller: controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: 'Type symptoms here...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    onSendPressed(controller.text);
                    controller.clear();
                  }
                )
              ),
                onSubmitted: (text) async {
                  onSendPressed(text);
                  controller.clear();
                }
            ),
          ),
        ],
      )
    );
  }


}
