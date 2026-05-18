import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/note_provider.dart';
import '../widgets/note_card.dart';
import 'add_note_screen.dart';

const _blue   = Color(0xFF1D5FA6);
const _cardBg = Color(0xFFEBF4FF);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteProvider>().fetchNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 141, 228, 255),
      appBar: AppBar(
        backgroundColor: _blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<NoteProvider>().fetchNotes(),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: _blue))
          : RefreshIndicator(
              color: _blue,
              onRefresh: () async => provider.fetchNotes(),
              child: provider.notes.isEmpty
                  ? const Center(
                      child: Text('No notes yet.',
                          style: TextStyle(color: _blue, fontSize: 14)),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: provider.notes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final note = provider.notes[index];
                        return NoteCard(note: note);
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _blue,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddNoteScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}