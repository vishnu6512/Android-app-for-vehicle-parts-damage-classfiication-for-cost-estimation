import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'captureimg.dart';

class DealerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dealer Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Inspection Requests',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              child: InspectionRequestsList(),
            ),
          ),
        ],
      ),
    );
  }
}

class InspectionRequestsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('inspectionrequests').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No inspection requests found.'));
        }

        return SingleChildScrollView( // Wrap with SingleChildScrollView
          child: ListView.builder(
            shrinkWrap: true, // Set shrinkWrap to true
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  color: Color(0xFFF1ECFF), // Background color
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Adjust padding as needed
                    leading: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Text(
                        '${data['name'][0].toUpperCase()}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${data['name']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1, // Limit to one line to prevent excessive height
                          overflow: TextOverflow.ellipsis, // Show ellipsis (...) if text overflows
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${data['vehicle_model']}',
                          style: TextStyle(color: Colors.grey),
                          maxLines: 1, // Limit to one line to prevent excessive height
                          overflow: TextOverflow.ellipsis, // Show ellipsis (...) if text overflows
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 100, // Adjust the width as needed
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${DateFormat.yMd().format(data['timestamp'].toDate())} | ${DateFormat.jm().format(data['timestamp'].toDate())}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                _deleteRequest(context, document.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),



                    onTap: () {
                      _showRequestDetails(context, data);
                    },
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }



  void _showRequestDetails(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Request Details'),
          backgroundColor: Color(0xFFF1ECFF), // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('Name: ${data['name']}'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('Email: ${data['email']}'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('Phone Number: ${data['phone']}'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('Address: ${data['address']}'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('Vehicle Model: ${data['vehicle_model']}'),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to CaptureImg screen with request details
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CaptureImg(requestData: data)),
                    );
                  },style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFEC2D33)), // Set button background color
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color to white
                ),
                  child: Text('Inspect'),
                ),
              ),
            ],
          ),
          actions: <Widget>[
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
  }


  void _deleteRequest(BuildContext context, String documentId) {
    FirebaseFirestore.instance
        .collection('inspectionrequests')
        .doc(documentId)
        .delete()
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request deleted successfully.'),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete request: $error'),
        ),
      );
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: DealerPage(),
  ));
}


