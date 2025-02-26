import 'package:app_netdrinks/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class Menu extends StatelessWidget {
  final User user;

  const Menu({super.key, required this.user});

  void _confirmarExclusao(BuildContext context) {
    TextEditingController senhaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(FlutterI18n.translate(context, 'Confirmar a exclusão')),
        content: TextField(
          controller: senhaController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: FlutterI18n.translate(context, 'Digite sua senha'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(FlutterI18n.translate(context, 'Cancelar')),
          ),
          TextButton(
            onPressed: () async {
              String? erro =
                  await AuthService().excluiConta(senha: senhaController.text);

              if (!context.mounted) return;

              Navigator.pop(context);

              if (erro != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(erro)),
                );
              } else {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            child: Text(FlutterI18n.translate(context, 'Excluir')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.displayName ?? 'Usuário'),
            accountEmail: Text(user.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  user.photoURL != null ? NetworkImage(user.photoURL!) : null,
              child: user.photoURL == null
                  ? Icon(Icons.emoji_emotions_sharp,
                      size: 40) // Added icon when no photoURL
                  : null,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(FlutterI18n.translate(context, 'Home')),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite_border),
            title: Text(FlutterI18n.translate(context, 'Favoritos')),
            onTap: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(FlutterI18n.translate(context, 'Sair')),
            onTap: () async {
              await FirebaseAuth.instance.signOut();

              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text(FlutterI18n.translate(context, 'Excuir Conta')),
            onTap: () => _confirmarExclusao(context),
          ),
        ],
      ),
    );
  }
}
