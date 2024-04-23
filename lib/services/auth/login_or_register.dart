import 'package:flutter/material.dart';
import 'package:weather/pages/login_page.dart';
import 'package:weather/pages/register_page.dart';

class LogInOrRegister extends StatefulWidget {
  const LogInOrRegister({super.key});

  // This widget is the root of your application.
  @override
  State<LogInOrRegister> createState() => _LogInOrRegisterState();
}

class _LogInOrRegisterState extends State<LogInOrRegister> {
  //initially show login Page
  bool showLogInPage = true;

  //toggle between two pages
  void togglePages() {
    setState(() {
      showLogInPage = !showLogInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogInPage) {
      return LogInPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}
