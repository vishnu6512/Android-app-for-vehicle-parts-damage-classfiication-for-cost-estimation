import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inspect/admin.dart';
import 'package:inspect/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';
import 'signin.dart';
import 'user.dart';
import 'dealersignup.dart';
import 'dealer.dart';
import 'registervehicle.dart';
import 'inspectionrequest.dart';
import 'captureimg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  get data => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signup Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/signup': (context) => SignupPage(),
        '/signin': (context) => SigninPage(),
        '/user': (context) => UserPage(),
        '/admin': (context) => AdminPage(),
        '/dealersignup': (context) => DealerSignupPage(),
        '/dealer': (context) => DealerPage(),
        '/register_vehicle': (context) => RegisterVehiclePage(),
        '/inspectionrequest': (context) => InspectionRequestPage(),
        '/captureimg': (context) => CaptureImg(requestData: data),
      },
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text('Go to Signup'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signin');
              },
              child: Text('Go to Signin'),
            ),
          ],
        ),
      ),
    );
  }
}


