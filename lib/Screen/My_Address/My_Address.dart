
import 'package:flutter/material.dart';

import 'My_Address_Desktop.dart';
import 'My_Address_Mobile.dart';

class My_Address extends StatelessWidget {
  const My_Address( {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    print("_______________My_Address________________");

    return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return     MyAddressMobile();
            } else if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
              return      MyAddressMobile();
            } else {
              return     My_Address_Desktop();
            }
          },
        )
    );
  }
}
