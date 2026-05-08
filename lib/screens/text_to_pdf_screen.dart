import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf_master/providers/pdf_provider.dart';

class TextToPdfScreen extends StatefulWidget {
  const TextToPdfScreen({super.key});

  @override
  State<TextToPdfScreen> createState() => _TextToPdfScreenState();
}

class _TextToPdfScreenState extends State<TextToPdfScreen> {
  final _textController = TextEditingController();
  final _titleController = TextEditingController(text: 'New Document');
  bool _isConverting = false;

  Future<void> _convert() async {
    if (_textController.text.isEmpty) return;
    
    setState(() => _isConverting = true);
    try {
      await context.read<PDFProvider>().createPDFFromText(
        _textController.text,
        _titleController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF generated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isConverting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Writer', style: TextStyle(letterSpacing: -0.5)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121214),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DOCUMENT SUBJECT',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white.withOpacity(0.3)),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _titleController,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Draft-01',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.05),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121214),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MANUSCRIPT CONTENT',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white.withOpacity(0.3)),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _textController,
                          maxLines: 15,
                          style: TextStyle(color: Colors.white.withOpacity(0.7), height: 1.6),
                          decoration: InputDecoration(
                            hintText: 'Start drafting your manuscript here...',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.05),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.all(20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildGenerateButton(),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
     return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0C0D),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Container(
        height: 64,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: (_textController.text.isEmpty || _isConverting) 
            ? null 
            : const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF4F46E5)]),
          color: (_textController.text.isEmpty || _isConverting) ? Colors.white.withOpacity(0.05) : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: (_textController.text.isEmpty || _isConverting) 
            ? null 
            : [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: ElevatedButton(
          onPressed: _isConverting ? null : _convert,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: _isConverting
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description_outlined, size: 20),
                    const SizedBox(width: 12),
                    Text('Compile PDF Document', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  ],
                ),
        ),
      ),
    );
  }
}
