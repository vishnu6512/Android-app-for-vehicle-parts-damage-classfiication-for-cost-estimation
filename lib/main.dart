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
        title: Text('InsureDrive', textAlign: TextAlign.center,),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: Image.asset(
                  'assets/main.png', // Path to your image asset
                  width: 350,
                  height: 350,
                ),
              ),
            ),

            Text(
              'Welcome to InsureDrive,',
              style: TextStyle(
                color: Color(0xFF080A0B),
                fontSize: 32,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                height: 1.25, // Line height equivalent to 40px
              ),
              textAlign: TextAlign.center, // Text alignment property here
            ),
            SizedBox(height: 20),
            Text(
              'Discover the best insurance options for your vehicle',
              style: TextStyle(
                color: Color(0xFF5D5D5B),
                fontSize: 14,
                fontFamily: 'Montserrat',
                height: 1.5, // Line height equivalent to 18px
              ),
              textAlign: TextAlign.center, // Text alignment property here
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFEC2D33), // Background color
                onPrimary: Colors.white, // Text color
                minimumSize: Size(335, 48), // Width and height of the button
                padding: EdgeInsets.symmetric(horizontal: 8), // Horizontal padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24), // Button border radius
                ),
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  height: 1.25, // Line height equivalent to 20px
                ),
              ),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signin');
              },
              style: ElevatedButton.styleFrom(
                primary:  Colors.white,// Background color
                onPrimary: Color(0xFFEC2D33), // Text color
                minimumSize: Size(335, 48), // Width and height of the button
                padding: EdgeInsets.symmetric(horizontal: 8), // Horizontal padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24), // Button border radius
                ),
              ),
              child: Text('Existing User? Sign-In'),
            ),


          ],
        ),
      ),



    );
  }
}



