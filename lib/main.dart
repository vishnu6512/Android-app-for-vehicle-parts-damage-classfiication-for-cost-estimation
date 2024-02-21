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
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: ButtonThemeData(
          buttonColor: const Color(0xFFEC2D33), // Set button background color
          textTheme: ButtonTextTheme.primary, // Use primary text style (white)
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white, // Set dialog background color to white
        ),
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10), // Reduce the gap here
              Image.asset(
                'assets/logomain.png',
                width: 350,
                height: 100,
              ),
              SizedBox(height: 1), // Reduce the gap here
              Image.asset(
                'assets/main.png',
                width: 350,
                height: 350,
              ),
              SizedBox(height: 10), // Reduce the gap here
              Text(
                'Welcome to InsureDrive,',
                style: TextStyle(
                  color: Color(0xFF080A0B),
                  fontSize: 32,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10), // Reduce the gap here
              Text(
                'Discover the best insurance options for your vehicle',
                style: TextStyle(
                  color: Color(0xFF5D5D5B),
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10), // Reduce the gap here
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFEC2D33),
                  onPrimary: Colors.white,
                  minimumSize: Size(335, 48),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
              ),
              SizedBox(height: 10), // Reduce the gap here
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signin');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Color(0xFFEC2D33),
                  minimumSize: Size(335, 48),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text('Existing User? Sign-In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






