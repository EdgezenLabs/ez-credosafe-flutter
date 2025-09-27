import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DocumentPicker extends StatefulWidget {
  final void Function(List<File>) onFilesPicked;
  const DocumentPicker({required this.onFilesPicked, super.key});

  @override
  State<DocumentPicker> createState() => _DocumentPickerState();
}

class _DocumentPickerState extends State<DocumentPicker> {
  List<PlatformFile> _picked = [];

  Future<void> pickFiles() async {
    final res = await FilePicker.platform.pickFiles(allowMultiple: true, withData: false);
    if (res != null) {
      setState(() => _picked = res.files);
      widget.onFilesPicked(res.files.map((f) => File(f.path!)).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(onPressed: pickFiles, icon: const Icon(Icons.upload_file), label: const Text('Upload documents')),
        const SizedBox(height: 8),
        if (_picked.isNotEmpty)
          ..._picked.map((p) => Text(p.name, style: const TextStyle(fontSize: 12))).toList()
      ],
    );
  }
}
