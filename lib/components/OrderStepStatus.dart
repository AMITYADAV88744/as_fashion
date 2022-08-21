
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderStepStatus extends StatelessWidget {
  String orderid;

  OrderStepStatus( this.orderid, {Key? key}) : super(key: key);
   /// Order database
   final orderRef=FirebaseFirestore.instance.collection("Orders").doc(FirebaseAuth.instance.currentUser?.uid)
       .collection(FirebaseAuth.instance.currentUser!.uid);
   @override
  Widget build(BuildContext context) {
     print(orderid);
    return ConstrainedBox(
      constraints:  BoxConstraints(minHeight: 50),
      child: StreamBuilder(
        stream: orderRef.doc(orderid).snapshots(),
          builder: (context,AsyncSnapshot<DocumentSnapshot>snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.connectionState==ConnectionState.active){

            var or_dtime=snapshot.data!.get("or_dtime");
            DateFormat format = DateFormat("hh:mm a").add_d().add_yMMM();


            var or_status=snapshot.data!.get("or_status");
            return Container(

              width: MediaQuery.of(context).size.width/1.5,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TimelineTile(
                    alignment: TimelineAlign.start,
                    isFirst: true,
                    indicatorStyle: IndicatorStyle(
                      width: 10,
                      height: 15,
                      padding: const EdgeInsets.all(8),
                      indicator:Container(
                        width: 5,
                        height: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                      ),
                    ),

                    afterLineStyle: const LineStyle(
                      color: Colors.green,
                    ),
                    endChild:  _Child(
                      text: "Order Placed",
                      text2: "Your order has been placed",
                      text3: or_dtime.toString(),
                    ),
                  ),

                  TimelineTile(
                    alignment: TimelineAlign.start,
                    hasIndicator: true,
                    indicatorStyle: IndicatorStyle(
                      width: 10,
                      height: 10,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      drawGap: true,
                      indicator:Container(
                        width: 5,
                        height: 100,
                        decoration:  BoxDecoration(
                          shape: BoxShape.circle,
                          color: or_status=="Confirmed"||or_status=="Shipped"||or_status=="Processing"||or_status=="Delivered"? Colors.green:Colors.grey,
                        ),
                      ),
                    ),
                    beforeLineStyle:  LineStyle(
                      color: or_status=="Confirmed"||or_status=="Shipped"||or_status=="Processing"||or_status=="Delivered"?Colors.green:Colors.grey,

                    ),
                    afterLineStyle:  LineStyle(
                      color: or_status=="Processing"||or_status=="Shipped"||or_status=="Processing"||or_status=="Delivered"
                          ? Colors.green:Colors.grey,
                    ),
                    endChild:  _Child(
                      text: 'Order Confirmed',
                      text2: or_status=="Confirmed"||or_status=="Shipped"||or_status=="Processing"||or_status=="Delivered"?
                      "You order has been confirmed":
                      "Expected by ${DateFormat("dd MMM yyyy").format(DateTime.parse(format.parse(or_dtime).add(Duration(days: 1)).toString()))}",
                      text3: "",
                    ),
                  ),

                  TimelineTile(
                    alignment: TimelineAlign.start,
                    indicatorStyle: IndicatorStyle(
                      width: 10,
                      height: 10,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      drawGap: true,
                      indicator:Container(
                        width: 5,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: or_status=="Shipped" ||or_status=="Delivered"?Colors.green:Colors.grey,
                          ),
                          shape: BoxShape.circle,
                          color:or_status=="Shipped" ||or_status=="Delivered"?Colors.green:Colors.grey,
                        ),
                      ),
                    ),
                    beforeLineStyle:  LineStyle(
                      color: or_status=="Shipped"||or_status=="Delivered"?Colors.green:Colors.grey,

                    ),
                    afterLineStyle:  LineStyle(
                      color: or_status=="Shipped" ||or_status=="Delivered"? Colors.green:Colors.grey,
                    ),
                    endChild:  _Child(
                      text: 'Order Shipped',
                      text2: or_status=="Shipped" ||or_status=="Delivered"?
                      "Order has been shipped " :
                      "Expected by ${DateFormat("dd MMM yyyy").format(DateTime.parse(format.parse(or_dtime).add(Duration(days: 4)).toString()))}",
                      text3: "",
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.start,
                    isLast: true,
                    indicatorStyle: IndicatorStyle(
                      width: 10,
                      height: 10,
                      padding: const EdgeInsets.all(8),
                      indicator:Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: or_status=="Delivered" ?Colors.green:Colors.grey
                          ),
                          color: or_status=="Delivered" ?Colors.green:Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    beforeLineStyle:  LineStyle(
                      color:or_status=="Delivered"?Colors.green:Colors.grey,
                    ),
                    endChild:  _Child(
                      text: 'Order Delivered',
                      text2: or_status=="Delivered" ?
                      "Order has been Delivered " :
                      "Expected by ${DateFormat("dd MMM yyyy").format(DateTime.parse(format.parse(or_dtime).add(Duration(days: 7)).toString()))}",
                      text3: "",
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator(),);
        }
        ),
      );
  }
}
class _Child extends StatelessWidget {
  const _Child({
    Key? key,
    required this.text,
    required this.text2,
    required this.text3

  }) : super(key: key);

  final String text,text2,text3;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minHeight: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.black
            ),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Text(
            text2,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 10,
                color: Colors.black
            ),
          ),
          Text(
            text3,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 10,
                color: Colors.black
            ),
          ),
        ]
      ),
    );
  }
}