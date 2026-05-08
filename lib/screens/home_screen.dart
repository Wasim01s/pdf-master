import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pdf_master/screens/image_to_pdf_screen.dart';
import 'package:pdf_master/screens/text_to_pdf_screen.dart';
import 'package:pdf_master/screens/saved_pdfs_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'title': 'Image to PDF',
        'desc': 'Convert gallery images',
        'icon': Icons.image_outlined,
        'color': Colors.blue,
        'screen': const ImageToPdfScreen(isCamera: false),
      },
      {
        'title': 'Camera to PDF',
        'desc': 'Scan with camera',
        'icon': Icons.camera_alt_outlined,
        'color': Colors.purple,
        'screen': const ImageToPdfScreen(isCamera: true),
      },
      {
        'title': 'Text to PDF',
        'desc': 'Convert text to PDF',
        'icon': Icons.text_snippet_outlined,
        'color': Colors.pink,
        'screen': const TextToPdfScreen(),
      },
      {
        'title': 'Saved PDFs',
        'desc': 'View your documents',
        'icon': Icons.folder_open_outlined,
        'color': Colors.amber,
        'screen': const SavedPdfsScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('PDF Engine', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
            Text('Create with precision.', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w500)),
          ],
        ),
        actions: [
          _buildAppBarAction(Icons.notifications_outlined),
          const SizedBox(width: 8),
          _buildAppBarAction(Icons.settings_outlined),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            AnimationLimiter(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: menuItems.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildMenuCard(context, item),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            _buildVaultStatus(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarAction(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Icon(icon, size: 20, color: Colors.white.withOpacity(0.6)),
    );
  }

  Widget _buildMenuCard(BuildContext context, Map<String, dynamic> item) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => item['screen'])),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF121214),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: (item['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(item['icon'], color: (item['color'] as Color), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['desc'],
                    style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chevron_right, color: Colors.white24, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaultStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'VAULT STATUS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.1)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.folder_outlined, color: Color(0xFF818CF8), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Encrypted Vault',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF818CF8)),
                        ),
                        Text(
                          'LOCAL STORAGE ONLY',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1, color: Colors.white.withOpacity(0.3)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.65,
                  minHeight: 6,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '1.3 GB of 2.0 GB virtual limit used',
                style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.white.withOpacity(0.4)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
