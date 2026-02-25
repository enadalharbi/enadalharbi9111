import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final title = TextEditingController(text: "تنبيه");
  final body = TextEditingController(text: "اكتب رسالة التنبيه هنا...");

  Future<void> send() async {
    final t = title.text.trim();
    final b = body.text.trim();
    if (t.isEmpty || b.isEmpty) return;

    await FirebaseFirestore.instance.collection('notifications').add({
      'title': t,
      'body': b,
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم إرسال التنبيه")));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(controller: title, decoration: const InputDecoration(labelText: "العنوان")),
          const SizedBox(height: 10),
          TextField(
            controller: body,
            maxLines: 4,
            decoration: const InputDecoration(labelText: "المحتوى"),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: send, child: const Text("إرسال")),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const Align(alignment: Alignment.centerLeft, child: Text("آخر التنبيهات", style: TextStyle(fontSize: 16))),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .orderBy('createdAt', descending: true)
                  .limit(30)
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snap.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final d = docs[i].data();
                    return Card(
                      child: ListTile(
                        title: Text(d['title'] ?? ''),
                        subtitle: Text(d['body'] ?? ''),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}