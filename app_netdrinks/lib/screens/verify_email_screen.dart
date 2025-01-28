import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class VerifyEmailScreen extends StatefulWidget {
  final User user;

  const VerifyEmailScreen({super.key, required this.user});

  @override
  VerifyEmailScreenState createState() => VerifyEmailScreenState();
}

class VerifyEmailScreenState extends State<VerifyEmailScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startVerificationCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startVerificationCheck() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        if (user.emailVerified) {
          _navigateToHome();
          timer.cancel();
        }
      }
    });
  }

  void _navigateToHome() {
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          false, // Desabilita o gesto de voltar e o botão físico/virtual
      child: Scaffold(
        appBar: AppBar(
          title: Text(FlutterI18n.translate(context, 'verify.title')),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                FlutterI18n.translate(context, 'verify.email_sent',
                    translationParams: {'email': widget.user.email!}),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              Text(
                FlutterI18n.translate(context, 'verify.check_email'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () async {
                  await widget.user.sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(FlutterI18n.translate(context, 'verify.resent')),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Text(FlutterI18n.translate(context, 'verify.resend')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
