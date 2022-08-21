

import 'package:as_fashion/UiFake.dart' if (dart.library.html) 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/prefer_sdk/html.dart';

import 'Screen/BillingPage/ThankyouPage.dart';
class Webpayment extends StatelessWidget{
  final String? name;
  final String orderId;
//  final String? image;
  final int? price;
  const Webpayment({this.name,this.price,required this.orderId});
  @override
  Widget build(BuildContext context) {
    ui.platformViewRegistry.registerViewFactory("rzp-html",(int viewId) {
      IFrameElement element=IFrameElement();
       window.onMessage.forEach((element) {
        print('Event Received in callback: ${element.data}');
        if(element.data=='MODAL_CLOSED'){


          var orderRef= FirebaseFirestore.instance.collection("Orders").doc(FirebaseAuth.instance.currentUser!.uid);

          var deleteRef= FirebaseFirestore.instance.collection("ShoppingCart").doc(FirebaseAuth.instance.currentUser!.uid);
          var adminOrder= FirebaseFirestore.instance.collection("AdminOrders");
          orderRef.collection(FirebaseAuth.instance.currentUser!.uid).doc(orderId).delete().then((value) {
          }).whenComplete(() => {
            adminOrder.doc(orderId).delete().then((value) =>{
          //  Navigator.pop(context)
            })
          });

        }
        else if(element.data=='SUCCESS'){
          print('PAYMENT SUCCESSFULL!!!!!!!');
          //ThankYouPage();
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const ThankYouPage()));

        }

         // FirebaseFirestore.instance.collection('Products').doc('iphone12').update({'payment':"Done"});
      });

      element.src='assets/payments.html?name=$name&price=$price';
      element.style.border = 'none';
      
      return element;
    });
    return  Scaffold(
      body: Builder(builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            child:  HtmlElementView(viewType: 'rzp-html'),
          );
    }));
  }

}