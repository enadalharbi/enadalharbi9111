import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> ensureUserRoleExists({bool forceMember = false}) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final ref = FirebaseFirestore.instance.collection('users').doc(uid);
  final doc = await ref.get();

  if (!doc.exists) {
    await ref.set({
      'role': forceMember ? 'member' : 'member',
      'createdAt': FieldValue.serverTimestamp(),
      'email': FirebaseAuth.instance.currentUser!.email,
    });
  }
}

Future<String> getMyRole() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  if (!doc.exists) return 'member';
  return (doc.data()?['role'] as String?) ?? 'member';
}