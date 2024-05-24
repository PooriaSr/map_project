import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:map_project/controller/map_screen_controller.dart';
import 'package:map_project/view/map_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  MapScreenController mapScreenController = MapScreenController();

  @override
  Widget build(BuildContext context) {
    mapScreenController.determinePosition();
    Future.delayed(const Duration(seconds: 5)).then((value) =>
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MapScreen())));

    return const Scaffold(
      body: Center(
        child: SpinKitCircle(
          color: Color.fromARGB(255, 65, 193, 69),
        ),
      ),
    );
  }
}
