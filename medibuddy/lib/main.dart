//main.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'LoginPage.dart';
import 'localisation/locales.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://zpsmwulxocsnfoxpdpdo.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpwc213dWx4b2NzbmZveHBkcGRvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA4NTYwMjIsImV4cCI6MjA1NjQzMjAyMn0.nrn5iRtZqEczFYEiDcKamDwbd_cKn4221F7dVn6NNxw',
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    configureLocalization();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediBuddy',
      theme: ThemeData(primarySwatch: Colors.blue),
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      home: LoginScreen(), // Set Login Screen as the starting point
    );
  }

  void configureLocalization(){
    localization.init(mapLocales: LOCALES, initLanguageCode: 'en');
    localization.onTranslatedLanguage = onTranslatedLanguage;
  }

  void onTranslatedLanguage(Locale? locale) {
    setState(() {
    });
  }
}