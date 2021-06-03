import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Hospital Entry'),
      ),
      body: AddHospital(),
    );
  }
}

class AddHospital extends StatefulWidget {
  AddHospital({Key? key}) : super(key: key);
  @override
  AddHospitalState createState() {
    return AddHospitalState();
  }
}

class AddHospitalState extends State<AddHospital> {
  final _formkey = GlobalKey<FormState>();
  final hNameController = TextEditingController();
  final hAddressController = TextEditingController();
  final icuController = TextEditingController();
  final ventController = TextEditingController();
  final nBedsController = TextEditingController();
  final oBedsController = TextEditingController();

  Widget build(BuildContext context) {
    return Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 3.0,
                          )),
                      labelText: 'Hospital Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid hospital name';
                    }
                    return null;
                  },
                  controller: hNameController,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 3.0,
                          )),
                      labelText: 'Hospital Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid hospital address';
                    }
                    return null;
                  },
                  controller: hAddressController,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 3.0,
                          )),
                      labelText: 'Number of ICUs'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of icu beds';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: icuController,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 3.0,
                          )),
                      labelText: 'Number of Ventilators'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of ventilator beds';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: ventController,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 3.0,
                          )),
                      labelText: 'Number of Normal Beds'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of normal beds';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: nBedsController,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 3.0,
                          )),
                      labelText: 'Number of Oxygen Beds'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of oxygen beds';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: oBedsController,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // todo : add to firebase here
                  int totalbeds = int.parse(icuController.text) +
                      int.parse(ventController.text) +
                      int.parse(oBedsController.text) +
                      int.parse(nBedsController.text);
                  var jsonData = toJson(
                      hNameController.text,
                      hAddressController.text,
                      int.parse(ventController.text),
                      int.parse(icuController.text),
                      int.parse(nBedsController.text),
                      int.parse(oBedsController.text),
                      totalbeds);
                  await FirebaseFirestore.instance
                      .collection('test')
                      .doc('beds')
                      .collection('data')
                      .add(jsonData);
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              )
            ],
          ),
        ));
  }

  Map<String, dynamic> toJson(hospitalName, hospitalAddress, ventilator, icu,
      normalBeds, oxygenBeds, totalBeds) {
    return {
      "Hospital Name": hospitalName,
      "Hospital Address": hospitalAddress,
      "ventilator": ventilator,
      "icu": icu,
      "normal-beds": normalBeds,
      "oxy-beds": oxygenBeds,
      "total-beds": totalBeds
    };
  }
}
