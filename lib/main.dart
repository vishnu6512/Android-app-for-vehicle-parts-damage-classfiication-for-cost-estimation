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
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
          buttonColor: const Color(0xFFEC2D33),
          textTheme: ButtonTextTheme.primary,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
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
      home: SplashScreen(), // Set the splash screen as the initial route
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add any initialization logic here
    navigateToHomePage(); // Navigate to the home page after a delay
  }

  void navigateToHomePage() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()), // Navigate to the main page
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logomain.png',
              width: 350, // Adjust width as needed
              height: 100, // Adjust height as needed
            ),
            SizedBox(height: 20), // Add some spacing below the logo
            LoadingAnimationWidget.flickr(
              leftDotColor: const Color(0xFF1A1A3F),
              rightDotColor: const Color(0xFFEC2D33),
              size: 60,
            ),// Add a loading indicator
          ],
        ),
      ),
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
                  foregroundColor: Colors.white, backgroundColor: Color(0xFFEC2D33),
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
                  foregroundColor: Color(0xFFEC2D33), backgroundColor: Colors.white,
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







