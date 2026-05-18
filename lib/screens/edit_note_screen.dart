import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note_model.dart';
import '../providers/note_provider.dart';

const _blue = Color(0xFF1D5FA6);

class EditNoteScreen extends StatefulWidget {
  final NoteModel note;
  const EditNoteScreen({super.key, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController bodyController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    bodyController  = TextEditingController(text: widget.note.body);
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  InputDecoration _inputDec(String label) => InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: _blue.withOpacity(0.6), fontSize: 13),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: _blue.withOpacity(0.3)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: _blue),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _blue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: _blue),
              decoration: _inputDec('Book Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bodyController,
              style: const TextStyle(color: _blue),
              maxLines: 5,
              decoration: _inputDec('Review'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: const RoundedRectangleBorder(),
                elevation: 0,
              ),
              onPressed: () async {
                final updatedNote = NoteModel(
                  id: widget.note.id,
                  title: titleController.text,
                  body: bodyController.text,
                );
                await context.read<NoteProvider>().updateNote(
                      widget.note.id!,
                      updatedNote,
                    );
                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Update', style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}