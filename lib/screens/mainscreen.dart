// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:myapp/splash_screen.dart';
// import 'package:myapp/login_screen.dart';
// import 'package:myapp/signup_screen.dart';
// import 'package:myapp/home_screen.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//    MyApp({super.key});

//   final GoRouter _router = GoRouter(
//     routes: [
//       GoRoute(
//         path: '/',
//         builder: (context, state) => const SplashScreen(),
//       ),
//       GoRoute(
//         path: '/signup',
//         builder: (context, state) => const SignUpScreen(),
//       ), GoRoute(
//         path: '/login',
//         builder: (context, state) => const LoginScreen(),
//       ),
//       GoRoute(
//         path: '/home',
//         builder: (context, state) => const HomeScreen(),
//       ),
//     ],
//   );

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       routerConfig: _router,
//     );
//   }
// }
