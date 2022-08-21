
import 'package:flutter/material.dart';

import 'LoginDesktop.dart';
import 'LoginMobile.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return   LoginMobile();
          } else if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
            return   LoginDesktop();
          } else {
            return   LoginDesktop();
          }
        },
      ),
    );
  }
}
