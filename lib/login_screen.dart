// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_operations/sign_up.dart';
import 'package:crud_operations/users_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<LoginScreen> {

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;

  GlobalKey<FormState> key=GlobalKey();

  final CollectionReference _reference= FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Flutter FireBase Login'),
      ),

      body: SingleChildScrollView(
        child: Form(
          key: key,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 350,
                child: Lottie.asset("assets/83168-login-success.json"),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
                child: TextFormField(
                  controller: controllerEmail,
                  decoration: const InputDecoration(
                    hintText: 'Enter Email',
                    hintStyle: TextStyle(fontSize: 20)
                  ),
                  validator: (String? value){

                    if(value==null || value.isEmpty)
                    {
                      return 'Please enter the item name';
                    }
                    return null;
                  },
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextFormField(
                  controller: controllerPassword,
                  decoration: const InputDecoration(
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(fontSize: 20),
                      suffixIcon: Icon(Icons.visibility)
                  ),

                  validator: (String? value){

                    if(value==null || value.isEmpty)
                    {
                      return 'Please enter the item name';
                    }

                    return null;
                  },
                ),
              ),

              GestureDetector(
                onDoubleTap: (){
                  Navigator.push(
                    context,MaterialPageRoute(builder: (context) => const SignUp()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(50),
                  child: const Card(
                    child: Text('Do not have an account', style: TextStyle(fontSize: 18),),
                  ),
                ),
              ),

                SizedBox(
                  height: 50,
                  width: 150,
                  child: ElevatedButton
                  (onPressed: () async {
                    if(key.currentState!.validate())
                    {
                      String userEmail= controllerEmail.text;
                      String userPassword=controllerPassword.text;
                      var uid = FirebaseFirestore.instance.collection('Users').doc(currentUser?.uid);

                      try{
                        final User? firebaseUser= (await FirebaseAuth.instance.signInWithEmailAndPassword(email: userEmail, password: userPassword)).user;

                        if(firebaseUser == null){

                          const Text('Email or Password not correct');
                        }
                        else{
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=> UsersList(uid)));
                        }
                      } on FirebaseAuthException catch (e)

                      {
                      Text('Error$e');
                      }
                      //Create a Map of data
                      Map<String,String> dataToSend={
                        'Email':userEmail,
                        'password':userPassword
                      };

                      //Add a new item
                      _reference.add(dataToSend);
                    }

                    var uid = FirebaseFirestore.instance.collection('Users').doc(currentUser?.uid);
                    Navigator.push(
                      context,MaterialPageRoute(builder: (context) => UsersList(uid)),
                    );

                  }, child: const Text('Login', style: TextStyle(fontSize: 20),),
                 ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
