import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/note.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? note;
  final List<Color> noteColors;

  const NoteEditScreen({
    super.key,
    this.note,
    required this.noteColors,
  });

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isEdited = false;
  late Color _selectedColor;
  late Color _selectedTextColor;
  double _fontSize = 16.0;
  String _selectedFont = 'Poppins';

  final List<String> _fontFamilies = [
    'Poppins',
    'Roboto',
    'Lato',
    'Montserrat',
    'OpenSans',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _selectedColor = widget.note?.color ?? widget.noteColors.first;
    _selectedTextColor = Colors.black;

    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note == null ? 'Catatan Baru' : 'Edit Catatan',
          style: GoogleFonts.getFont(_selectedFont),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_size),
            onPressed: _showFontSizeDialog,
          ),
          IconButton(
            icon: const Icon(Icons.font_download),
            onPressed: _showFontFamilyDialog,
          ),
          if (_isEdited)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveNote,
            ),
        ],
      ),
      body: Column(
        children: [
          _buildColorPicker(),
          _buildTextColorPicker(),
          Expanded(
            child: Container(
              color: _selectedColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      style: GoogleFonts.getFont(
                        _selectedFont,
                        fontSize: _fontSize + 4,
                        color: _selectedTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Judul',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: _selectedTextColor.withOpacity(0.6)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: TextField(
                        controller: _contentController,
                        style: GoogleFonts.getFont(
                          _selectedFont,
                          fontSize: _fontSize,
                          color: _selectedTextColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Tulis catatan di sini...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: _selectedTextColor.withOpacity(0.6)),
                        ),
                        maxLines: null,
                        expands: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.noteColors.length,
        itemBuilder: (context, index) {
          final color = widget.noteColors[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => setState(() {
                _selectedColor = color;
                _isEdited = true;
              }),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedColor == color
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextColorPicker() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.noteColors.length,
        itemBuilder: (context, index) {
          final color = widget.noteColors[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => setState(() {
                _selectedTextColor = color;
                _isEdited = true;
              }),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedTextColor == color
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ukuran Font'),
        content: StatefulBuilder(
          builder: (context, setState) => Slider(
            value: _fontSize,
            min: 12,
            max: 24,
            divisions: 12,
            label: _fontSize.round().toString(),
            onChanged: (value) {
              setState(() => _fontSize = value);
              this.setState(() => _isEdited = true);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showFontFamilyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pilih Font'),
        content: SingleChildScrollView(
          child: Column(
            children: _fontFamilies
                .map(
                  (font) => ListTile(
                    title: Text(
                      'Contoh Font',
                      style: GoogleFonts.getFont(font),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedFont = font;
                        _isEdited = true;
                      });
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  void _onTextChanged() {
    setState(() {
      _isEdited = true;
    });
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Judul tidak boleh kosong',
            style: GoogleFonts.getFont(_selectedFont),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final note = Note(
      id: widget.note?.id ?? DateTime.now().toString(),
      title: title,
      content: content,
      dateCreated: widget.note?.dateCreated ?? DateTime.now(),
      color: _selectedColor,
    );

    Navigator.pop(context, note);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
