import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:medibuddy/localisation/locales.dart';


class AddMedicationScreen extends StatefulWidget {
  @override
  _AddMedicationScreenState createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  TextEditingController _medicationNameController = TextEditingController();
  TextEditingController _dosageController = TextEditingController();
  TextEditingController _whenToTakeController = TextEditingController();

  String selectedType = "Capsules"; // Default selected type
  final List<String> medicationTypes = ["Tablet", "Capsules", "Drops", "Syrup"];

  DateTime? _fromDate;
  DateTime? _toDate;
  TimeOfDay? _reminderTime;
  TextEditingController _tabletController = TextEditingController();
  int? totalTablets;
  bool isOutOfStock = false; // Track stock status

  void _checkStockLevel() {
    if (totalTablets != null && totalTablets! <= 2) {
      setState(() {
        isOutOfStock = true;
      });
    } else {
      setState(() {
        isOutOfStock = false;
      });
    }
  }

  // Function to pick a date with light blue theme
  Future<void> _selectDate(BuildContext context, bool isFrom) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
      isFrom ? _fromDate ?? DateTime.now() : _toDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.lightBlue, // Header color
            colorScheme: ColorScheme.light(
                primary: Colors.lightBlue), // Selected date highlight
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isFrom) {
          _fromDate = pickedDate;
        } else {
          _toDate = pickedDate;
        }
      });
    }
  }

  // Function to pick a time with blue theme
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.lightBlue, // Header color
            colorScheme:
            ColorScheme.light(primary: Colors.lightBlue), // Clock color
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        _reminderTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section with Image & Back Button
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    image: DecorationImage(
                      image: AssetImage(
                          "assets/medicine_stock.png"), // Ensure correct file name
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add New Medication",
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),

                    // Medicine Name Field
                    Text("Medicine Name"),
                    SizedBox(height: 5),
                    TextField(
                      controller: _medicationNameController, // Ensure controller is assigned
                      decoration: InputDecoration(
                        hintText: "Enter Name",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Medication Type Selection
                    Text("Select Type"),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: medicationTypes.map((type) {
                        bool isSelected = type == selectedType;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedType = type;
                            });
                          },
                          child: Chip(
                            label: Text(
                              type,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            backgroundColor: isSelected
                                ? Colors.lightBlue
                                : Colors.grey[300],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),

                    // Dosage Field
                    Text(LocaleData.dosage.getString(context)),
                    SizedBox(height: 5),
                    TextField(
                      controller: _dosageController,
                      decoration: InputDecoration(
                        hintText: LocaleData.dosageex.getString(context),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),

                    // When to Take Field
                    Text(LocaleData.whentotake.getString(context)),
                    SizedBox(height: 5),
                    TextField(
                      controller: _whenToTakeController,
                      decoration: InputDecoration(
                        hintText: "e.g. Morning, After Food",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Total Tablets Field
                    Text(LocaleData.totaltablets.getString(context)),
                    SizedBox(height: 5),
                    TextField(
                      controller: _tabletController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter total tablets",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          totalTablets = int.tryParse(value);
                          _checkStockLevel();
                        });
                      },
                    ),
                    if (isOutOfStock) // Show warning when tablets are low
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          LocaleData.outofstock.getString(context),
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    SizedBox(height: 20),

                    // Duration Fields (From - To with Date Pickers)
                    Text(LocaleData.duration.getString(context)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectDate(context, true),
                            child: AbsorbPointer(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: _fromDate == null
                                      ? "From"
                                      : "${_fromDate!.day}-${_fromDate!.month}-${_fromDate!.year}",
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(LocaleData.to.getString(context)),
                        SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectDate(context, false),
                            child: AbsorbPointer(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: _toDate == null
                                      ? "To"
                                      : "${_toDate!.day}-${_toDate!.month}-${_toDate!.year}",
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Select Reminder Time with Clock Picker
                    Text(LocaleData.remindertime.getString(context)),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => _selectTime(context),
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: _reminderTime == null
                                ? "Select Reminder Time"
                                : "${_reminderTime!.hourOfPeriod}:${_reminderTime!.minute.toString().padLeft(2, '0')} ${_reminderTime!.period == DayPeriod.am ? 'AM' : 'PM'}",
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.access_time),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Save Button
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.lightBlue,
                        ),
                        onPressed: () async {
                          try {
                            final supabase = Supabase.instance.client;
                            final user = supabase.auth.currentUser;
                            print("User ID: ${user?.id}");


                            if (user == null) {
                              throw Exception("User not authenticated.");
                            }

                            await supabase.from('medications').insert({
                              'name': _medicationNameController.text,
                              'type': selectedType,
                              'dosage': _dosageController.text,
                              'frequency': _whenToTakeController.text,
                              'total_tablets':
                              int.tryParse(_tabletController.text) ?? 0,
                              'start_date': _fromDate?.toIso8601String() ?? '',
                              'end_date': _toDate?.toIso8601String() ?? '',
                              'reminder_time': _reminderTime?.format(context),
                              'user_id': user.id,
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                  Text(LocaleData.medication_successfully_added.getString(context))),
                            );

                            Navigator.pop(context);
                          } catch (error) {
                            print("Error adding medication: $error");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(LocaleData.failed_medication.getString(context))),
                            );
                          }
                        },
                        child: Text(
                          LocaleData.savemedication.getString(context),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _medicationNameController.dispose();
    _dosageController.dispose();
    _whenToTakeController.dispose();
    _tabletController.dispose();
    super.dispose();
  }
}