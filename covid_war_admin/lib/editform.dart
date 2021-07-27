import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class EditFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HospitalData hospital =
        ModalRoute.of(context)!.settings.arguments as HospitalData;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Form'),
      ),
      body: EditForm(hdata: hospital),
    );
  }
}

class EditForm extends StatefulWidget {
  final HospitalData hdata;
  EditForm({Key? key, required this.hdata}) : super(key: key);
  @override
  EditFormState createState() {
    return EditFormState();
  }
}

class EditFormState extends State<EditForm> {
  final _formkey = GlobalKey<FormState>();
  final hNameController = TextEditingController();
  final hAddressController = TextEditingController();
  final icuController = TextEditingController();
  final ventController = TextEditingController();
  final nBedsController = TextEditingController();
  final oBedsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final HospitalData hdata = widget.hdata;
    hNameController.text = hdata.hospitalName!;
    hAddressController.text = hdata.hospitalAddress!;
    icuController.text = hdata.icu!.toString();
    ventController.text = hdata.ventilator!.toString();
    nBedsController.text = hdata.normalBeds!.toString();
    oBedsController.text = hdata.oxygenBeds!.toString();
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
                  int totalbeds = int.parse(icuController.text) +
                      int.parse(ventController.text) +
                      int.parse(oBedsController.text) +
                      int.parse(nBedsController.text);

                  hdata.hospitalName = hNameController.text;
                  hdata.hospitalAddress = hAddressController.text;
                  hdata.icu = int.parse(icuController.text);
                  hdata.ventilator = int.parse(ventController.text);
                  hdata.normalBeds = int.parse(nBedsController.text);
                  hdata.oxygenBeds = int.parse(oBedsController.text);
                  hdata.totalBeds = totalbeds;

                  await FirebaseFirestore.instance
                      .collection('test')
                      .doc('beds')
                      .collection('data')
                      .doc(hdata.docId)
                      .set(hdata.toJson());

                  Navigator.pop(context);
                },
                child: Text('Submit'),
              )
            ],
          ),
        ));
  }
}
