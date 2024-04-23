import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather/services/auth/auth_service.dart';
import 'package:weather/components/my_button.dart';
import 'package:weather/components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  final void Function()? onTap;

  RegisterPage({
    super.key,
    required this.onTap,
  });

  // register method

  void register(BuildContext context) {
    // get auth service
    final _auth = AuthService();
// if passwords match
    if (_pwController.text == _confirmPwController.text) {
      try {
        _auth.signUpWithEmailPassword(
          _emailController.text,
          _pwController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
    //passwords dont match then
    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords Dont Match"),
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
              "Let's create your Account..",
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
            //CNFRM pw tf
            MyTextField(
              hintText: " Confirm Password",
              obscureText: true,
              controller: _confirmPwController,
            ),

            const SizedBox(height: 10),

            //login
            MyButton(
              text: "Register",
              onTap: () => register(context),
            ),

            const SizedBox(height: 10),

            //register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already Registered? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login Now ",
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
