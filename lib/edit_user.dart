import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditUser extends StatelessWidget {
  EditUser(this.userList, {Key? key}) {
    _controllerEmail = TextEditingController(text: userList['Email']);
    _controllerPassword = TextEditingController(text: userList['password']);

    _reference = FirebaseFirestore.instance
        .collection('Users')
        .doc(userList['id']);
  }

  Map userList;
  late DocumentReference _reference;

  late TextEditingController _controllerEmail;
  late TextEditingController _controllerPassword;
  final GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit an item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              TextFormField(
                controller: _controllerEmail,
                decoration:
                InputDecoration(hintText: 'Enter the name of the item'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item name';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _controllerPassword,
                decoration:
                InputDecoration(hintText: 'Enter the quantity of the item'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item quantity';
                  }

                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      String email = _controllerEmail.text;
                      String password = _controllerPassword.text;

                      //Create the Map of data
                      Map<String,String> dataToUpdate={
                        'Email':email,
                        'password':password
                      };

                      //Call update()
                      _reference.update(dataToUpdate);
                    }
                  },
                  child: Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}