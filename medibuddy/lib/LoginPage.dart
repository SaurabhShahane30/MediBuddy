//LoginPage.dart
import 'package:flutter/material.dart';
import 'SignUppage.dart';
import 'HomePage.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:medibuddy/localisation/locales.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _errorMessage;
  final supabase = Supabase.instance.client;

  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;

  @override
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = _flutterLocalization.currentLocale!.languageCode;
  }

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final response = await supabase.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (response.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } on AuthException catch (e) {
        setState(() {
          _errorMessage = e.message;
        });
      } catch (e) {
        setState(() {
          _errorMessage = "Something went wrong. Please try again.";
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _setLocale(String? value) {
    if (value == null) return;
    _flutterLocalization.translate(value);
    setState(() {
      _currentLocale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Language Dropdown
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          spreadRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _currentLocale,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.blue),
                        dropdownColor: Colors.white,
                        style:
                        const TextStyle(fontSize: 16, color: Colors.black),
                        items: const [
                          DropdownMenuItem(value: 'en', child: Text('English')),
                          DropdownMenuItem(value: 'hi', child: Text('हिंदी')),
                          DropdownMenuItem(value: 'mr', child: Text('मराठी')),
                        ],
                        onChanged: (value) {
                          _setLocale(value);
                        },
                      ),
                    ),
                  ),
                ),

                // Logo
                Image.asset("assets/medi_buddy.png", width: 250, height: 250),
                const SizedBox(height: 10),

                // Welcome Text
                Text(LocaleData.welcomeBack.getString(context),
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey)),
                Text(LocaleData.welcomeBackText.getString(context),
                    style: TextStyle(fontSize: 16, color: Colors.grey)),

                const SizedBox(height: 30),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
                          } else if (!RegExp(
                              r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                              .hasMatch(value)) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Error Message
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: _isLoading ? null : login,
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text("LOG IN",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Sign Up Navigation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(LocaleData.donthaveaccount.getString(context),
                              style: TextStyle(color: Colors.black)),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()),
                              );
                            },
                            child: Text(LocaleData.signupnow.getString(context),
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),

                      SizedBox(
                          height:
                          MediaQuery.of(context).viewInsets.bottom + 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}