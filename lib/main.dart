import 'package:flutter/material.dart';
import 'package:tool_upload_community/app_provider_register.dart';
import 'package:tool_upload_community/module/screen/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviderRegister(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
          )
        ),
        home: const MainScreen(),
      ),
    );
  }
}
