import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/core/common/injections.dart';
import 'package:quran_app/features/home/presentation/controller/provider/home_provider.dart';
import 'package:quran_app/features/home/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initinjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            ? Size(1280, 800)
            : Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false, home: SplashScreen(),
          //const DrawerScreen(),
        ),
      ),
    );
  }
}
