import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/data_layer/models/route/route_details.dart';
import 'package:task_manager/presentation_layer/home/home_screen.dart';
import 'package:task_manager/service_layer/services_setup.dart';

///Initial app screen
class SplashScreen extends StatefulWidget {
  ///[SplashScreen] default constructor
  const SplashScreen({super.key});

  ///[SplashScreen] route
  static final RouteDetails route =
      RouteDetails('splashScreen', '/splashScreen');

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _navigateToHome() async {
    Timer(
      const Duration(seconds: 2),
      () => navigationService.pushReplacementScreen(HomeScreen.route),
    );
  }

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeService.state.primaryColor,
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: Text(
              'Task Manager',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeService.state.primaryTextColor,
                fontSize: 30.sp,
              ),
            ),
          ),
          const Spacer(),
          Text(
            '© 2024 Task Manager App. All rights reserved',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: themeService.state.primaryTextColor.withOpacity(0.67),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}
