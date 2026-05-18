import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/api_services.dart';

class NoteProvider extends ChangeNotifier {

  final ApiService _apiService = ApiService();

  List<NoteModel> _notes = [];

  bool isLoading = false;

  List<NoteModel> get notes => _notes;

  Future<void> fetchNotes() async {

    isLoading = true;
    notifyListeners();

    try {
      _notes = await _apiService.fetchNotes();
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addNote(NoteModel note) async {
    try {
      final created = await _apiService.addNote(note);

      _notes.insert(0, created);

      notifyListeners();
    } catch (e) {
      debugPrint('Add note failed: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> updateNote(int id, NoteModel note) async {

    await _apiService.updateNote(id, note);

    final index = _notes.indexWhere((e) => e.id == id);

    _notes[index] = note;

    notifyListeners();
  }

  Future<void> deleteNote(int id) async {

    await _apiService.deleteNote(id);

    _notes.removeWhere((e) => e.id == id);

    notifyListeners();
  }
}