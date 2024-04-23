import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather/services/auth/auth_service.dart';
import 'package:weather/components/my_button.dart';
import 'package:weather/components/my_textfield.dart';

class LogInPage extends StatelessWidget {
  //email and pss
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  // tap to go to register page
  final void Function()? onTap;

  LogInPage({
    super.key,
    required this.onTap,
  });

  //login methof
  void login(BuildContext context) async {
    //auth service

    final authService = AuthService();

    //try login
    try {
      await authService.signInWithEmailPassword(
          _emailController.text, _pwController.text);
    }

    // catch any errors
    catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 50),
            //welcome back
            Text(
              "Welcome back, you've been missed!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),

            const SizedBox(
              height: 25,
            ),
            // email tf
            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),
            const SizedBox(height: 10),
            //pw tf
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: _pwController,
            ),

            const SizedBox(height: 10),

            //login
            MyButton(
              text: "Login",
              onTap: () => login(context),
            ),

            const SizedBox(height: 10),

            //register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Register Now ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
