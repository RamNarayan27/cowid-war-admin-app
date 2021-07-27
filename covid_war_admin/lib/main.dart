import 'package:bubble/bubble.dart';
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
      "name": this.leadName,
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
  final keyUnverified = GlobalKey();
  Offset? positionUnverified;
  List<int> selectedItemsBeds = [];
  List<int> selectedItemsLeads = [];
  bool leadsSwitcher = false;
  bool bedsSwitcher = false;
  late OverlayEntry entry;

  int toggle = 0;
  PreferredSizeWidget appbarLeads = AppBar(title: Text('Covid War Room'));
  PreferredSizeWidget appbarBeds = AppBar(title: Text('Covid War Room'));

  Widget _buildList() {
    if (_selectedIndex == 0) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('test')
            .doc('beds')
            .collection('data')
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot1) {
          developer.log('inside beds builder', name: 'beds');
          if (!snapshot1.hasData) return const Text('Loading...');
          return ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: snapshot1.data.size,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onLongPress: () {
                    setState(() {
                      selectedItemsBeds.add(index);
                      bedsSwitcher = true;
                      if (bedsSwitcher) {
                        appbarBeds = AppBar(
                          title: Text('Delete Hospitals'),
                          actions: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                selectedItemsBeds.forEach((element) async {
                                  await FirebaseFirestore.instance
                                      .runTransaction(
                                          (Transaction myTransaction) async {
                                    await myTransaction.delete(
                                        snapshot1.data.docs[element].reference);
                                  });
                                  developer.log(element.toString(),
                                      name: 'deleted entry');
                                });
                                setState(() {
                                  bedsSwitcher = false;
                                  selectedItemsBeds.clear();
                                  appbarBeds =
                                      AppBar(title: Text('Covid War Room'));
                                });
                              },
                            )
                          ],
                        );
                      }
                    });
                    developer.log(selectedItemsBeds.toString(),
                        name: 'onlongpress works');
                  },
                  child: (bedsSwitcher)
                      ? (selectedItemsBeds.contains(index))
                          ? ListTileTheme(
                              tileColor: Colors.black12,
                              child: ListTile(
                                leading: Icon(
                                  Icons.local_hospital_rounded,
                                  color: Colors.red,
                                  size: 56.0,
                                ),
                                title: Text(snapshot1.data.docs[index]
                                    ['Hospital Name']),
                                subtitle: Text(
                                    '# Total Beds : ${snapshot1.data.docs[index]['total-beds']}'),
                                onTap: () {
                                  setState(() {
                                    selectedItemsBeds.remove(index);
                                    developer.log(selectedItemsBeds.toString(),
                                        name: 'ontap remove works');
                                    if (selectedItemsBeds.isEmpty) {
                                      bedsSwitcher = false;
                                      appbarBeds =
                                          AppBar(title: Text('Covid War Room'));
                                    }
                                  });
                                },
                              ),
                            )
                          : ListTileTheme(
                              child: ListTile(
                                leading: Icon(
                                  Icons.local_hospital_rounded,
                                  color: Colors.red,
                                  size: 56.0,
                                ),
                                title: Text(snapshot1.data.docs[index]
                                    ['Hospital Name']),
                                subtitle: Text(
                                    '# Total Beds : ${snapshot1.data.docs[index]['total-beds']}'),
                                onTap: () {
                                  setState(() {
                                    selectedItemsBeds.add(index);
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
                              Text(snapshot1.data.docs[index]['Hospital Name']),
                          subtitle: Text(
                              '# Total Beds : ${snapshot1.data.docs[index]['total-beds']}'),
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
                                      '${snapshot1.data.docs[index]['Hospital Name']}')
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
                                      '${snapshot1.data.docs[index]['total-beds']}')
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
                                  Text('${snapshot1.data.docs[index]['icu']}')
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
                                      '${snapshot1.data.docs[index]['ventilator']}')
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
                                      '${snapshot1.data.docs[index]['oxy-beds']}')
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
                                      '${snapshot1.data.docs[index]['normal-beds']}')
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
                                                        snapshot1
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
        builder: (context, AsyncSnapshot snapshot2) {
          if (!snapshot2.hasData) return const Text('Loading...');
          return ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: snapshot2.data.size,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onLongPress: () {
                      setState(() {
                        selectedItemsLeads.add(index);
                        leadsSwitcher = true;
                        if (leadsSwitcher) {
                          appbarLeads = AppBar(
                            title: Text('Delete Leads'),
                            actions: [
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  selectedItemsLeads.forEach((element) async {
                                    await FirebaseFirestore.instance
                                        .runTransaction(
                                            (Transaction myTransaction) async {
                                      await myTransaction.delete(snapshot2
                                          .data.docs[element].reference);
                                    });
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
                                    appbarLeads =
                                        AppBar(title: Text('Covid War Room'));
                                  });
                                },
                              )
                            ],
                          );
                        }
                      });
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
                                      Text(snapshot2.data.docs[index]['name']),
                                  subtitle: Text(
                                      'City ${snapshot2.data.docs[index]['city']}'),
                                  onTap: () {
                                    setState(() {
                                      selectedItemsLeads.remove(index);
                                      developer.log(
                                          selectedItemsLeads.toString(),
                                          name: 'ontap remove works');
                                      if (selectedItemsLeads.isEmpty) {
                                        leadsSwitcher = false;
                                        appbarLeads = AppBar(
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
                                  ),
                                  title:
                                      Text(snapshot2.data.docs[index]['name']),
                                  subtitle: Text(
                                      'City : ${snapshot2.data.docs[index]['city']}'),
                                  onTap: () {
                                    setState(() {
                                      selectedItemsLeads.add(index);
                                      developer.log(
                                          selectedItemsLeads.toString(),
                                          name: 'ontap add works');
                                    });
                                  },
                                ),
                              )
                        : ExpansionTile(
                            leading: (snapshot2.data.docs[index]['status'] ==
                                    'verified')
                                ? IconButton(
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 50.0,
                                    ),
                                    onPressed: () => showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                                title:
                                                    const Text('Change Status'),
                                                content: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.check_circle,
                                                        color: Colors.green,
                                                        size: 50,
                                                      ),
                                                      onPressed: () async {
                                                        // * verified button
                                                        LeadsData data = LeadsData(
                                                            snapshot2.data
                                                                    .docs[index]
                                                                ['name'],
                                                            snapshot2.data
                                                                    .docs[index]
                                                                ['city'],
                                                            'verified',
                                                            snapshot2.data
                                                                    .docs[index]
                                                                ['type'],
                                                            snapshot2.data
                                                                .docs[index].id,
                                                            snapshot2.data
                                                                    .docs[index]
                                                                [
                                                                'phone-number']);
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('test')
                                                            .doc('leads')
                                                            .collection('data')
                                                            .doc(data.docID)
                                                            .set(data.toJson());
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.help_outlined,
                                                        color: Colors.amber,
                                                        size: 50.0,
                                                      ),
                                                      onPressed: () async {
                                                        // * unverified button
                                                        LeadsData data = LeadsData(
                                                            snapshot2.data
                                                                    .docs[index]
                                                                ['name'],
                                                            snapshot2.data
                                                                    .docs[index]
                                                                ['city'],
                                                            'unverified',
                                                            snapshot2.data
                                                                    .docs[index]
                                                                ['type'],
                                                            snapshot2.data
                                                                .docs[index].id,
                                                            snapshot2.data
                                                                    .docs[index]
                                                                [
                                                                'phone-number']);
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('test')
                                                            .doc('leads')
                                                            .collection('data')
                                                            .doc(data.docID)
                                                            .set(data.toJson());
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.cancel,
                                                        color: Colors.red,
                                                        size: 50.0,
                                                      ),
                                                      onPressed: () async {
                                                        // * dead button
                                                        LeadsData data = LeadsData(
                                                            snapshot2.data
                                                                    .docs[index]
                                                                ['name'],
                                                            snapshot2.data
                                                                    .docs[index]
                                                                ['city'],
                                                            'dead',
                                                            snapshot2.data
                                                                    .docs[index]
                                                                ['type'],
                                                            snapshot2.data
                                                                .docs[index].id,
                                                            snapshot2.data
                                                                    .docs[index]
                                                                [
                                                                'phone-number']);
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('test')
                                                            .doc('leads')
                                                            .collection('data')
                                                            .doc(data.docID)
                                                            .set(data.toJson());
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ))))
                                : (snapshot2.data.docs[index]['status'] ==
                                        'unverified')
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.help_outlined,
                                          color: Colors.amber,
                                          size: 50.0,
                                        ),
                                        onPressed: () => showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                    title: const Text(
                                                        'Change Status'),
                                                    content: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.check_circle,
                                                            color: Colors.green,
                                                            size: 50,
                                                          ),
                                                          onPressed: () async {
                                                            // * verified button
                                                            LeadsData data = LeadsData(
                                                                snapshot2.data
                                                                        .docs[index]
                                                                    ['name'],
                                                                snapshot2.data
                                                                            .docs[
                                                                        index]
                                                                    ['city'],
                                                                'verified',
                                                                snapshot2.data
                                                                            .docs[
                                                                        index]
                                                                    ['type'],
                                                                snapshot2
                                                                    .data
                                                                    .docs[index]
                                                                    .id,
                                                                snapshot2.data
                                                                            .docs[
                                                                        index]
                                                                    ['phone-number']);
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'test')
                                                                .doc('leads')
                                                                .collection(
                                                                    'data')
                                                                .doc(data.docID)
                                                                .set(data
                                                                    .toJson());
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.help_outlined,
                                                            color: Colors.amber,
                                                            size: 50.0,
                                                          ),
                                                          onPressed: () async {
                                                            // * unverified button
                                                            LeadsData data = LeadsData(
                                                                snapshot2.data
                                                                        .docs[index]
                                                                    ['name'],
                                                                snapshot2.data
                                                                            .docs[
                                                                        index]
                                                                    ['city'],
                                                                'unverified',
                                                                snapshot2.data
                                                                            .docs[
                                                                        index]
                                                                    ['type'],
                                                                snapshot2
                                                                    .data
                                                                    .docs[index]
                                                                    .id,
                                                                snapshot2.data
                                                                            .docs[
                                                                        index]
                                                                    ['phone-number']);
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'test')
                                                                .doc('leads')
                                                                .collection(
                                                                    'data')
                                                                .doc(data.docID)
                                                                .set(data
                                                                    .toJson());
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.cancel,
                                                            color: Colors.red,
                                                            size: 50.0,
                                                          ),
                                                          onPressed: () async {
                                                            // * dead button
                                                            LeadsData data = LeadsData(
                                                                snapshot2.data
                                                                        .docs[index]
                                                                    ['name'],
                                                                snapshot2.data
                                                                            .docs[
                                                                        index]
                                                                    ['city'],
                                                                'dead',
                                                                snapshot2.data
                                                                            .docs[
                                                                        index]
                                                                    ['type'],
                                                                snapshot2
                                                                    .data
                                                                    .docs[index]
                                                                    .id,
                                                                snapshot2.data
                                                                            .docs[
                                                                        index]
                                                                    ['phone-number']);
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'test')
                                                                .doc('leads')
                                                                .collection(
                                                                    'data')
                                                                .doc(data.docID)
                                                                .set(data
                                                                    .toJson());
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    ))),
                                      )
                                    : IconButton(
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                          size: 50.0,
                                        ),
                                        onPressed: () => showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                    title: const Text(
                                                        'Change Status'),
                                                    content: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.check_circle,
                                                            color: Colors.green,
                                                            size: 50,
                                                          ),
                                                          onPressed: () async {
                                                            // * verified button
                                                            LeadsData data = LeadsData(
                                                                snapshot2.data
                                                                        .docs[index]
                                                                    ['name'],
                                                                snapshot2.data
                                                                            .docs[
                                                                        index]
                                                                    ['city'],
                                                                'verified',
                                                                snapshot2.data
                                                                            .docs[
                                                                        index]
                                                                    ['type'],
                                                                snapshot2
                                                                    .data
                                                                    .docs[index]
                                                                    .id,
                                                                snapshot2.data
                                                                            .docs[
                                                                        index]
                                                                    ['phone-number']);
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'test')
                                                                .doc('leads')
                                                                .collection(
                                                                    'data')
                                                                .doc(data.docID)
                                                                .set(data
                                                                    .toJson());
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.help_outlined,
                                                            color: Colors.amber,
                                                            size: 50.0,
                                                          ),
                                                          onPressed: () async {
                                                            // * unverified button
                                                            LeadsData data = LeadsData(
                                                                snapshot2.data
                                                                        .docs[index]
                                                                    ['name'],
                                                                snapshot2.data
                                                                            .docs[
                                                                        index]
                                                                    ['city'],
                                                                'unverified',
                                                                snapshot2.data
                                                                            .docs[
                                                                        index]
                                                                    ['type'],
                                                                snapshot2
                                                                    .data
                                                                    .docs[index]
                                                                    .id,
                                                                snapshot2.data
                                                                            .docs[
                                                                        index]
                                                                    ['phone-number']);
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'test')
                                                                .doc('leads')
                                                                .collection(
                                                                    'data')
                                                                .doc(data.docID)
                                                                .set(data
                                                                    .toJson());
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: Icon(
                                                            Icons.cancel,
                                                            color: Colors.red,
                                                            size: 50.0,
                                                          ),
                                                          onPressed: () async {
                                                            // * dead button
                                                            LeadsData data = LeadsData(
                                                                snapshot2.data
                                                                        .docs[index]
                                                                    ['name'],
                                                                snapshot2.data
                                                                            .docs[
                                                                        index]
                                                                    ['city'],
                                                                'dead',
                                                                snapshot2.data
                                                                            .docs[
                                                                        index]
                                                                    ['type'],
                                                                snapshot2
                                                                    .data
                                                                    .docs[index]
                                                                    .id,
                                                                snapshot2.data
                                                                            .docs[
                                                                        index]
                                                                    ['phone-number']);
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'test')
                                                                .doc('leads')
                                                                .collection(
                                                                    'data')
                                                                .doc(data.docID)
                                                                .set(data
                                                                    .toJson());
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    ))),
                                      ),
                            title: Text(snapshot2.data.docs[index]['name']),
                            subtitle: Text(
                                'City : ${snapshot2.data.docs[index]['city']}'),
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
                                    Text(
                                        '${snapshot2.data.docs[index]['name']}')
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
                                    Text(
                                        '${snapshot2.data.docs[index]['city']}')
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
                                        '${snapshot2.data.docs[index]['phone-number']}')
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
                                        '${snapshot2.data.docs[index]['status']}')
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
                                    Text(
                                        '${snapshot2.data.docs[index]['type']}')
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
                                                      snapshot2
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

  OverlayEntry createOverLayEntry() {
    return OverlayEntry(
        builder: (context) => Positioned(
                child: Bubble(
              margin: BubbleEdges.only(top: 5),
              alignment: Alignment.center,
              nip: BubbleNip.leftCenter,
              child: Text('Unverified - Test'),
            )l̥
                ));
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
      appBar: (_selectedIndex == 0) ? appbarBeds : appbarLeads,
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
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
