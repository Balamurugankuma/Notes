import 'package:flutter/material.dart';
import '../db/database.dart';
import '../models/note_model.dart';
import 'edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = DBHelper();
  List<Note> notes = [];

  Future<void> fetchNotes() async {
    notes = await db.getNotes();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  void _deleteNote(int id) async {
    await db.deleteNote(id);
    fetchNotes();
  }

  void _navigateToAddEdit([Note? note]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditNoteScreen(note: note)),
    );
    fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        backgroundColor: Colors.grey,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEdit(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.grey,
      ),
      body: notes.isEmpty
          ? const Center(
              child: Text(
              "Empty Notes",
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.black87),
                      onPressed: () => _deleteNote(note.id!),
                    ),
                    onTap: () => _navigateToAddEdit(note),
                  ),
                );
              },
            ),
    );
  }
}
