import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import '../services/user_role.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool loading = false;
  String? error;

  Future<void> _login() async {
    setState(() { loading = true; error = null; });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: pass.text,
      );
      await ensureUserRoleExists();
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message ?? 'خطأ تسجيل دخول');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _register() async {
    setState(() { loading = true; error = null; });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: pass.text,
      );
      await ensureUserRoleExists(forceMember: true);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message ?? 'خطأ تسجيل');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Admin Notify", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 18),
                TextField(controller: email, decoration: const InputDecoration(labelText: "الإيميل")),
                const SizedBox(height: 10),
                TextField(controller: pass, obscureText: true, decoration: const InputDecoration(labelText: "الرقم السري")),
                const SizedBox(height: 14),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(error!, style: const TextStyle(color: Colors.redAccent)),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: loading ? null : _login,
                        child: Text(loading ? "..." : "دخول"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: loading ? null : _register,
                        child: const Text("تسجيل"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}