import 'package:crud_operations/login_screen.dart';
import 'package:crud_operations/users_list.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController controllerEmail= TextEditingController();
  TextEditingController controllerPassword= TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPhoneNo = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Flutter FireBase SignUp'),
      ),

      body: SingleChildScrollView(
        child: Column(

          children: [

            Container(
              alignment: Alignment.center,
              height: 350,
              child: Lottie.asset("assets/83168-login-success.json"),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: TextField(
                controller: controllerEmail,
                decoration: const InputDecoration(
                    hintText: 'Enter Email',
                    hintStyle: TextStyle(fontSize: 20)
                ),
              ),
            ),

            SizedBox(
              height: 70,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                child: TextField(
                  controller: controllerName,
                  decoration: const InputDecoration(
                      hintText: 'Enter UserName',
                      hintStyle: TextStyle(fontSize: 20)
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 70,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 20.0),
                child: TextField(
                  controller: controllerPhoneNo,
                  decoration: const InputDecoration(
                      hintText: 'Enter Phone No',
                      hintStyle: TextStyle(fontSize: 20)
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 70,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 20.0),
                child: TextField(
                  controller: controllerPassword,
                  decoration: const InputDecoration(
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(fontSize: 20),
                      suffixIcon: Icon(Icons.visibility)
                  ),
                ),
              ),
            ),

            GestureDetector(
              onDoubleTap: (){
                Navigator.push(
                  context,MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(50),
                child: const Card(
                  child: Text('Already Have an Acoount', style: TextStyle(fontSize: 18),),
                ),
              ),
            ),

            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton
                (onPressed: (){
                  var userEmail= controllerEmail.text.trim();
                  var name= controllerName.text.trim();
                  var phoneNo= controllerPhoneNo.text.trim();
                  var userPassword= controllerPassword.text.trim();
                  var uid = FirebaseFirestore.instance.collection('Users').doc(currentUser?.uid);

                  FirebaseAuth.instance.createUserWithEmailAndPassword
                    (email: userEmail, password: userPassword).then(
                          (value) =>
                      FirebaseFirestore.instance.collection('Users').doc(currentUser!.uid).set(
                        {
                          'Email' : userEmail,
                          'name' : name,
                          'phoneNo' : phoneNo,
                          'password' : userPassword,
                          'createdAt' : DateTime.now(),
                          'userid' : currentUser!.uid,
                        }).then((value) => {
                          FirebaseAuth.instance.signOut(),
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UsersList(uid)))
                      })
                  );
              }, child: const Text('Sign Up', style: TextStyle(fontSize: 20),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class FirebaseAnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver appAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);
}

