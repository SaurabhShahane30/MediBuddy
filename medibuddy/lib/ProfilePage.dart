import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> profileData = {
    "name": "Saurabh Shahane",
    "age": "19",
    "gender": "Male",
    "bloodGroup": "O+",
    "contactNo": "8291603656",
    "address": "Mumbai, India",
    "emergencyContact": {
      "name": "Vedika Parab",
      "email": "vedika@gmail.com",
      "phone": "8169366578"
    },
    "medicalBackground": {
      "medications": "Meftal Spas, Keterol DT, Paracetamol",
      "illnesses": "Cough",
      "allergies": "Dust"
    }
  };

  void navigateToEditPage(String section) async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(section: section, profileData: profileData),
      ),
    );

    if (updatedData != null) {
      setState(() {
        profileData = updatedData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), backgroundColor: Colors.blue),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/Saurabh_pic.PNG"),
                  ),
                  SizedBox(height: 10),
                  Text(profileData["name"], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 20),
            buildInfoSection("Personal Information", [
              buildInfoRow("Age", profileData["age"]),
              buildInfoRow("Gender", profileData["gender"]),
              buildInfoRow("Blood Group", profileData["bloodGroup"]),
              buildInfoRow("Contact No.", profileData["contactNo"]),
              buildInfoRow("Address", profileData["address"]),
            ], () => navigateToEditPage("Personal Information")),
            buildInfoSection("Emergency Contact", [
              buildInfoRow("Name", profileData["emergencyContact"]["name"]),
              buildInfoRow("Email", profileData["emergencyContact"]["email"]),
              buildInfoRow("Phone No.", profileData["emergencyContact"]["phone"]),
            ], () => navigateToEditPage("Emergency Contact")),
            buildInfoSection("Medical Background", [
              buildInfoRow("Medications", profileData["medicalBackground"]["medications"]),
              buildInfoRow("Chronic Illnesses", profileData["medicalBackground"]["illnesses"]),
              buildInfoRow("Allergies", profileData["medicalBackground"]["allergies"]),
            ], () => navigateToEditPage("Medical Background")),
          ],
        ),
      ),
    );
  }

  Widget buildInfoSection(String title, List<Widget> children, VoidCallback onEdit) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: onEdit),
              ],
            ),
            SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
          Expanded(flex: 5, child: Text(value, style: TextStyle(fontSize: 16, color: Colors.blueGrey))),
        ],
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String section;
  final Map<String, dynamic> profileData;
  EditProfilePage({required this.section, required this.profileData});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController controller1, controller2, controller3;

  @override
  void initState() {
    super.initState();
    if (widget.section == "Personal Information") {
      controller1 = TextEditingController(text: widget.profileData["age"]);
      controller2 = TextEditingController(text: widget.profileData["contactNo"]);
      controller3 = TextEditingController(text: widget.profileData["address"]);
    } else if (widget.section == "Emergency Contact") {
      controller1 = TextEditingController(text: widget.profileData["emergencyContact"]["name"]);
      controller2 = TextEditingController(text: widget.profileData["emergencyContact"]["email"]);
      controller3 = TextEditingController(text: widget.profileData["emergencyContact"]["phone"]);
    } else if (widget.section == "Medical Background") {
      controller1 = TextEditingController(text: widget.profileData["medicalBackground"]["medications"]);
      controller2 = TextEditingController(text: widget.profileData["medicalBackground"]["illnesses"]);
      controller3 = TextEditingController(text: widget.profileData["medicalBackground"]["allergies"]);
    }
  }

  void saveChanges() {
    if (widget.section == "Personal Information") {
      widget.profileData["age"] = controller1.text;
      widget.profileData["contactNo"] = controller2.text;
      widget.profileData["address"] = controller3.text;
    } else if (widget.section == "Emergency Contact") {
      widget.profileData["emergencyContact"]["name"] = controller1.text;
      widget.profileData["emergencyContact"]["email"] = controller2.text;
      widget.profileData["emergencyContact"]["phone"] = controller3.text;
    } else if (widget.section == "Medical Background") {
      widget.profileData["medicalBackground"]["medications"] = controller1.text.split(", ");
      widget.profileData["medicalBackground"]["illnesses"] = controller2.text.split(", ");
      widget.profileData["medicalBackground"]["allergies"] = controller3.text.split(", ");
    }
    Navigator.pop(context, widget.profileData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit ${widget.section}")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: controller1, decoration: InputDecoration(labelText: "Age")),
            TextField(controller: controller2, decoration: InputDecoration(labelText: "Contact No.")),
            TextField(controller: controller3, decoration: InputDecoration(labelText: "Address")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: saveChanges, child: Text("Save")),
          ],
        ),
      ),
    );
  }
}