import 'package:flutter/material.dart';

class IdenticalPage extends StatelessWidget {
  const IdenticalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('страница идентификации роли в компании'),
        ),
      ),
    );
  }
}
