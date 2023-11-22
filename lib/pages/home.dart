import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lime/pages/patient_records.dart';
import 'package:lime/pages/sign_in.dart';
import 'package:lime/pages/triage.dart';

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
            title: Text('Add a patient'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Name'),
                  controller: patientName,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Gender'),
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
                  child: Text('Cancel')
              ),
              ElevatedButton(
                  onPressed: () async {
                    // add data to firestore collection patients
                    await FirebaseFirestore.instance.collection('patients').add({
                      'name': patientName.text,
                      'gender': patientGender.text,
                      'dob': selectedDate,
                      'id': DateTime.now().millisecondsSinceEpoch,
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Add')
              ),
            ],
          );
        }
    );
  }

  // get patients into a list widget


  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if(user != null){
      loggedIn = true;
    } else {
      loggedIn = false;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text('Home'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey.shade200,
            height: 2.0,
          ),
        ),

      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          openDialog();
        },
        label: Text('Add a patient'),
        icon: Icon(Icons.add),
        backgroundColor: Color(0xffD8B7FD),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? Text(
                      user!.email!.substring(0,1),
                      style: TextStyle(color: Colors.white),
                    )
                        : null,
                  ),
                  SizedBox(height: 10,),
                  Text(user!.displayName!, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(height: 5,),
                  Text(user!.email!, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),),
                ],
              ),
            ),
            ListTile(
              title: Text('Home'),
              // onTap: () {
              //   Navigator.pop(context);
              // },
            ),
            ListTile(
              title: Text('Profile'),
              // onTap: () {
              //   Navigator.pop(context);
              // },
            ),
            ListTile(
              title: Text('Triage'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()), //Triage
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text('Sign Out'),
              onTap: () {
                auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search a patient...',
                  // Add a clear button to the search bar
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      // Clear the search field
                      _searchController.clear();
                      setState(() {
                      });
                    },
                  ),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      // Perform the search here
                    },
                  ),
                  // bottom line only when user is typing
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade800.withOpacity(0.5)),
                  ),
                ),
                onChanged: (value) {
                  // setState(() {
                  // });
                }
            ),
          ),
          SizedBox(height: 20,),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),

              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0xffD8B7FD),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "Data Collection \nEffortlessly collect data about diseases and climate in rural and remote areas using our user-friendly interface.", style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0xffD8B7FD),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "Offline Mode \nContinue collecting data even without an internet connection. The app will automatically sync your data once you're back online.", style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0xffD8B7FD),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "Real-time Reporting \nGet instant access to real-time reports and analytics, allowing you to make informed decisions based on the latest data.", style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0xffD8B7FD),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "Customizable Forms \nCreate custom forms tailored to your specific data collection needs. Add fields, dropdowns, and more to capture the information you require.", style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // SizedBox(height: 10),
        SizedBox(
          height: 300,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('patients')
                .where('name', isGreaterThanOrEqualTo: _searchController.text)
                .where('name', isLessThan: _searchController.text + 'z')
                .orderBy('name')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              var patients = snapshot.data!.docs;

              return ListView.separated(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  var patient = patients[index].data() as Map<String, dynamic>;

                  return ListTile(
                    title: Text(
                      patient['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Gender: ${patient['gender']} \nDOB: ${DateFormat('dd-MMM-yyyy').format(patient['dob'].toDate())}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        // show menu
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 200,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.view_agenda_rounded),
                                    title: Text('View Patient'),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder:
                                      (context) => PatientRecords(patient: patient,)));
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.chat_rounded),
                                    title: Text('Triage Assessment'),
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder:
                                          (context) => Triage(patient: patient,)));
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.all(16),
                  );
                }, separatorBuilder: (BuildContext context, int index) { return Divider(); },
              );
            },
          ),
        ),
          SizedBox(height: 50,)
        ],
      )
    );
  }
}
