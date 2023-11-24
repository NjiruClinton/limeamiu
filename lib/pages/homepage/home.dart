import 'dart:async';
import 'dart:math';
import 'package:lime/Controllers/controllers.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lime/Controllers/units.dart';
import 'package:lime/pages/homepage/dataList.dart';
import 'package:lime/pages/homepage/searchbar.dart';
import 'package:lime/pages/patient_records.dart';
import 'package:lime/pages/sign_in.dart';
import 'package:lime/pages/triage.dart';

import '../../components/displayCards.dart';
import 'drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}



class _HomeState extends State<Home> {
  bool loggedIn = false;

  final FirebaseAuth auth = FirebaseAuth.instance;

  // final User? user = FirebaseAuth.instance.currentUser;
  // // if no user is signed in, navigate to sign in page
  //
  // @override
  // void initState() {
  //   super.initState();
  //   if(user == null){
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => SignIn()),
  //     );
  //   }
  // }

  final _searchController = TextEditingController();

  Future openDialog() async {
    // define date
    var selectedDate = DateTime.now();
    final patientName = TextEditingController();
    final patientGender = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add a patient'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  controller: patientName,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Gender'),
                  controller: patientGender,
                ),
                // TextField(
                //   decoration: InputDecoration(labelText: 'Date of Birth'),
                // ),
                // show date picker
                TextButton(
                  style: TextButton.styleFrom(
                    elevation: 8,
                    backgroundColor: Colors.grey.shade200,
                  ),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                        print(selectedDate);
                      });
                    }
                  },
                  child: Text(
                    'Date of Birth ${DateFormat('dd-MMM-yyyy').format(selectedDate)}',
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                ),
                // other fields
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed: () async {
                    // add data to firestore collection patients
                    await FirebaseFirestore.instance
                        .collection('patients')
                        .add({
                      'name': patientName.text,
                      'gender': patientGender.text,
                      'dob': selectedDate,
                      'id': DateTime.now().millisecondsSinceEpoch,
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add')),
            ],
          );
        });
  }


  // get patients into a list widget
  @override
  void initState() {

    if (Controllers.user != null) {
      loggedIn = true;
    } else {
      loggedIn = false;
    }
    Timer.periodic(const Duration(seconds: 5), (timer) {
      Random r = Random();
      Controllers.cardPos.value = r.nextInt(4);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            openDialog();
          },
          label: const Text('Add a patient'),
          icon: const Icon(Icons.add),
          backgroundColor: const Color(0xffD8B7FD),
        ),
        drawer: MyDrawer(),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('patients')
                .where('name', isGreaterThanOrEqualTo: _searchController.text)
                .where('name', isLessThan: _searchController.text + 'z')
                .orderBy('name')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              var patients = snapshot.data!.docs;

              return SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      leading: Builder(
                        builder: (context) {
                          return GestureDetector(
                            onTap: ()=> Scaffold.of(context).openDrawer(),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Image.asset("assets/images/hamburger.png", height: 10, width: 18,),
                            ),
                          );
                        }
                      ) ,
                      title: const Text('Home'),
                      bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(60),
                          child:
                              MySearchBar(searchController: _searchController)),
                      expandedHeight: 350,
                      flexibleSpace: const FlexibleSpaceBar(
                        background: Column(
                            children: [SizedBox(height: 60),DisplayCards()]),
                      ),
                    ),
                    SliverAnimatedList(
                      initialItemCount: patients.length,
                      itemBuilder: (context, index, anim) {
                        Map<String, dynamic> patient =
                            patients[index].data() as Map<String, dynamic>;
                        return DataList(patient: patient,);
                      },
                    ),
                  ],
                ),
              );
            }));
  }
}




