import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterlone/screen/product/home_product_screen.dart';
import 'package:flutterlone/screen/product/register_screen.dart';
import 'package:flutterlone/screen/product/task_list_screen.dart';
import 'package:flutterlone/screen/widget/snack_bar_widget.dart';
import 'package:flutterlone/screen/widget/text_field_widget.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth  _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text
      );
      showCustomSnackBar(
          context,
          'Login Successfully !!!',
          Colors.green
      );
      //Chuyen huong nguoi dung den man hinh chinh khi dang nhap thanh cong
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => TaskListScreen())
      );
    } on FirebaseAuthException catch (e) {
      print('Error Login: ${e.message}');
      showCustomSnackBar(
          context,
          'Login Failed',
          Colors.red
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Login',
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
                  onPressed: _login,
                  child: const Text('Login')
              ),
              const SizedBox(height: 10,),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterScreen())
                    );
                  },
                  child: Text('Don\'t have an account? Register')
              )
            ],
          ),
      ),
    );
  }
}
