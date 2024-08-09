import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_project/view/HomePage.dart';
import 'package:flutter_course_project/view/OnBoarding.dart';
import 'model/localDatabase/sharedPrefferences.dart';
import 'view/Login.dart';
import 'model/firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseFirestore.instance.settings;
  // print("Firebase initialization complete.");
  runApp(
      MaterialApp(
        home: MyApp(),
        theme: ThemeData(fontFamily: 'Cairo'),
        debugShowCheckedModeBanner: false,
      )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: checkIsNeedOnBoarding(), builder:
    (context,snapshot){
      if(snapshot.connectionState==ConnectionState.done){
        bool needOnBoarding=snapshot.data??true;
        return needOnBoarding ? const OnBoarding(): FutureBuilder<bool?>(
          future: isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              bool? isLoggedI = snapshot.data;
              return showHomeIfLoggedIn(isLoggedI);
            } else {
              // While the Future is still in progress, show a loading indicator
              return const CircularProgressIndicator();
            }
          },
        );
      }
      else{
       return const CircularProgressIndicator();
      }
    }
    );

  }

  FutureBuilder<String?> showHomeIfLoggedIn(bool? isLoggedI) {
    return FutureBuilder(
        future: getUserID(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            String? userId = snapshot.data;
            return MaterialApp(
              theme: ThemeData(fontFamily: 'Cairo'),
              home: isLoggedI == true && userId != null
                  ? HomePage(studentId: userId)
                  : LoginPage(),
              debugShowCheckedModeBanner: false,
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

