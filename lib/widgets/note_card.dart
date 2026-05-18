import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note_model.dart';
import '../providers/note_provider.dart';
import '../screens/edit_note_screen.dart';

class NoteCard extends StatelessWidget {

  final NoteModel note;

  const NoteCard({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.all(10),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
              note.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(note.body),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.end,

              children: [

                IconButton(
                  icon: const Icon(Icons.edit),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EditNoteScreen(note: note),
                      ),
                    );
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.delete),

                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);

                    await context
                        .read<NoteProvider>()
                        .deleteNote(note.id!);

                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Deleted successfully'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}