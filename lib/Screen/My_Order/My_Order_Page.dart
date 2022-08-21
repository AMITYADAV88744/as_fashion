
import 'package:as_fashion/Screen/My_Order/MyOrderDesktop.dart';
import 'package:flutter/material.dart';

import 'My_Order_Mobile.dart';

class MyOrderPage extends StatelessWidget {
  const MyOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("_______________My_Order_Page______________");

    return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return     MyOrderMobile();
            } else if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
              return      const MyOrderDesktop();
            } else {
              return     const MyOrderDesktop();
            }
          },
        )
    );
  }
}
