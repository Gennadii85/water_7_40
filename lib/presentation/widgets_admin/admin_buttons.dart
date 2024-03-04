import 'package:flutter/material.dart';

class AdminButtons extends StatelessWidget {
  final String text;
  final Function function;
  const AdminButtons({
    Key? key,
    required this.text,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => function(),
      style: TextButton.styleFrom(
        side: const BorderSide(),
      ),
      child: Text(text),
    );
  }
}
