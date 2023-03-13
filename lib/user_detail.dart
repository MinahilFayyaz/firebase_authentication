import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DetailUser extends StatelessWidget {
  DetailUser(this.userId, {Key? key}) : super(key: key)
  {
    _reference =
        FirebaseFirestore.instance.collection('Users').doc(userId);
    _futureData = _reference.get();
  }

  String userId;

  late DocumentReference _reference;

  late Future<DocumentSnapshot> _futureData;

  late Map data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
        actions: [
          IconButton(onPressed: ()
          {
            data['id']= userId;


          },
              icon: const Icon(Icons.edit)),

          IconButton(onPressed: (){
            _reference.delete();
          },
              icon: const Icon(Icons.delete))
        ],

      ),

      body: FutureBuilder<DocumentSnapshot>(
          future: _futureData,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (snapshot.hasError) {
              return Center(child: Text('Some error occurred ${snapshot.error}'));
            }
            if(snapshot.hasData){
              DocumentSnapshot documentSnapshot = snapshot.data;
              data = documentSnapshot.data() as Map;

              return Column(
                children: [
                  Text('${data['Email']}'),
                  Text('${data['password']}')
                ],
              );

            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      ),
    );
  }
}
