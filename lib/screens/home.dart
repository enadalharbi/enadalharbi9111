import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_role.dart';
import 'panels/admin_panel.dart';
import 'panels/member_panel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getMyRole(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final role = snap.data!;
        return Scaffold(
          appBar: AppBar(
            title: Text(role == 'admin' ? "لوحة الأدمن" : "التنبيهات"),
            actions: [
              IconButton(onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Placeholder()));
              }, icon: const Icon(Icons.logout)),
            ],
          ),
          body: role == 'admin' ? const AdminPanel() : const MemberPanel(),
        );
      },
    );
  }
}