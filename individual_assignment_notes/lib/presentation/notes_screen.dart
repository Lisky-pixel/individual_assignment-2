import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../state/note_cubit.dart';
import '../domain/note.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key, required this.onLogout}) : super(key: key);
  final VoidCallback onLogout;

  void _showNoteDialog(BuildContext context, {Note? note}) {
    final controller = TextEditingController(text: note?.text ?? '');
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<NoteCubit>(),
        child: AlertDialog(
          title: Text(note == null ? 'Add Note' : 'Edit Note'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Enter your note'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  if (note == null) {
                    dialogContext.read<NoteCubit>().addNote(text);
                  } else {
                    dialogContext.read<NoteCubit>().updateNote(note.id, text);
                  }
                  Navigator.pop(dialogContext);
                }
              },
              child: Text(note == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<NoteCubit>(),
        child: AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                dialogContext.read<NoteCubit>().deleteNote(note.id);
                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (scaffoldContext) => Scaffold(
        appBar: AppBar(
          title: const Text('Your Notes'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: onLogout,
              tooltip: 'Logout',
            ),
          ],
        ),
        body: BlocConsumer<NoteCubit, NoteState>(
          listener: (context, state) {
            if (state is NoteError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message), backgroundColor: Colors.red),
              );
            } else if (state is NoteActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green),
              );
            }
          },
          builder: (context, state) {
            if (state is NoteLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NoteEmpty) {
              return const Center(
                child: Text(
                  'Nothing here yet—tap ➕ to add a note.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (state is NoteLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.notes.length,
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    child: ListTile(
                      title: Text(note.text),
                      subtitle: Text(
                        note.createdAt.toLocal().toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () =>
                                _showNoteDialog(scaffoldContext, note: note),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _confirmDelete(scaffoldContext, note),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is NoteError) {
              return Center(
                  child: Text(state.message,
                      style: const TextStyle(color: Colors.red)));
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showNoteDialog(scaffoldContext),
          child: const Icon(Icons.add),
          tooltip: 'Add Note',
        ),
      ),
    );
  }
}
