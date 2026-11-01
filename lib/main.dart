import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/my_plant_provider.dart';
import 'providers/plant_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase Database
  await Supabase.initialize(
    url: 'https://mxyikufyxlubldtrddbt.supabase.co',
    publishableKey: 'sb_publishable_zpAf7607-RPzjESnUxWdOQ_SzFYPrlk',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlantProvider()),
        ChangeNotifierProvider(create: (_) => MyPlantProvider()),
      ],
      child: MaterialApp(
        title: 'PlantCare',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          textTheme: GoogleFonts.poppinsTextTheme(),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}