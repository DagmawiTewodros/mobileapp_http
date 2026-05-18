import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/note_model.dart';
import '../utils/constants.dart';

class ApiService {

  Future<List<NoteModel>> fetchNotes() async {
    final response = await http.get(
      Uri.parse(AppConstants.baseUrl),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List notes = data['posts'];

      return notes.map((e) => NoteModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<NoteModel> addNote(NoteModel note) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(note.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return NoteModel.fromJson(data);
    } else {
      throw Exception('Failed to add note. Status: ${response.statusCode}. Response: ${response.body}');
    }
  }

  Future<void> updateNote(int id, NoteModel note) async {
    final response = await http.put(
      Uri.parse('${AppConstants.baseUrl}/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(note.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update note');
    }
  }

  Future<void> deleteNote(int id) async {
    final response = await http.delete(
      Uri.parse('${AppConstants.baseUrl}/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete note');
    }
  }
}