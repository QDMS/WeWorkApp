import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:we_work_app/user_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text(
                    'We Work app is being initialized',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 38,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'RubikOne',
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text(
                    'An error has occurred',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 38,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'We Work App',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.black,
              primarySwatch: Colors.red,
            ),
            home: UserState(),
          );
        });
  }
}
