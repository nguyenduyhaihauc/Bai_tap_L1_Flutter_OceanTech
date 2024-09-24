import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData? frefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    required this.labelText,
    this.hintText = '',
    this.frefixIcon,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
            controller: controller,
            obscureText: isPassword, //An mat khau neu la Field mat khau
            keyboardType: keyboardType,
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: labelText, //Tieu de cua TextField
              hintText: hintText, //Goi y nhap
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: frefixIcon != null ? Icon(frefixIcon) : null, //Icon phia truoc
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0
                )
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),//Khoang cach noi dung ben trong vaf canh ngoai TextField
            ),
          ),
        SizedBox(height: 10,)
      ],
    );
  }
}
