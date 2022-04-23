import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:makananan/helper/helper_functions.dart';
import 'package:makananan/pages/selectcity_page.dart';

import 'pages/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _getLoggedInState();
  }

  _getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        isLoggedIn  = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'makananan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF307EFF),
      ),
      home: isLoggedIn != null ? isLoggedIn ? SelectCityPage() : OnboardingPage() : OnboardingPage(),
    );
  }
}
