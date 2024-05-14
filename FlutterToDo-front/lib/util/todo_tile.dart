// ignore_for_file: sort_child_properties_last, must_be_immutable, prefer_const_constructors, use_super_parameters, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoTile extends StatelessWidget {
  final String taskName;
  final bool completed;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;

  TodoTile(
      {Key? key,
      required this.taskName,
      required this.completed,
      required this.onChanged,
      required this.deleteFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          child: Row(
            children: [
              //Completed?
              Checkbox(
                value: completed,
                onChanged: onChanged,
                fillColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Color(0xFF24916d);
                  }
                  return Color(0xFF24916d);
                }),
              ),

              //Name
              Text(
                taskName,
                style: TextStyle(
                    fontFamily: GoogleFonts.hindSiliguri().fontFamily,
                    fontSize: 23,
                    color: Color.fromARGB(255, 19, 18, 31),
                    decoration: completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Color(0xFF23ecbb),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
