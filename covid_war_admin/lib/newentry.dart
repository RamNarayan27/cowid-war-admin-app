// todo : finish the form
// todo : use outline input border for the fields
// todo : fields are Hospital Name, #icu, #venti, #o2bed, #normalbed, #totalbeds, hospital address
// todo : ontap func 1 - add a new entry to firebase
// todo : ontap func 2 - send the values back and make a new card and show these values
// todo : ontap func 2 - send the data to the endpoint

import 'package:flutter/material.dart';

class NewEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Hospital Entry'),
      ),
      body: Center(
        // ! change the layout to mimic a form and send the values back
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back again!'),
        ),
      ),
    );
  }
}
