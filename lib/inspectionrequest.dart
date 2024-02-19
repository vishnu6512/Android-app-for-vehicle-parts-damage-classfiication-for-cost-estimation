import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InspectionRequestPage extends StatelessWidget {
  const InspectionRequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the list of vehicle models
    List<String> vehicleModels = [
      'Wagon R',
      'Eco Sport',
      'Tiago',
      'Innova Hycross',
      'Maruti EECO',
      'Ertiga',
      'Baleno',
      'Alto',
      'IGNIS',
      'Brezza',
      'Eon',
      'Tigor',
    ];

    String? selectedModel;
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController addressController = TextEditingController();

    // Firestore instance
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    void _submitInspectionRequest() async {
      try {
        DocumentReference docRef = await _firestore.collection('inspectionrequests').add({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'address': addressController.text,
          'vehicle_model': selectedModel,
          'timestamp': FieldValue.serverTimestamp(), // Optional: Timestamp when request was made
        });

        // Get the document ID from the DocumentReference
        String docId = docRef.id;
        print('Inspection request submitted successfully! Document ID: $docId');

        // Update the document to store the document ID
        await docRef.update({'doc_id': docId});

        // Optionally, you can store the document ID or navigate to another screen here
      } catch (error) {
        // Error handling
        print('Error submitting inspection request: $error');
      }
    }



    return Scaffold(
      appBar: AppBar(
        title: Text('Request Inspection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Request Inspection',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
              maxLines: 2,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedModel,
              onChanged: (String? newValue) {
                // Update the selectedModel when the value changes
                selectedModel = newValue;
              },
              decoration: InputDecoration(labelText: 'Vehicle Model'),
              items: vehicleModels.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitInspectionRequest, // Call function to submit request
              child: Text('Request Inspection'),
            ),
          ],
        ),
      ),
    );
  }
}


