// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:we_work_app/ResetPassword/reset_password_screen.dart';
import 'package:we_work_app/Services/global_methods.dart';
import 'package:we_work_app/Services/global_variables.dart';
import 'package:we_work_app/SignupScreen/signup_screen.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  final TextEditingController _emailController =
      TextEditingController(text: '');
  final TextEditingController _passwordController =
      TextEditingController(text: '');

  final FocusNode _passwordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _obscureText = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _loginFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    ;
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

  void _submitFormOnLogin() async {
    final isValid = _loginFormKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text.trim(),
        );
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), ctx: context);
        print('Error Occurred $error');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: loginUrlImage,
            placeholder: (context, url) => Image.asset(
              'assets/images/wallpaper.jpg',
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 80, right: 80),
                    child: Image.asset('assets/images/login.png'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passwordFocusNode),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email address';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color: Colors.green,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                              ),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          focusNode: _passwordFocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordController,
                          //change it dynamically
                          obscureText: !_obscureText,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a valid password';
                            } else if (value.length < 4) {
                              return 'Password must be 4 or more characters long!';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            suffixIcon: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.deepPurple, Colors.pink],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              color: Colors.green,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                              ),
                            ),
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResetPassword()));
                            },
                            child: const Text(
                              'Reset Password',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                          onPressed: _submitFormOnLogin,
                          color: Colors.green.withOpacity(0.75),
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.deepPurple, Colors.pink],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: RichText(
                            text: TextSpan(children: [
                              const TextSpan(
                                text: "Don't have an account?",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const TextSpan(text: '    '),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignUp())),
                                  text: 'Signup',
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  )),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
