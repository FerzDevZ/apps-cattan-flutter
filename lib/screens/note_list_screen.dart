import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../providers/theme_provider.dart';
import 'note_edit_screen.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final List<Note> _notes = [];
  final List<Color> _noteColors = [
    const Color(0xFFFDFFB6),
    const Color(0xFFBFFCC6),
    const Color(0xFFFFD6FF),
    const Color(0xFFBFE9FF),
    const Color(0xFFFFB5E8),
    const Color(0xFFFFF3CD),
    const Color(0xFFD4EDDA),
    const Color(0xFFCCE5FF),
    const Color(0xFFF8D7DA),
    const Color(0xFFE2E3E5),
    const Color(0xFFE0F7FA),
    const Color(0xFFFFF8E1),
  ];

  final List<Color> _textColors = [
    Colors.black,
    Colors.blue[900]!,
    Colors.green[900]!,
    Colors.purple[900]!,
    Colors.red[900]!,
    Colors.brown[900]!,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140.0,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Catatan Saya',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.secondaryContainer,
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  context.watch<ThemeProvider>().isDarkMode
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  context.read<ThemeProvider>().toggleTheme();
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: _notes.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 100),
                            Icon(
                              Icons.note_add_rounded,
                              size: 100,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada catatan',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap + untuk membuat catatan baru',
                              style: GoogleFonts.poppins(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.85,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final note = _notes[index];
                        return FadeInUp(
                          delay: Duration(milliseconds: index * 50),
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) => _deleteNote(index),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Hapus',
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () => _editNote(note),
                              child: Card(
                                color: note.color,
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        note.title,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Expanded(
                                        child: Text(
                                          note.content,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        DateFormat('dd MMM yyyy HH:mm')
                                            .format(note.dateCreated),
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: _notes.length,
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewNote,
        icon: const Icon(Icons.add),
        label: Text(
          'Catatan Baru',
          style: GoogleFonts.poppins(),
        ),
      ),
    );
  }

  void _addNewNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditScreen(
          noteColors: _noteColors,
        ),
      ),
    );

    if (result != null && result is Note) {
      setState(() {
        _notes.insert(0, result);
      });
    }
  }

  void _editNote(Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditScreen(
          note: note,
          noteColors: _noteColors,
        ),
      ),
    );

    if (result != null && result is Note) {
      setState(() {
        final index = _notes.indexWhere((item) => item.id == note.id);
        if (index >= 0) {
          _notes[index] = result;
        }
      });
    }
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }
}
