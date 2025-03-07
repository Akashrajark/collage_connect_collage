import 'package:collage_connect_collage/features/login/login_screen.dart';
import 'package:collage_connect_collage/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNnaXhtaXhnamhzcHVxYXZxanN1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTczMjk0MzAyOCwiZXhwIjoyMDQ4NTE5MDI4fQ._oP-wclMUlcBxULkChVCXpKnwdHwUo0yVwhbgtj8RIs',
      url: 'https://sgixmixgjhspuqavqjsu.supabase.co');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: Loginscreen(),
    );
  }
}
