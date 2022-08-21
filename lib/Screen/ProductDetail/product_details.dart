
import 'package:flutter/material.dart';
import 'ProductDetailDesktop.dart';
import 'ProductDetailMobile.dart';



class ProductDetails extends StatelessWidget {
  String pid ,titles;
  ProductDetails(this.pid,this.titles, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              var _pid=pid;
              return   ProductDetailsMobile(_pid,titles);
            } else if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
              var _pid=pid;
              return    ProductDetailsMobile(_pid,titles);
            } else {
              var _pid=pid;

              return   ProductDetailsDesktop(_pid);
            }
          },
        )
    );
  }
}
