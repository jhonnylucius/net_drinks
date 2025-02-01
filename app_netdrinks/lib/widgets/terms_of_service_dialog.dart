import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsOfServiceDialog extends StatelessWidget {
  final VoidCallback onAccepted;
  final VoidCallback onDeclined;

  const TermsOfServiceDialog({
    super.key,
    required this.onAccepted,
    required this.onDeclined,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Termos de Serviço'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
                'Por favor, leia e aceite os termos de serviço para continuar.'),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () =>
                  _launchURL('https://union.dev.br/termosNetDrink.html'),
              child: Text(
                'Leia os Termos de Serviço',
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Aceitar'),
          onPressed: () {
            Navigator.of(context).pop(); // Fechar o diálogo
            onAccepted();
          },
        ),
        TextButton(
          child: Text('Recusar'),
          onPressed: () {
            Navigator.of(context).pop(); // Fechar o diálogo
            onDeclined();
          },
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
