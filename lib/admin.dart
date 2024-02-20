import 'package:flutter/material.dart';
import 'dealersignup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
        actions: [
          IconButton(
            onPressed: () {
              // Implement functionality for logging out admin
              Navigator.pop(context); // Return to previous screen
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Welcome, Admin!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Register a new authorized dealer?',
            style: TextStyle(fontSize: 18),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DealerSignupPage()),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFEC2D33)), // Set button background color
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color to white
            ),
            child: Text('Register Dealer'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Approved Requests',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ApprovedRequestsList(),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Registered Vehicles',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: RegisteredVehiclesList(),
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}

class ApprovedRequestsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('inspectiondata').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(), // Display a loading indicator while fetching data
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index) {
              final doc = data.docs[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: GestureDetector(
                  onTap: () {
                    // Show popup with details
                    showDialog(
                      context: context,
                      builder: (context) {
                        // Convert cost_data to a string
                        String costDataString = doc['cost_data'].toString();
                        return AlertDialog(
                          title: Text('Details'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Name: ${doc['name']}'),
                              Text('Email: ${doc['email']}'),
                              Text('Phone: ${doc['phone']}'),
                              Text('Address: ${doc['address']}'),
                              Text('Vehicle Model: ${doc['vehicle_model']}'),
                              Text('Doc ID: ${doc.id}'),
                              Text('Cost Data: $costDataString'),
                              // Add more details as needed
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      title: Text('Name: ${doc['name']}'),
                      subtitle: Text('Vehicle Model: ${doc['vehicle_model']}'),
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Text('No approved requests found.');
      },
    );
  }
}



class RegisteredVehiclesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('vehicleregistration').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(), // Display a loading indicator while fetching data
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index) {
              final doc = data.docs[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    title: Text('Name: ${doc['name']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Model: ${doc['model']}'),
                        Text('License Plate Number: ${doc['licenseplateNumber']}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Text('No registered vehicles found.');
      },
    );
  }
}




