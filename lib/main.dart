import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/rate_provider.dart';
import 'features/home/views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RateProvider()..fetchAllRates()),
      ],
      child: MaterialApp(
        title: 'CardCambio',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
          primaryColorLight: Color.fromARGB(255, 250, 243, 242),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'CardCambio'),
      ),
    );
  }
}