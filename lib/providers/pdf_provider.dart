import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:open_filex/open_filex.dart';

class PDFFile {
  final String path;
  final String name;
  final DateTime date;
  final String size;

  PDFFile({
    required this.path,
    required this.name,
    required this.date,
    required this.size,
  });
}

class PDFProvider with ChangeNotifier {
  List<PDFFile> _savedFiles = [];
  List<PDFFile> get savedFiles => _savedFiles;

  Future<void> fetchSavedFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final pdfDir = Directory('${directory.path}/PDFMaster');
    
    if (await pdfDir.exists()) {
      final files = pdfDir.listSync();
      _savedFiles = files.whereType<File>().map((f) {
        final stat = f.statSync();
        return PDFFile(
          path: f.path,
          name: f.path.split('/').last,
          date: stat.modified,
          size: _formatBytes(stat.size),
        );
      }).toList();
      _savedFiles.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    }
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    var i = (bytes).toString().length ~/ 3;
    return '${(bytes / (1024 * i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  Future<void> createPDFFromImages(List<File> images, String fileName) async {
    final pdf = pw.Document();

    for (var image in images) {
      final imageBytes = await image.readAsBytes();
      final pwImage = pw.MemoryImage(imageBytes);
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(pwImage));
          },
        ),
      );
    }

    await _savePDF(pdf, fileName);
  }

  Future<void> createPDFFromText(String text, String title) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Header(level: 0, child: pw.Text(title, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold))),
          pw.Text(text),
        ],
      ),
    );

    await _savePDF(pdf, title);
  }

  Future<void> _savePDF(pw.Document pdf, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final pdfPath = '${directory.path}/PDFMaster';
    final dir = Directory(pdfPath);
    
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final file = File('$pdfPath/$fileName.pdf');
    await file.writeAsBytes(await pdf.save());
    await fetchSavedFiles();
  }

  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      await fetchSavedFiles();
    }
  }

  void shareFile(String path) {
    Share.shareXFiles([XFile(path)]);
  }

  void openFile(String path) {
    OpenFilex.open(path);
  }
}
