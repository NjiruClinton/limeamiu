import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class PatientRecords extends StatefulWidget {
  PatientRecords({super.key, required this.patient});
  final Map<String, dynamic> patient;
  @override
  State<PatientRecords> createState() => _PatientRecordsState();
}

class SymptomRecord {
  String symptom;
  String response;

  SymptomRecord({required this.symptom, required this.response});
}


class _PatientRecordsState extends State<PatientRecords> {

  List<SymptomRecord> symptoms = [];

  @override
  void initState() {
    super.initState();
    getRecords();
  }

  getRecords() async {
    QuerySnapshot records = await FirebaseFirestore.instance
        .collection('records')
        .where('patient_id', isEqualTo: widget.patient['id'])
        .get();

    records.docs.forEach((doc) {
      symptoms.add(SymptomRecord(
          symptom: doc['symptom'],
          response: doc['response']
      ));
    });

    setState(() {});
  }




  @override
  Widget build(BuildContext context) {
    print(widget.patient['id']);
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Records'),
      ),
      body: Column(
      //   button that shows dialog with Form content
        children: [
          // view symptoms and responses
          Expanded(
            child: ListView.builder(
                itemCount: symptoms.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text(symptoms[index].symptom),
                    subtitle: Text(symptoms[index].response),
                  );
                }
            ),
          ),


          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SymptomsForm(patient: widget.patient,)),
              );
            },
            child: Text('Add Symptoms'),
          ),
        ],
      ),
    );
  }
}

class SymptomFormState {
  int currentStep = 0;

  // Methods to handle state changes
  void nextStep() {
    if(currentStep < 2) {
      currentStep++;
    }
  }
}

class SymptomsForm extends StatefulWidget {
  const SymptomsForm({super.key, required this.patient});
  final Map<String, dynamic> patient;

  @override
  State<SymptomsForm> createState() => _SymptomsFormState();
}

class _SymptomsFormState extends State<SymptomsForm> {
  final symptom1 = TextEditingController();
  final symptom2 = TextEditingController();
  final symptom3 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final apiUrl = 'http://clintonnjiru.pythonanywhere.com/chat';

  // handleSymptoms to take each syptom to the chatbot and get a response, then add to firestore collection records, each document with patient id, symptom, and response
  Future<void> handleSymptoms() async {
    // for each symptom, send request to chatbot and get response, and add to firestore collection records
    var response = await sendRequest(symptom1.text);
    await addToFirestore(symptom1.text, response);
    response = await sendRequest(symptom2.text);
    await addToFirestore(symptom2.text, response);
    response = await sendRequest(symptom3.text);
    await addToFirestore(symptom3.text, response);
  }

  Future<String> sendRequest(String symptom) async {
    var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'sentence': symptom})
    );

    return jsonDecode(response.body)['response'];
  }
  Future<void> addToFirestore(String symptom, String response) async {
    await FirebaseFirestore.instance.collection('records').add({
      'patient_id': widget.patient['id'],
      'symptom': symptom,
      'response': response,
      'date': DateTime.now(),
    });
  }

  List<Step> getSteps() => [
    Step(
      title: Text('Enter symptom 1'),
      content: TextFormField(
        decoration: InputDecoration(labelText: 'Enter symptom 1'),
        validator: (value) => value!.isEmpty ? 'Required' : null,
        controller: symptom1,
      ),
      isActive: currentStep >=0,
    ),
    Step(
        title: Text('Enter symptom 2'),
        content: TextFormField(
          decoration: InputDecoration(labelText: 'Enter symptom 2'),
          validator: (value) => value!.isEmpty ? 'Required' : null,
          controller: symptom2,
        ),
        isActive: currentStep >=1
    ),
    Step(
        title: Text('Enter symptom 3'),
        content: TextFormField(
          decoration: InputDecoration(labelText: 'Enter symptom 3'),
          validator: (value) => value!.isEmpty ? 'Required' : null,
          controller: symptom3,
        ),
        isActive: currentStep >=2
    ),
  ];

  int currentStep = 0;


  @override
  Widget build(BuildContext context) {
    print(widget.patient['name']);
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptoms'),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          steps: getSteps(),
          currentStep: currentStep,
          onStepContinue: () async{
            final isLastStep = currentStep == getSteps().length - 1;
            if(isLastStep) {
              await handleSymptoms();
              print('Completed');
              Navigator.push(context , MaterialPageRoute(builder: (context) => PatientRecords(patient: widget.patient,)));
            }
            // also validate
            // if(_formKey.currentState!.validate()) {
            //   setState(() {
            //     if(currentStep < 2) {
            //       currentStep++;
            //     }
            //   });
            // }
            //dont validate
            else {
              setState(() {
                if(currentStep < 2) {
                  currentStep++;
                }
              });
            }
          },
          onStepCancel: () {
            setState(() {
              if(currentStep > 0) {
                currentStep--;
              }
            });
          },
        ),
      ),
    );
  }
}
