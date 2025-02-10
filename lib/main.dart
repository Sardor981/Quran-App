import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:quran_app/core/common/injections.dart';
import 'package:quran_app/features/auth/presentation/login_screen.dart';
import 'package:quran_app/features/home/presentation/controller/provider/home_provider.dart';
import 'package:quran_app/features/home/presentation/screens/splash_screen.dart';
import 'package:quran_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initinjection();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userToken = prefs.getString("userToken");

  runApp(
      MyApp(startScreen: userToken != null ? SplashScreen() : LoginScreen()));
}

class MyApp extends StatelessWidget {
  final Widget startScreen;

  const MyApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => getIt<HomeProvider>(),
        )
      ],
      child: ScreenUtilInit(
        designSize: MediaQuery.of(context).size.width >= 600
            ? const Size(1280, 800)
            : const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: startScreen,
        ),
      ),
    );
  }
}
