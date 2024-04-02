import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';
import 'admin.dart';
import 'dealer.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('email') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('email', _emailController.text);
      await prefs.setString('password', _passwordController.text);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
    }
    await prefs.setBool('rememberMe', _rememberMe);
  }

  Future<void> _signIn() async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _saveUserData();

      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection(
          'users').doc(userCredential.user!.uid).get();

      if (userDoc.exists) {
        String? role = userDoc.get('role');

        if (role == 'admin') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AdminPage()));
        } else if (role == 'dealer') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DealerPage()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => UserPage()));
        }
      } else {
        print('User document not found');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showSnackBar('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _showSnackBar('Wrong password provided for that user.');
      } else {
        _showSnackBar('Invalid Credentials');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }


  Future<void> _resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password reset email sent to $email'),
      ));
    } catch (e) {
      print('Error sending password reset email: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to send password reset email'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Image.asset(
                'assets/signin.png',
                // Replace 'signin_image.png' with your image asset path
                width: 350, // Adjust width as needed
                height: 350, // Adjust height as needed
              ),
            ),
            SizedBox(height: 20),
            // Add some space between the image and the form fields
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (bool? value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                      Text('Remember Me'),
                    ],
                  ),

                  SizedBox(height: 16.0),
                  _isLoading
                      ? CircularProgressIndicator() // Show loading indicator if _isLoading is true
                      : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true; // Set loading state to true
                      });
                      try {
                        // Your sign-in logic goes here
                        await _signIn();
                      } finally {
                        setState(() {
                          _isLoading = false; // Reset loading state
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFEC2D33)),
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white),
                    ),
                    child: Text('Sign In'),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Reset Password'),
                            content: TextFormField(
                              controller: TextEditingController(),
                              decoration: InputDecoration(
                                  labelText: 'Enter your email'),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  String email = _emailController.text.trim();
                                  if (email.isNotEmpty) {
                                    _resetPassword(email);
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text('Reset Password'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Forgot Password?'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



