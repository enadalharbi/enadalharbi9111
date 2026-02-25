import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberPanel extends StatelessWidget {
  const MemberPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .limit(50)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snap.data!.docs;

        if (docs.isEmpty) return const Center(child: Text("لا يوجد تنبيهات بعد"));

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final d = docs[i].data();
            return Card(
              child: ListTile(
                leading: const Icon(Icons.notifications_active),
                title: Text(d['title'] ?? ''),
                subtitle: Text(d['body'] ?? ''),
              ),
            );
          },
        );
      },
    );
  }
}