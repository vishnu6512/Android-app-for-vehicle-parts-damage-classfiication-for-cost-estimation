import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_document/open_document.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;



class UserPage extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = ModalRoute.of(context)!.settings.arguments as User?;
    String phoneNumber = '';

    return Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome,',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              user != null ? user.email! : 'User email not available',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFEC2D33)), // Set button background color
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color to white
              ),
              child: Text('Sign Out'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register_vehicle');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFEC2D33)), // Set button background color
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color to white
              ),
              child: Text('New User? Register Your Vehicle!'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/inspectionrequest');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFEC2D33)), // Set button background color
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color to white
              ),
              child: Text('Request Inspection'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Check Status'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Enter Phone Number'),
                            onChanged: (value) {
                              phoneNumber = value;
                            },
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                .collection('inspectiondata')
                                .where('phone', isEqualTo: phoneNumber)
                                .get();

                            if (querySnapshot.docs.isNotEmpty) {
                              var inspectionData = querySnapshot.docs.first.data();
                              print('Cost Data: ${(inspectionData as Map<String, dynamic>)['cost_data']}');

                              generateAndSavePdf(context, inspectionData);
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('No Inspection Data Found'),
                                    content: Text('No inspection data found for the entered phone number.'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            Navigator.pop(context);
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFEC2D33)), // Set button background color
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color to white
              ),
              child: Text('Check Status'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generateAndSavePdf(BuildContext context, Map<String, dynamic> inspectionData) async {
    final pw.Document pdfDoc = pw.Document();
    final now = DateTime.now(); // Get the current date and time
    final formattedDate = DateFormat('MM_dd_yyyy').format(now); // Format the date as MM_dd_yyyy

    // Define text styles for different sections of the invoice
    final pw.TextStyle titleStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16);
    final pw.TextStyle subTitleStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold);
    final pw.TextStyle contentStyle = pw.TextStyle(fontSize: 12);

    // Download images from URLs
    List<pw.Widget> imageWidgets = [];
    List<pw.Widget> rowWidgets = [];
    int count = 0;
    for (var imageUrl in inspectionData['image_urls']) {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final image = pw.MemoryImage(response.bodyBytes);
        rowWidgets.add(
          pw.Container(
            margin: pw.EdgeInsets.only(right: 10), // Add margin between images
            child: pw.Container(
              width: 200,
              height: 400,
              child: pw.Image(image),
            ),
          ),
        );
        count++;
        if (count == 2) {
          imageWidgets.add(
            pw.Row(
              children: rowWidgets,
            ),
          );
          rowWidgets = [];
          count = 0;
        }
      }
    }
    if (count == 1) {
      imageWidgets.add(
        pw.Row(
          children: rowWidgets,
        ),
      );
    }

    // Calculate total cost
    double totalCost = 0;
    inspectionData['cost_data'].forEach((key, value) {
      totalCost += value;
    });

    pdfDoc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Invoice header
              pw.Text('Invoice', style: titleStyle),
              pw.Divider(), // Add a divider line
              pw.SizedBox(height: 20), // Add some space

              // Invoice details
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Invoice Date:', style: subTitleStyle),
                  pw.Text(formattedDate, style: contentStyle), // Set the formatted date
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Invoice Number:', style: subTitleStyle),
                  pw.Text('${inspectionData['doc_id']}', style: contentStyle), // Set the invoice number
                ],
              ),
              pw.SizedBox(height: 20), // Add some space

              // Customer details
              pw.Text('Customer Details:', style: subTitleStyle),
              pw.SizedBox(height: 10),
              pw.Text('Name: ${inspectionData['name']}', style: contentStyle),
              pw.Text('Email: ${inspectionData['email']}', style: contentStyle),
              pw.Text('Phone: ${inspectionData['phone']}', style: contentStyle),
              pw.SizedBox(height: 20), // Add some space

              // Vehicle details
              pw.Text('Vehicle Details:', style: subTitleStyle),
              pw.SizedBox(height: 10),
              pw.Text('Model: ${inspectionData['vehicle_model']}', style: contentStyle),
              pw.SizedBox(height: 20), // Add some space

              // Cost data
              pw.Text('Cost Data:', style: subTitleStyle),
              pw.SizedBox(height: 10),
              for (var entry in inspectionData['cost_data'].entries)
                pw.Text('${entry.key}: \$${entry.value}', style: contentStyle),

              pw.SizedBox(height: 10), // Add separation before total cost

              // Total cost
              pw.Text('Total Cost:', style: subTitleStyle),
              pw.Text('\$${totalCost.toStringAsFixed(2)}', style: contentStyle), // Display total cost

              // Captured images
              pw.Text('Captured Images:', style: subTitleStyle),
              pw.SizedBox(height: 10),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: imageWidgets,
              ),
            ],
          );
        },
      ),
    );

    final directory = await getExternalStorageDirectory();
    final fileName = '${inspectionData['name']}_Invoice_$formattedDate.pdf'; // Set the file name
    final filePath = '${directory!.path}/$fileName'; // Include the file name in the path
    saveAndOpenPdf(context, pdfDoc, filePath);
  }








  void saveAndOpenPdf(BuildContext context, pw.Document pdf, String filePath) async {
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Show SnackBar using the saved reference to ScaffoldMessenger
    _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text('PDF saved at: $filePath'),
    ));

    OpenDocument.openDocument(filePath: filePath);
  }
}

