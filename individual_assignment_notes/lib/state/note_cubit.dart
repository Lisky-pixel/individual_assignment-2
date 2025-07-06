import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/note.dart';
import '../domain/note_repository.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final NoteRepository repository;
  final String userId;

  NoteCubit({required this.repository, required this.userId})
      : super(NoteInitial());

  Future<void> fetchNotes() async {
    emit(NoteLoading());
    try {
      final notes = await repository.fetchNotes(userId);
      if (notes.isEmpty) {
        emit(NoteEmpty());
      } else {
        emit(NoteLoaded(notes));
      }
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  Future<void> addNote(String text) async {
    try {
      await repository.addNote(userId, text);
      fetchNotes();
      emit(NoteActionSuccess('Note added successfully.'));
    } catch (e) {
      emit(NoteError('Failed to add note: $e'));
    }
  }

  Future<void> updateNote(String noteId, String text) async {
    try {
      await repository.updateNote(userId, noteId, text);
      fetchNotes();
      emit(NoteActionSuccess('Note updated successfully.'));
    } catch (e) {
      emit(NoteError('Failed to update note: $e'));
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await repository.deleteNote(userId, noteId);
      fetchNotes();
      emit(NoteActionSuccess('Note deleted successfully.'));
    } catch (e) {
      emit(NoteError('Failed to delete note: $e'));
    }
  }
}
