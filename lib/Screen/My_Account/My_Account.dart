
import 'package:flutter/material.dart';
import 'My_Account_Desktop.dart';
import 'My_Account_Mobile.dart';

class MyAccount extends StatelessWidget {
  const MyAccount( {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return     const MyAccountMobile();
            } else if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
              return      const MyAccountMobile();
            } else {
              return    const MyAccountDesktop();
            }
          },
        )
    );
  }
}
