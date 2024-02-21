import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InspectionRequestPage extends StatefulWidget {
  const InspectionRequestPage({Key? key}) : super(key: key);

  @override
  _InspectionRequestPageState createState() => _InspectionRequestPageState();
}

class _InspectionRequestPageState extends State<InspectionRequestPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedModel;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
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

    Future<void> _submitInspectionRequest() async {
      try {
        setState(() {
          _isLoading = true;
        });
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('inspectionrequests')
            .add({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'address': addressController.text,
          'vehicle_model': selectedModel,
          'timestamp': FieldValue.serverTimestamp(),
        });
        String docId = docRef.id;
        print('Inspection request submitted successfully! Document ID: $docId');
        await docRef.update({'doc_id': docId});

        // Show a message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inspection request submitted successfully! An authorized dealer will contact you soon!'),
          ),
        );
      } catch (error) {
        print('Error submitting inspection request: $error');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Request Inspection'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                  setState(() {
                    selectedModel = newValue;
                  });
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
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _submitInspectionRequest,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFFEC2D33)),
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white),
                ),
                child: Text('Request Inspection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



