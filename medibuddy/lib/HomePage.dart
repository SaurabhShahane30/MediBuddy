import 'package:flutter/material.dart';
import 'package:medibuddy/AddMedicationPage.dart';
import 'package:medibuddy/ProfilePage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:medibuddy/localisation/locales.dart';
import 'package:medibuddy/BuyMedication.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  int _selectedIndex = 0;

  Future<List<Map<String, dynamic>>> _fetchMedications() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception("User not authenticated.");
    }

    final response = await supabase
        .from('medications')
        .select()
        .eq('user_id', user.id);

    if (response.isEmpty) {
      return [];
    }

    return response.map((medicine) {
      // Convert start_date and end_date from String to DateTime
      DateTime? startDate = DateTime.tryParse(medicine['start_date'] ?? '');
      DateTime? endDate = DateTime.tryParse(medicine['end_date'] ?? '');

      // Check if the selected day falls within the range
      if (startDate != null && endDate != null &&
          (_selectedDay.isAtSameMomentAs(startDate) || _selectedDay.isAfter(startDate)) &&
          _selectedDay.isBefore(endDate.add(Duration(days: 1)))) {

        return {
          ...medicine,
          "taken": medicine["taken"] ?? false,
          "missed": medicine["missed"] ?? false,
          "remind": medicine["remind"] ?? false,
        };
      } else {
        return null; // Ignore medications outside the date range
      }
    }).where((medicine) => medicine != null).cast<Map<String, dynamic>>().toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch user data when the home page loads
  }

  String userName = "User"; // Default placeholder

  Future<void> _fetchUserName() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('name')
          .eq('id', user.id)
          .single();

      if (response != null && response['name'] != null) {
        setState(() {
          userName = response['name']; // Update state with user's name
        });
      }
    }
  }


  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPageContent() {
    if (_selectedIndex == 0) {
      return _buildHomeContent();
    } else if (_selectedIndex == 1) {
      return LocatePharmaciesPage();
    } else {
      return ProfilePage();
    }
  }

  Widget _buildHomeContent() {
    String formattedDate = "${_selectedDay.day.toString().padLeft(2, '0')}-"
        "${_selectedDay.month.toString().padLeft(2, '0')}-"
        "${_selectedDay.year}";

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(LocaleData.helloText.getString(context),
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(userName,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
                    ],
                  ),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assets/Saurabh_pic.PNG"),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Calendar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(10),
                child: TableCalendar(
                  firstDay: DateTime.utc(2024, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _selectedDay,
                  calendarFormat: _calendarFormat,
                  headerStyle: HeaderStyle(titleCentered: true, formatButtonVisible: false),
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(color: Colors.lightBlue[100], shape: BoxShape.circle),
                    selectedDecoration: BoxDecoration(color: Colors.lightBlueAccent, shape: BoxShape.circle),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Medicine List from Supabase
              Text("Medicines for $formattedDate", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchMedications(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No medications scheduled."));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var medicine = snapshot.data![index];

                        Color boxColor = Colors.lightBlue[100]!; // Default color
                        if (medicine["taken"]) {
                          boxColor = Colors.green[300]!;
                        } else if (medicine["missed"]) {
                          boxColor = Colors.red[300]!;
                        } else if (medicine["remind"]) {
                          boxColor = Colors.deepOrange[300]!;
                        }

                        return GestureDetector(
                          onTap: () {
                            _showMedicinePopup(medicine, index);
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: medicine["taken"]
                                  ? Colors.green[300]
                                  : medicine["missed"]
                                  ? Colors.red[300]
                                  : Colors.lightBlue[100],
                              borderRadius: BorderRadius.circular(15),
                            ),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${medicine['name']} - ${medicine['reminder_time']}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Icon(Icons.medical_services, color: Colors.blue, size: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Add Medication Button
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddMedicationScreen()));
            },
            backgroundColor: Colors.blue,
            child: Icon(Icons.add, size: 30, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _showMedicinePopup(Map<String, dynamic> medicine, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications_active, size: 50, color: Colors.orange),
              SizedBox(height: 10),
              Text(LocaleData.totake.getString(context),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(
                medicine["name"],
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        medicine["missed"] = true;
                        medicine["taken"] = false;
                        medicine["remind"] = false;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text(LocaleData.missed.getString(context)),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        medicine["taken"] = true;
                        medicine["missed"] = false;
                        medicine["remind"] = false;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text(LocaleData.taken.getString(context)),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    medicine["remind"] = true;
                    medicine["taken"] = false;
                    medicine["missed"] = false;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: Text(LocaleData.remindin5.getString(context)),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBF8FF),
      body: _getPageContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.local_pharmacy), label: "Buy Medicine"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}