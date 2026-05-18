import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note_model.dart';
import '../providers/note_provider.dart';

const _blue   = Color(0xFF1D5FA6);

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final bodyController  = TextEditingController();
  bool _isSaving = false;

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
        title: const Text('Add Book Note'),
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
              onPressed: _isSaving ? null : () async {
                if (titleController.text.isEmpty || bodyController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                setState(() => _isSaving = true);

                try {
                  final note = NoteModel(
                    title: titleController.text,
                    body: bodyController.text,
                  );
                  await context.read<NoteProvider>().addNote(note);
                  if (!mounted) return;
                  Navigator.pop(context);
                } catch (e) {
                  if (!mounted) return;
                  setState(() => _isSaving = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Save', style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}