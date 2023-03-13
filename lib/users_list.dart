// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_operations/login_screen.dart';
import 'package:crud_operations/user_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

   @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  User? userId = FirebaseAuth.instance.currentUser;
  final currentUser= FirebaseAuth.instance;
  //late Stream<QuerySnapshot> _stream;
  //final CollectionReference _reference= FirebaseFirestore.instance.collection('Users');

  @override
   /*initState() {
    super.initState();

    _stream = _reference.snapshots();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter FireBase Users'),
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));

            }, child: const Icon(Icons.logout),
          )
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where("userId", isEqualTo: userId ?.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          if(snapshot.hasError)
          {
            return Center(
              child: Text('Some Error Occued ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator(),);
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Data Found"),);
          }
          if(snapshot!= null && snapshot.data!=null){
            return ListView.builder(itemBuilder: (context, index){
              var Email =snapshot.data!.docs[index]['Email'];
              var password =snapshot.data!.docs[index]['password'];
              var docId = snapshot.data!.docs[index].id;

            });
            QuerySnapshot querySnapshot= snapshot.data;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (BuildContext context,int index){
                QueryDocumentSnapshot document = documents[index];
                //var docId= snapshot.data!.documents[index].id;
                //var email= snapshot.data!.documents[index]['Email'];
                //var password= snapshot.data!.documents[index]['password'];

                return UserList(document : document);
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator()
          );
        },
      ),
    );
  }
}

class UserList extends StatefulWidget {
   const UserList({Key? key, required this.document,}) : super(key: key);

  final QueryDocumentSnapshot<Object?> document;

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailUser(widget.document.id)));
      },
      title: Text(widget.document['Email']),
      subtitle: Text(widget.document['password'])
    );
  }
}

