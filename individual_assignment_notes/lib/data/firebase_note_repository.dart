import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/note.dart';
import '../domain/note_repository.dart';

class FirebaseNoteRepository implements NoteRepository {
  @override
  Future<List<Note>> fetchNotes(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => Note.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<void> addNote(String userId, String text) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notes')
        .add({
      'text': text,
      'createdAt': Timestamp.now(),
    });
  }

  @override
  Future<void> updateNote(String userId, String noteId, String text) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .update({'text': text});
  }

  @override
  Future<void> deleteNote(String userId, String noteId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }
}
