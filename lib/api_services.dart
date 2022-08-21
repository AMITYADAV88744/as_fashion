
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Screen/LoginPage/Verify_OTP.dart';
import 'Screen/My_Address/My_Address.dart';
import 'model/product_model.dart';
import 'package:firebase_database/firebase_database.dart';

class ApiService{

/// My  Address  change
  address_as_default(addressid,context){

    print("__________Address Api calling ____________");

    var change= FirebaseFirestore.instance.collection('Address').doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(FirebaseAuth.instance.currentUser!.uid);

    if (kDebugMode) {
      print(addressid);
    }
    change.doc(addressid).update({
      "primary":"true"
    }).whenComplete((){

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>  const My_Address()));
    });

  }


  getProductList(){
   final List<ProductModel> _productModel = [];

    final  dbRef = FirebaseDatabase.instance.reference().child('Products').child("Male").reference().get();

    dbRef.asStream().map((event) {

      Map<dynamic, dynamic> values = event.value;
      values.forEach((key, values) {
        _productModel.add(ProductModel.fromJson(values));
        print(_productModel.toList());
      });
    });
  }




}