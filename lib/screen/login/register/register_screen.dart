import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlone/screen/widget/snack_bar_widget.dart';
import 'package:flutterlone/screen/widget/text_field_widget.dart';

class RegisterScreen extends StatefulWidget {

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _register() async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim()
      );
      showCustomSnackBar(
          context,
          'Register Successfully',
          Colors.green
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print('Error Register: ${e.message}');
      showCustomSnackBar(
          context,
          'Register Failed',
          Colors.red
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Register',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 30,),
            CustomTextField(
                labelText: 'Email',
                hintText: 'Enter Email',
                controller: _emailController,
            ),
            CustomTextField(
                labelText: 'Password',
                hintText: 'Enter Password',
                controller: _passwordController,
                isPassword: true,
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
                onPressed: _register,
                child: const Text('Register')
            )
          ],
        ),
      ),
    );
  }
}
