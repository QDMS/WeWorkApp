import 'package:flutter/material.dart';
import 'package:we_work_app/Widgets/bottom_nav_bar.dart';

class WorkersScreen extends StatefulWidget {
  @override
  State<WorkersScreen> createState() => _WorkersScreenState();
}

class _WorkersScreenState extends State<WorkersScreen> {
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
          indexNum: 1,
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Workers Screen',
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
