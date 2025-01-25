import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashBoardScreen extends StatefulWidget {
  final User user;

  const DashBoardScreen({super.key, required this.user});

  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'User: ${widget.user.displayName}', // Exibindo o email do usuário
              style: TextStyle(fontSize: 20),
            ),
          ),
          if (widget.user.photoURL != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(widget.user.photoURL!),
              ),
            ),
        ], // Add other widgets here
      ),
    );
  }
}
