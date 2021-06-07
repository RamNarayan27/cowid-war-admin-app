import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewLeadsEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Leads Entry'),
      ),
      body: AddLead(),
    );
  }
}

class AddLead extends StatefulWidget {
  AddLead({Key? key}) : super(key: key);
  @override
  AddLeadState createState() {
    return AddLeadState();
  }
}

class AddLeadState extends State<AddLead> {
  final _formkey = GlobalKey<FormState>();
  String? statusDropDownValue = 'Verified';
  String? cityDropDownValue = 'Chennai';
  final leadNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final leadTypeController = TextEditingController();
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
                      items: <String>['Verified', 'Unverified', 'Dead']
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
                    final snackBar =
                        SnackBar(content: Text(statusDropDownValue!));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    var jsonData = toJSON(
                        leadNameController.text,
                        int.parse(phoneNumberController.text),
                        leadTypeController.text,
                        statusDropDownValue,
                        cityDropDownValue);
                    await FirebaseFirestore.instance
                        .collection('test')
                        .doc('leads')
                        .collection('data')
                        .add(jsonData);
                    Navigator.pop(context);
                  },
                  child: Text('Submit'),
                ))
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> toJSON(leadName, phoneNumber, leadType, status, city) {
    return {
      "city": city,
      "name": leadName,
      "phone-number": phoneNumber,
      "status": status,
      "type": leadType
    };
  }
}
