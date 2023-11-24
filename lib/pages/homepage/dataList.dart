import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lime/pages/triage.dart';

import '../patient_records.dart';


class DataList extends StatelessWidget {
  final patient;
  const DataList({super.key, this.patient});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        patient['name'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Gender: ${patient['gender']} \nDOB: ${DateFormat('dd-MMM-yyyy').format(patient['dob'].toDate())}',
        style:
        const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          // show menu
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return SizedBox(
                height: 200,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                          Icons.view_agenda_rounded),
                      title: const Text('View Patient'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PatientRecords(
                                      patient: patient,
                                    )));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat_rounded),
                      title: const Text('Triage Assessment'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Triage(
                                  patient: patient,
                                )));
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
      contentPadding: const EdgeInsets.all(16),
    );
  }
}
