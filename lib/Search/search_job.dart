import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Job Search',
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
