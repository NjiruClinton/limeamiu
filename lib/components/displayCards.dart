import 'package:flutter/material.dart';

import '../Controllers/controllers.dart';
import '../Controllers/units.dart';

class DisplayCards extends StatelessWidget {
  const DisplayCards({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Controllers.cardPos,
        builder: (context, x, child) {
          return Container(
            //the below gives the height and width responsivenes
            height: Units.pixel6measurements(measurement: 200, height: true),
            width: Units.pixel6measurements(measurement: 390),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xffD8B7FD),
              gradient: const LinearGradient(
                  colors: [Color(0xff2dfff5), Color(0xfffff878)]),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: -35,
                  blurRadius: 1,
                  offset: Offset(0, 55),
                ),
                BoxShadow(
                  color: Color(0xe035da3e),
                  spreadRadius: -20,
                  blurRadius: 0,
                  offset: Offset(0, 30),
                ),


              ],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: Controllers.displayData[x]["title"],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: Units.pixel6measurements(measurement: 25),
                          fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: " \n ${Controllers.displayData[x]["content"]}")
                  ]),
                )),
          );
        });
  }
}