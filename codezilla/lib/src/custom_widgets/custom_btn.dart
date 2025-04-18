import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final Function()? onTap;
  final Widget label;
  const CustomBtn({super.key, required this.label,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onTap, child: label);
  }
}
