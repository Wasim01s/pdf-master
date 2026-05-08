import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pdf_master/providers/pdf_provider.dart';
import 'package:pdf_master/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PDFProvider()),
      ],
      child: MaterialApp(
        title: 'PDF Engine',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF080808),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF6366F1),
            secondary: Color(0xFFEC4899),
            surface: Color(0xFF121214),
            onSurface: Colors.white,
            background: Color(0xFF080808),
          ),
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
          cardTheme: CardTheme(
            color: const Color(0xFF121214),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: Colors.white.withOpacity(0.05)),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0C0C0D),
            elevation: 0,
            centerTitle: false,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
