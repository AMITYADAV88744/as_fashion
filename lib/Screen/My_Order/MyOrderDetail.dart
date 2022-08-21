
import 'package:flutter/material.dart';

import 'MyOrderDetailMobile.dart';

class MyOrderDetail extends StatelessWidget {
  final String orderid;
  const MyOrderDetail(this.orderid, {Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    print("_______________My_Order_Detail______________");

    return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return     MyOrderDetailMobile(orderid);
            } else if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
              return       MyOrderDetailMobile(orderid);
            } else {
              return      MyOrderDetailMobile(orderid);
            }
          },
        )
    );
  }
}
