
import 'dart:math';

import 'package:as_fashion/Screen/ProductDetail/product_details.dart';
import 'package:as_fashion/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductGridView extends StatefulWidget {
  const ProductGridView({Key? key}) : super(key: key);

  @override
  State<ProductGridView> createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> {
  late final int index;
  bool isPressed=true;
  @override
  void initState() {
    super.initState();

    isPressed;
  }

  @override
  void dispose() {
    super.dispose();
  }


  List<ProductModel> get productModel => _productModel;
  List<ProductModel> _productModel = [];

  final DatabaseReference dbRef =
  FirebaseDatabase.instance.reference().child('Products').child("Male");

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height:double.maxFinite,
      child:FutureBuilder(
        future: dbRef.get(),
        builder: (context,AsyncSnapshot<DataSnapshot> snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }if(snapshot.hasData){


            Map<dynamic, dynamic> values = snapshot.data!.value;
            values.forEach((key, values) {
              _productModel.add(ProductModel.fromJson(values));

            });
            return AlignedGridView.count(
                controller: ScrollController(),
                //scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                itemCount:_productModel.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      var pid=productModel[index].pid;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  ProductDetails(pid)));
                      },
                    child: Card(
                      elevation: 1,
                      child: Padding(
                  padding: const EdgeInsets.all(1),
                      child: Column(
                        children: [
                          ListView(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height/4,
                                width: MediaQuery.of(context).size.width/2.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child:  Image.network(_productModel[index].image,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(2),
                                child: Stack(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:  [
                                              Text(productModel[index].brand,
                                                textAlign:TextAlign.left,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const Padding(padding: EdgeInsets.zero),
                                               Text(productModel[index].pname,
                                                textAlign:TextAlign.left,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                  fontSize: 10,
                                                ),
                                              ),
                                               Text(productModel[index].price.toString(),
                                                textAlign:TextAlign.left,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Padding(padding: EdgeInsets.zero),
                                      ],
                                    ),
                                    Positioned(
                                      //bottom: 5,
                                      right: 0,
                                      child: Column(
                                        children: [
                                          IconButton(
                                              onPressed:() {
                                                if(isPressed==true){
                                                  setState(() {
                                                  isPressed= false;
                                                  var  i= index;
                                                  _addto_wishList(i);
                                                  });
                                                }
                                                else{
                                                  setState(() {
                                                    isPressed= true;
                                                    var  i= index;
                                                    _removefrom_wishList(i);
                                                  });
                                                }},

                                              icon: (isPressed)? const Icon(
                                                Icons.favorite_border_sharp,
                                                size: 20,
                                                color: Colors.black,
                                              ):const Icon(
                                                Icons.favorite_outlined,
                                                size: 20,
                                                color: Colors.redAccent,
                                              )

                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ),
                    ),
                  );
                }
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );

  }
  _addto_wishList(int i){

    var addWish=FirebaseFirestore.instance.collection("WishList")
        .doc(FirebaseAuth.instance.currentUser?.uid).collection(FirebaseAuth.instance.currentUser!.uid.toString());

    addWish.doc(_productModel[index].pid).set({

      "pid":_productModel[index].pid,
      "image":_productModel[index].image,
      "pname":_productModel[index].pname,
      "brand":_productModel[index].brand,
      "price":_productModel[index].price
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully Added')));
    }).catchError((onError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(onError.toString())));
    });

  }

   _removefrom_wishList(int i) {
    var addWish=FirebaseFirestore.instance.collection("WishList")
        .doc(FirebaseAuth.instance.currentUser?.uid).collection(FirebaseAuth.instance.currentUser!.uid.toString());

    addWish.doc(_productModel[index].pid).delete();
  }

}

