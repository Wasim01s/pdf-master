import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf_master/providers/pdf_provider.dart';
import 'package:intl/intl.dart';

class SavedPdfsScreen extends StatefulWidget {
  const SavedPdfsScreen({super.key});

  @override
  State<SavedPdfsScreen> createState() => _SavedPdfsScreenState();
}

class _SavedPdfsScreenState extends State<SavedPdfsScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PDFProvider>().fetchSavedFiles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Library', style: TextStyle(letterSpacing: -0.5)),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: Colors.white.withOpacity(0.2))),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, size: 18, color: Colors.white.withOpacity(0.3)),
                hintText: 'Search documents by name...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Expanded(
            child: Consumer<PDFProvider>(
              builder: (context, provider, child) {
                final files = provider.savedFiles.where((f) => f.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
                
                if (files.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: files.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final file = files[index];
                    return _buildFileCard(context, provider, file);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Icon(Icons.inbox_outlined, size: 40, color: Colors.white.withOpacity(0.1)),
          ),
          const SizedBox(height: 24),
          const Text('Vault is Empty', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white)),
          const SizedBox(height: 8),
          Text(
            'Your generated documents will\nappear here once processed.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildFileCard(BuildContext context, PDFProvider provider, PDFFile file) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121214),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05), 
              borderRadius: BorderRadius.circular(14)
            ),
            child: const Icon(Icons.description_outlined, color: Color(0xFF6366F1), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(file.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      DateFormat('MMM dd, yyyy').format(file.date).toUpperCase(),
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1, color: Colors.white.withOpacity(0.2)),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 2, height: 2, decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(
                      file.size.toUpperCase(),
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1, color: Colors.white.withOpacity(0.2)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'open') provider.openFile(file.path);
              if (value == 'share') provider.shareFile(file.path);
              if (value == 'delete') provider.deleteFile(file.path);
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: const Color(0xFF1A1A1D),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'open', child: Text('Open Document')),
              const PopupMenuItem(value: 'share', child: Text('Share Access')),
              const PopupMenuItem(value: 'delete', child: Text('Purge File', style: TextStyle(color: Colors.redAccent))),
            ],
            icon: Icon(Icons.more_vert, color: Colors.white.withOpacity(0.2)),
          ),
        ],
      ),
    );
  }
}
