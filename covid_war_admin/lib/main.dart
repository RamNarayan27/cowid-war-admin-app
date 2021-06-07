// todo : add a search functionality based on hospital

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'editform.dart';
import 'newentry.dart';
import 'newleads.dart';
import 'editleads.dart';
import 'dart:developer' as developer;

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

class LeadsData {
  String? leadName;
  String? leadCity;
  String? status;
  String? type;
  String? docID;
  int? phoneNumber;

  LeadsData(this.leadName, this.leadCity, this.status, this.type, this.docID,
      this.phoneNumber);

  LeadsData.fromJSON(jsonData) {
    this.leadName = jsonData['name'];
    this.leadCity = jsonData['city'];
    this.status = jsonData['status'];
    this.type = jsonData['type'];
    this.docID = jsonData.id;
    this.phoneNumber = jsonData['phone-number'];
  }
  Map<String, dynamic> toJson() {
    return {
      "name": this.leadCity,
      "city": this.leadCity,
      "status": this.status,
      "phone-number": this.phoneNumber,
      "type": this.type
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
  List<int> selectedItemsBeds = [];
  List<int> selectedItemsLeads = [];
  bool leadsSwitcher = false;
  bool bedsSwitcher = false;
  PreferredSizeWidget appbar = AppBar(title: Text('Covid War Room'));
  // PreferredSizeWidget appbarLeads = AppBar(title: Text('Covid War Room'));

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
                return InkWell(
                  onLongPress: () {
                    // add the widget to the list here
                    setState(() {
                      selectedItemsBeds.add(index);
                      bedsSwitcher = true;
                      if (bedsSwitcher) {
                        appbar = AppBar(
                          title: Text('Delete Hospitals'),
                          actions: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                //delete firebase entry here
                                selectedItemsBeds.forEach((element) async {
                                  await FirebaseFirestore.instance
                                      .runTransaction(
                                          (Transaction myTransaction) async {
                                    await myTransaction.delete(
                                        snapshot.data.docs[element].reference);
                                  });
                                  // final snackBar =
                                  //     SnackBar(content: Text('${element}'));
                                  // ScaffoldMessenger.of(context)
                                  //     .showSnackBar(snackBar);
                                  developer.log(element.toString(),
                                      name: 'deleted entry');
                                });
                                setState(() {
                                  bedsSwitcher = false;
                                  selectedItemsBeds.clear();
                                  appbar =
                                      AppBar(title: Text('Covid War Room'));
                                });
                              },
                            )
                          ],
                        );
                      }
                    });
                    // final snackBar =
                    //     SnackBar(content: Text('Yay! A SnackBar!'));
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    developer.log(selectedItemsBeds.toString(),
                        name: 'onlongpress works');
                  },
                  child: (bedsSwitcher)
                      ? (selectedItemsBeds.contains(index))
                          ? ListTileTheme(
                              // represents the list that is present in the list
                              // ontap should remove the goddamn thing from the list
                              tileColor: Colors.black12,
                              child: ListTile(
                                leading: Icon(
                                  Icons.local_hospital_rounded,
                                  color: Colors.red,
                                  size: 56.0,
                                ),
                                title: Text(
                                    snapshot.data.docs[index]['Hospital Name']),
                                subtitle: Text(
                                    '# Total Beds : ${snapshot.data.docs[index]['total-beds']}'),
                                onTap: () {
                                  setState(() {
                                    selectedItemsBeds.remove(index);
                                    // final snackBar = SnackBar(
                                    //     content: Text('Yay! A SnackBar!'));
                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(snackBar);
                                    developer.log(selectedItemsBeds.toString(),
                                        name: 'ontap remove works');
                                    if (selectedItemsBeds.isEmpty) {
                                      bedsSwitcher = false;
                                      appbar =
                                          AppBar(title: Text('Covid War Room'));
                                    }
                                  });
                                },
                              ),
                            )
                          : ListTileTheme(
                              // represents the list that is not present
                              // ontap should add the index into the list
                              child: ListTile(
                                leading: Icon(
                                  Icons.local_hospital_rounded,
                                  color: Colors.red,
                                  size: 56.0,
                                ),
                                title: Text(
                                    snapshot.data.docs[index]['Hospital Name']),
                                subtitle: Text(
                                    '# Total Beds : ${snapshot.data.docs[index]['total-beds']}'),
                                onTap: () {
                                  setState(() {
                                    selectedItemsBeds.add(index);
                                    // final snackBar = SnackBar(
                                    //     content: Text('Yay! A SnackBar!'));
                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(snackBar);
                                    developer.log(selectedItemsBeds.toString(),
                                        name: 'ontap add works');
                                  });
                                },
                              ),
                            )
                      : ExpansionTile(
                          leading: Icon(
                            Icons.local_hospital_rounded,
                            color: Colors.red,
                            size: 56.0,
                          ),
                          title:
                              Text(snapshot.data.docs[index]['Hospital Name']),
                          subtitle: Text(
                              '# Total Beds : ${snapshot.data.docs[index]['total-beds']}'),
                          trailing: Icon(Icons.arrow_drop_down_rounded),
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Hospital Name'),
                                  Text(
                                      '${snapshot.data.docs[index]['Hospital Name']}')
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('# Total Beds'),
                                  Text(
                                      '${snapshot.data.docs[index]['total-beds']}')
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('# ICU'),
                                  Text('${snapshot.data.docs[index]['icu']}')
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('# Ventilator'),
                                  Text(
                                      '${snapshot.data.docs[index]['ventilator']}')
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('# O2 Beds'),
                                  Text(
                                      '${snapshot.data.docs[index]['oxy-beds']}')
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('# Normal Beds'),
                                  Text(
                                      '${snapshot.data.docs[index]['normal-beds']}')
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    child: Text('Edit'),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditFormPage(),
                                              settings: RouteSettings(
                                                arguments:
                                                    HospitalData.fromJSON(
                                                        snapshot
                                                            .data.docs[index]),
                                              )));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                );
              });
        },
      );
    } else {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('test')
            .doc('leads')
            .collection('data')
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: snapshot.data.size,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onLongPress: () {
                      // add the widget to the list here
                      setState(() {
                        selectedItemsLeads.add(index);
                        leadsSwitcher = true;
                        if (leadsSwitcher) {
                          appbar = AppBar(
                            title: Text('Delete Leads'),
                            actions: [
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // ! todo : delete from firebase here
                                  //delete firebase entry here
                                  // selectedItemsBeds.forEach((element) async {
                                  //   await FirebaseFirestore.instance
                                  //       .runTransaction(
                                  //           (Transaction myTransaction) async {
                                  //     await myTransaction.delete(
                                  //         snapshot.data.docs[element].reference);
                                  //   });
                                  selectedItemsLeads.forEach((element) async {
                                    await FirebaseFirestore.instance
                                        .runTransaction(
                                            (Transaction myTransaction) async {
                                      await myTransaction.delete(snapshot
                                          .data.docs[element].reference);
                                    });
                                    // final snackBar =
                                    //     SnackBar(content: Text('${element}'));
                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(snackBar);
                                    developer.log(element.toString(),
                                        name: 'deleted entry');
                                  });
                                  final snackBar = SnackBar(
                                      content: Text('Yay! A SnackBar!'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  setState(() {
                                    leadsSwitcher = false;
                                    selectedItemsLeads.clear();
                                    appbar =
                                        AppBar(title: Text('Covid War Room'));
                                  });
                                },
                              )
                            ],
                          );
                        }
                      });
                      // final snackBar =
                      //     SnackBar(content: Text('Yay! A SnackBar!'));
                      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      developer.log(selectedItemsLeads.toString(),
                          name: 'onlongpress works');
                    },
                    child: (leadsSwitcher)
                        ? (selectedItemsLeads.contains(index))
                            ? ListTileTheme(
                                tileColor: Colors.black12,
                                child: ListTile(
                                  leading: Icon(Icons.people),
                                  title:
                                      Text(snapshot.data.docs[index]['name']),
                                  subtitle: Text(
                                      'City ${snapshot.data.docs[index]['city']}'),
                                  onTap: () {
                                    setState(() {
                                      selectedItemsLeads.remove(index);
                                      // final snackBar = SnackBar(
                                      //     content: Text('Yay! A SnackBar!'));
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(snackBar);
                                      developer.log(
                                          selectedItemsLeads.toString(),
                                          name: 'ontap remove works');
                                      if (selectedItemsLeads.isEmpty) {
                                        leadsSwitcher = false;
                                        appbar = AppBar(
                                            title: Text('Covid War Room'));
                                      }
                                    });
                                  },
                                ),
                              )
                            : ListTileTheme(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.people,
                                    // color: Colors.red,
                                    // size: 56.0,
                                  ),
                                  title:
                                      Text(snapshot.data.docs[index]['name']),
                                  subtitle: Text(
                                      'City : ${snapshot.data.docs[index]['city']}'),
                                  onTap: () {
                                    setState(() {
                                      selectedItemsLeads.add(index);
                                      // final snackBar = SnackBar(
                                      //     content: Text('Yay! A SnackBar!'));
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(snackBar);
                                      developer.log(
                                          selectedItemsLeads.toString(),
                                          name: 'ontap add works');
                                    });
                                  },
                                ),
                              )
                        : ExpansionTile(
                            leading: (snapshot.data.docs[index]['status'] ==
                                    'verified')
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 50.0,
                                  )
                                : (snapshot.data.docs[index]['status'] ==
                                        'unverified')
                                    ? Icon(
                                        Icons.help_outlined,
                                        color: Colors.amber,
                                        size: 50.0,
                                      )
                                    : Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                        size: 50.0,
                                      ),
                            title: Text(snapshot.data.docs[index]['name']),
                            subtitle: Text(
                                'City : ${snapshot.data.docs[index]['city']}'),
                            trailing: Icon(Icons.arrow_drop_down_rounded),
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Lead Name'),
                                    Text('${snapshot.data.docs[index]['name']}')
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('City'),
                                    Text('${snapshot.data.docs[index]['city']}')
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Phone Number'),
                                    Text(
                                        '${snapshot.data.docs[index]['phone-number']}')
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Status'),
                                    Text(
                                        '${snapshot.data.docs[index]['status']}')
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Type'),
                                    Text('${snapshot.data.docs[index]['type']}')
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      child: Text('Edit'),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditLeadsPage(),
                                                settings: RouteSettings(
                                                  arguments: LeadsData.fromJSON(
                                                      snapshot
                                                          .data.docs[index]),
                                                )));
                                      },
                                    )
                                  ],
                                ),
                              )
                            ],
                          ));
              });
        },
      );
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
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => NewEntry()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NewLeadsEntry()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: Center(
        child: _buildList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getANewItem(_selectedIndex);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.king_bed_rounded),
            label: 'Beds',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Leads',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800], //todo : change it to the
        onTap: _onItemTapped,
      ),
    );
  }
}
