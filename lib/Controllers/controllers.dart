import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Controllers{
  static ValueNotifier<int> cardPos = ValueNotifier(0);

  static final User? user = FirebaseAuth.instance.currentUser;
  static List displayData = [
    {
      "title": "Data Collection",
      "content":
      "Effortlessly collect data about diseases and climate in rural and remote areas using our user-friendly interface."
    },
    {
      "title": "Offline Mode",
      "content":
      "Continue collecting data even without an internet connection. The app will automatically sync your data once you're back online."
    },
    {
      "title": "Real-time Reporting",
      "content":
      "Get instant access to real-time reports and analytics, allowing you to make informed decisions based on the latest data."
    },
    {
      "title": "Customizable Forms ",
      "content":
      "Create custom forms tailored to your specific data collection needs. Add fields, dropdowns, and more to capture the information you require."
    },
  ];

}
