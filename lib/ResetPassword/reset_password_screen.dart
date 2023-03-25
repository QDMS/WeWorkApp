// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:we_work_app/LoginPage/login_screen.dart';

import '../Services/global_variables.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword>
    with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _resetPasswordController =
  TextEditingController(text: '');

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation =
    CurvedAnimation(parent: _animationController, curve: Curves.linear)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((animationStatus) {
        if (animationStatus == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward();
    super.initState();
  }

  void _resetPasswordSubmitForm() async
  {
    try {
      await _auth.sendPasswordResetEmail(email: _resetPasswordController.text,
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()));
    }catch(error)
    {
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: resetpasswordUrlImage,
            placeholder: (context, url) =>
                Image.asset(
                  'assets/images/wallpaper.jpg',
                  fit: BoxFit.fill,
                ),
            errorWidget: (context, url, error) =>
            const Icon(Icons.error_rounded),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                const Text(
                  'Reset Password',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Commotion',
                    fontSize: 55,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Email Address',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _resetPasswordController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white54,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                MaterialButton(
                  onPressed: () {
                    //Create ResetPasswordSubmit
                    _resetPasswordSubmitForm();
                  },
                  color: Colors.redAccent.withOpacity(0.75),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Reset Now',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        fontStyle: FontStyle.italic,),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
