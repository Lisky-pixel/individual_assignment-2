import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/firebase_auth_repository.dart';
import 'data/firebase_note_repository.dart';
import 'domain/auth_repository.dart';
import 'domain/note_repository.dart';
import 'state/auth_cubit.dart';
import 'state/note_cubit.dart';
import 'presentation/auth_screen.dart';
import 'presentation/notes_screen.dart';

// Entry point for Notes App. Will be expanded with clean architecture (presentation, domain, data).
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with web options
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyACEKYZ5kUyDF0HrP7XZVy3mIi_5WFtZNE",
      authDomain: "fir-project-dec7e.firebaseapp.com",
      projectId: "fir-project-dec7e",
      storageBucket: "fir-project-dec7e.firebasestorage.app",
      messagingSenderId: "773117449860",
      appId: "1:773117449860:web:cd398dbed89eb53151d4d1",
      measurementId: "G-1F6K4FKTG9",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
            create: (_) => FirebaseAuthRepository()),
        RepositoryProvider<NoteRepository>(
            create: (_) => FirebaseNoteRepository()),
      ],
      child: BlocProvider<AuthCubit>(
        create: (context) =>
            AuthCubit(repository: context.read<AuthRepository>())
              ..checkAuthStatus(),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return BlocProvider<NoteCubit>(
                create: (context) => NoteCubit(
                  repository: context.read<NoteRepository>(),
                  userId: state.userId,
                )..fetchNotes(),
                child: MaterialApp(
                  title: 'Notes App',
                  theme: ThemeData(primarySwatch: Colors.blue),
                  home: const RootScreen(),
                ),
              );
            } else {
              return MaterialApp(
                title: 'Notes App',
                theme: ThemeData(primarySwatch: Colors.blue),
                home: const RootScreen(),
              );
            }
          },
        ),
      ),
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return NotesScreen(
            onLogout: () => context.read<AuthCubit>().signOut(),
          );
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}
