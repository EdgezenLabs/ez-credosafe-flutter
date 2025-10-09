import 'dart:io';
import 'package:flutter/material.dart';

class DocumentPicker extends StatefulWidget {
  final void Function(List<File>) onFilesPicked;
  const DocumentPicker({required this.onFilesPicked, super.key});

  @override
  State<DocumentPicker> createState() => _DocumentPickerState();
}

class _DocumentPickerState extends State<DocumentPicker> {
  List<String> _picked = [];

  Future<void> pickFiles() async {
    // File picker functionality will be implemented later
    // TODO: Implement file picker functionality
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: pickFiles, 
          icon: const Icon(Icons.upload_file), 
          label: const Text('Upload documents')
        ),
        const SizedBox(height: 8),
        if (_picked.isNotEmpty)
          ..._picked.map((p) => Text(p, style: const TextStyle(fontSize: 12))).toList()
      ],
    );
  }
}
