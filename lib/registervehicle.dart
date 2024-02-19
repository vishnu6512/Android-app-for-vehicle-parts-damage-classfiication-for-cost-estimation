import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterVehiclePage extends StatefulWidget {
  const RegisterVehiclePage({Key? key}) : super(key: key);

  @override
  _RegisterVehiclePageState createState() => _RegisterVehiclePageState();
}

class _RegisterVehiclePageState extends State<RegisterVehiclePage> {
  String? selectedModel;
  String? name;
  String? phoneNumber;
  String? licenseplateNumber;
  String? address;
  String? emailId;
  DateTime? insuranceValidityDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (pickedDate != null && pickedDate != insuranceValidityDate) {
      setState(() {
        insuranceValidityDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Vehicle'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Register Your Vehicle',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedModel,
                decoration: InputDecoration(labelText: 'Vehicle Model'),
                items: [
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
                ].map((model) {
                  return DropdownMenuItem<String>(
                    value: model,
                    child: Text(model),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedModel = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  name = value;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  phoneNumber = value;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'License Plate Number'),
                onChanged: (value) {
                  licenseplateNumber = value;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                onChanged: (value) {
                  address = value;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email ID'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  emailId = value;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Insurance Validity Date:',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      insuranceValidityDate != null
                          ? '${insuranceValidityDate!.year}-${insuranceValidityDate!.month}-${insuranceValidityDate!.day}'
                          : 'Select Date',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Validate input
                  if (selectedModel != null &&
                      name != null &&
                      phoneNumber != null &&
                      licenseplateNumber != null &&
                      address != null &&
                      emailId != null &&
                      insuranceValidityDate != null) {
                    // Store the details in Firestore
                    await FirebaseFirestore.instance.collection('vehicleregistration').add({
                      'model': selectedModel,
                      'name': name,
                      'phoneNumber': phoneNumber,
                      'licenseplateNumber': licenseplateNumber,
                      'address': address,
                      'emailId': emailId,
                      'insuranceValidityDate': insuranceValidityDate,
                    });

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Vehicle registered successfully!'),
                    ));
                  } else {
                    // Show error message if any field is missing
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please fill out all fields.'),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                child: Text('Register Vehicle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

