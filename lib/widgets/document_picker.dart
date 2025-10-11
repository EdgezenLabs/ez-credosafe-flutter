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
  List<String> _picked = [];
  List<File> _selectedFiles = [];

  Future<void> pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        List<String> fileNames = result.files.map((file) => file.name).toList();
        
        setState(() {
          _selectedFiles = files;
          _picked = fileNames;
        });
        
        // Call the callback with selected files
        widget.onFilesPicked(files);
      }
    } catch (e) {
      // Handle file picker errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking files: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void clearFiles() {
    setState(() {
      _selectedFiles.clear();
      _picked.clear();
    });
    widget.onFilesPicked([]);
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: pickFiles, 
              icon: const Icon(Icons.upload_file), 
              label: const Text('Upload documents')
            ),
            if (_picked.isNotEmpty) ...[
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: clearFiles,
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        if (_picked.isNotEmpty) ...[
          Text(
            '${_picked.length} file(s) selected:',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          ...List.generate(_picked.length, (index) {
            final fileName = _picked[index];
            final fileSize = _selectedFiles[index].lengthSync();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  const Icon(Icons.description, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      fileName,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    _formatFileSize(fileSize),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}
