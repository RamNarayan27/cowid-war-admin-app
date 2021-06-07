import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class EditLeadsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LeadsData lead = ModalRoute.of(context)!.settings.arguments as LeadsData;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Lead'),
      ),
      body: EditLead(ldata: lead),
    );
  }
}

class EditLead extends StatefulWidget {
  final LeadsData ldata;
  EditLead({Key? key, required this.ldata}) : super(key: key);
  @override
  EditLeadState createState() {
    return EditLeadState();
  }
}

class EditLeadState extends State<EditLead> {
  final _formkey = GlobalKey<FormState>();
  String? statusDropDownValue = 'Verified';
  String? cityDropDownValue = 'Chennai';
  final leadNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final leadTypeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final LeadsData ldata = widget.ldata;
    leadNameController.text = ldata.leadName!;
    phoneNumberController.text = ldata.phoneNumber.toString();
    leadTypeController.text = ldata.type!;
    statusDropDownValue = ldata.status!;
    cityDropDownValue = ldata.leadCity!;
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
                    ),
                  ),
                  labelText: 'Lead Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid Lead Name';
                  }
                  return null;
                },
                controller: leadNameController,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 3.0,
                    ),
                  ),
                  labelText: 'Phone Number',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid Phone Number';
                  }
                  return null;
                },
                controller: phoneNumberController,
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(
                      color: Colors.green,
                      width: 3.0,
                    ),
                  ),
                  labelText: 'Lead Type',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid Lead Type';
                  }
                  return null;
                },
                controller: leadTypeController,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Status',
                        style: TextStyle(
                            decorationColor: Colors.black26, fontSize: 18)),
                    DropdownButton(
                      value: statusDropDownValue,
                      underline: Container(
                        height: 2,
                        color: Colors.blue,
                      ),
                      items: <String>['verified', 'unverified', 'dead']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          statusDropDownValue = value;
                        });
                      },
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('City',
                        style: TextStyle(
                            decorationColor: Colors.black26, fontSize: 18)),
                    DropdownButton(
                      value: cityDropDownValue,
                      underline: Container(
                        height: 2,
                        color: Colors.blue,
                      ),
                      items: <String>[
                        'Chennai',
                        'Thanjavur',
                        'Vijayawada',
                        'Krishnagiri',
                        'Madurai',
                        'Trichy',
                        'Coimbatore'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          cityDropDownValue = value;
                        });
                      },
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
                child: ElevatedButton(
                  onPressed: () async {
                    // todo : add to firebase here
                    // final snackBar =
                    //     SnackBar(content: Text(statusDropDownValue!));
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    ldata.leadCity = cityDropDownValue;
                    ldata.leadName = leadNameController.text;
                    ldata.phoneNumber = int.parse(phoneNumberController.text);
                    ldata.status = statusDropDownValue;
                    ldata.type = leadTypeController.text;

                    await FirebaseFirestore.instance
                        .collection('test')
                        .doc('leads')
                        .collection('data')
                        .doc(ldata.docID)
                        .set(ldata.toJson());

                    Navigator.pop(context);
                  },
                  child: Text('Submit'),
                ))
          ],
        ),
      ),
    );
  }
}
