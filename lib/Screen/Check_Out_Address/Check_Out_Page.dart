
import 'dart:math';

import 'package:as_fashion/Screen/Check_Out_Address/Check_Out_Mobile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Check_Out_Desktop.dart';

class Check_Out_Page extends StatelessWidget {
   Check_Out_Page( this.pid,this.size,{Key? key}) : super(key: key);
   final String pid,size;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              print("----CheckoutMobile---");
              return    CheckOutMobile(pid,size);
            } else if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
              print("----CheckoutDesltop---");
              return     CheckOutDesktop(pid,size);
            } else {
              print("----CheckoutDesltop---");
              return    CheckOutDesktop(pid,size);
            }
          },
        )
    );
  }
}
