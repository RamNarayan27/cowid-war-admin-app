// todo : finish editform
// todo : get the values from there and update it in the listview
// todo : finish editform
// todo : get the values and create a new list entry
// todo : add a search functionality based on hospital and all

// todo : set up firebase

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'editform.dart';
import 'newentry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class HospitalData {
  String? hospitalName;
  String? hospitalAddress;
  int? icu;
  int? ventilator;
  int? normalBeds;
  int? oxygenBeds;
  String? docId;
  int? totalBeds;

  HospitalData(
      this.hospitalName,
      this.hospitalAddress,
      this.icu,
      this.ventilator,
      this.normalBeds,
      this.oxygenBeds,
      this.docId,
      this.totalBeds);

  HospitalData.fromJSON(jsonData) {
    this.hospitalName = jsonData['Hospital Name'];
    this.hospitalAddress = jsonData['Hospital Address'];
    this.icu = jsonData['icu'];
    this.ventilator = jsonData['ventilator'];
    this.normalBeds = jsonData['normal-beds'];
    this.oxygenBeds = jsonData['oxy-beds'];
    this.docId = jsonData.id;
    this.totalBeds = jsonData['total-beds'];
  }

  Map<String, dynamic> toJson() {
    return {
      "Hospital Name": this.hospitalName,
      "Hospital Address": this.hospitalAddress,
      "ventilator": this.ventilator,
      "icu": this.icu,
      "normal-beds": this.normalBeds,
      "oxy-beds": this.oxygenBeds,
      "total-beds": this.totalBeds
    };
  }
}

class MyApp extends StatelessWidget {
  static const String _title = 'Covid War Room';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidget();
}

class _MyStatefulWidget extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  // final entries = <String>['Apollo', 'Billroth', 'Jaruko'];
  final entries2 = <String>['dlsfjasdf', 'adfasfasfda', 'asdlfhas;dfasf'];
  final List<int> colorCodes2 = <int>[600, 500, 100];

  Widget _buildList() {
    if (_selectedIndex == 0) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('test')
            .doc('beds')
            .collection('data')
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: snapshot.data.size,
              itemBuilder: (BuildContext context, int index) {
                return ExpansionTile(
                  leading: Icon(
                    Icons.local_hospital_rounded,
                    color: Colors.red,
                    size: 56.0,
                  ),
                  title: Text(snapshot.data.docs[index]['Hospital Name']),
                  subtitle: Text(
                      '# Total Beds : ${snapshot.data.docs[index]['total-beds']}'),
                  trailing: Icon(Icons.arrow_drop_down_rounded),
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Hospital Name'),
                          Text('${snapshot.data.docs[index]['Hospital Name']}')
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('# Total Beds'),
                          Text('${snapshot.data.docs[index]['total-beds']}')
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('# ICU'),
                          Text('${snapshot.data.docs[index]['icu']}')
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('# Ventilator'),
                          Text('${snapshot.data.docs[index]['ventilator']}')
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('# O2 Beds'),
                          Text('${snapshot.data.docs[index]['oxy-beds']}')
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('# Normal Beds'),
                          Text('${snapshot.data.docs[index]['normal-beds']}')
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            child: Text('Edit'),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditFormPage(),
                                      settings: RouteSettings(
                                        arguments: HospitalData.fromJSON(
                                            snapshot.data.docs[index]),
                                      )));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              });
        },
      );
    } else {
      return ListView.builder(
          // ! finish this part also
          padding: const EdgeInsets.all(0),
          itemCount: entries2.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              color: Colors.amber[colorCodes2[index]],
              child: Center(child: Text('Entry ${entries2[index]}')),
            );
          });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _getANewItem(_selectedIndex) {
    setState(() {
      if (_selectedIndex == 0) {
        // todo : add a new route here to add a new value
      } else {
        entries2.add('Fire');
        colorCodes2.add(400);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Covid War Room'),
      ),
      body: Center(
        child: _buildList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ! firebase will update it here
          Fluttertoast.showToast(
              msg: 'Test toast for fab',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.black,
              fontSize: 16.0);
          _getANewItem(_selectedIndex);
          Navigator.push(
              context, MaterialPageRoute(builder: (content) => NewEntry()));
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.king_bed_rounded),
            label: 'Bed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Leads',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
