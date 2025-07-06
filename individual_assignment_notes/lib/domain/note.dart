import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String text;
  final DateTime createdAt;

  Note({required this.id, required this.text, required this.createdAt});

  factory Note.fromMap(String id, Map<String, dynamic> data) {
    return Note(
      id: id,
      text: data['text'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'createdAt': createdAt,
    };
  }
}
