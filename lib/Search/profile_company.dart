import 'package:flutter/material.dart';
import 'package:we_work_app/Widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     colors: [Colors.deepOrange.shade300, Colors.green.shade300],
      //     begin: Alignment.centerLeft,
      //     end: Alignment.centerRight,
      //     stops: const [0.2, 0.9],
      //   ),
      // ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(
          indexNum: 3,
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Profile Screen',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Commotion',
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange.shade300, Colors.green.shade300],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.9],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
