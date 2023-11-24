import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../sign_in.dart';
import 'home.dart';

class MyDrawer extends StatelessWidget {
  // final user;
  // final auth;
  MyDrawer({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
    );
  }
}
