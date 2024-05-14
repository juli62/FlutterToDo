// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_super_parameters, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_application_1/util/my_button.dart';

class DialogueBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogueBox({
    Key? key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Color(0xFF23ecbb),
        content: Container(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Input Task",
                    filled: true,
                    fillColor: Colors.white38,
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 50,
                    ),
                    MyButton(text: "Cancel", onPressed: onCancel),
                    const SizedBox(
                      width: 8,
                    ),
                    MyButton(text: "Save", onPressed: onSave)
                  ],
                )
              ],
            )));
  }
}
