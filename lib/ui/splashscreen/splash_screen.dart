import 'package:flutter/material.dart';
import 'package:flutterbase/route/app_screens_name.dart';
import 'package:flutterbase/ui/login/controller/login_controller.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  LoginController userController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2)).then((value)  {
      userController.checkIfUserIsLoggedIn();
      if (userController.isUserLoggedIn.value) {
        Get.offAllNamed(AppScreensNames.main);
      } else {
        Get.offAllNamed(AppScreensNames.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "SYSSEPARAÇÃO",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white54,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
