import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:we_work_app/Jobs/jobs_screen.dart';
import 'package:we_work_app/Jobs/upload_job.dart';
import 'package:we_work_app/Search/profile_company.dart';
import 'package:we_work_app/Search/search_companies.dart';
import 'package:we_work_app/user_state.dart';

class BottomNavigationBarForApp extends StatelessWidget {
  int indexNum = 0;

  BottomNavigationBarForApp({super.key, required this.indexNum});

  void _logout(context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(
        context: context,
        builder: (context) {
          return ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Colors.deepOrange.shade300, Colors.green.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: AlertDialog(
              backgroundColor: Colors.black54,
              title: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Sign Out',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                ],
              ),
              content: const Text(
                'Do you want to Log Out?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => UserState()));
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Colors.deepOrange.shade300, Colors.green.shade300],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: CurvedNavigationBar(
        color: Colors.white,
        backgroundColor: Colors.white10.withOpacity(0.001),
        buttonBackgroundColor: Colors.white,
        height: 50,
        index: indexNum,
        items: const [
          Icon(
            Icons.list_rounded,
            size: 20,
            color: Colors.black,
          ),
          Icon(
            Icons.search_rounded,
            size: 20,
            color: Colors.black,
          ),
          Icon(
            Icons.add_rounded,
            size: 20,
            color: Colors.black,
          ),
          Icon(
            Icons.person_pin_rounded,
            size: 20,
            color: Colors.black,
          ),
          Icon(
            Icons.exit_to_app_rounded,
            size: 20,
            color: Colors.black,
          ),
        ],
        animationDuration: const Duration(
          milliseconds: 300,
        ),
        animationCurve: Curves.bounceInOut,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => JobScreen()));
          } else if (index == 1) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => WorkersScreen()));
          } else if (index == 2) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => UploadJobs()));
          } else if (index == 3) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => ProfileScreen()));
          } else if (index == 4) {
            _logout(context);
          }
        },
      ),
    );
  }
}
