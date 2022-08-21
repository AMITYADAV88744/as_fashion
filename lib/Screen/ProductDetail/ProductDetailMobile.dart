

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../model/product_model.dart';
import '../Check_Out_Address/Check_Out_Page.dart';
import '../LandingPage/LandingPage.dart';
import '../LoginPage/Login_Screen.dart';
import '../MyShoppingCart/MyCartPage.dart';
import '../MyWishListPage.dart';

class ProductDetailsMobile extends StatefulWidget {
  String pid;
  ProductDetailsMobile( this.pid, {Key? key}) : super(key: key);

  @override
  State<ProductDetailsMobile> createState(){
    return _ProductDetailsMobileState(this.pid);

  }
}

class _ProductDetailsMobileState extends State<ProductDetailsMobile> {
   String pid;

  _ProductDetailsMobileState(this.pid);

  final DatabaseReference dbRef =
  FirebaseDatabase.instance.reference().child('Products').child("Male");
  late List<String> sizes = ["S", "M", "L", "XL"];
  late String selectedSize="M";
  late  bool isSelected=false;


 late ProductModel _productModel;
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(pid);
      print("_______Product detail_________");
    }
    return Scaffold(

        backgroundColor:const Color.fromARGB(232,232,232,232),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading:IconButton(
            onPressed:(){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const LandingPage()
              ));
            },
            icon:const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: const Text('Product Detail',style: TextStyle(color: Colors.black),),
          actions: [
            Row(
              children: [
                IconButton(
                    onPressed:(){
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => const MyWishListPage()
                      ));
                    },
                    icon: const Icon(
                      Icons.favorite_border_sharp,
                      color: Colors.black,
                    )
                ),
                IconButton(
                    onPressed:(){
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => const MyCartPage()
                      ));
                    },
                    icon: const Icon(
                      Icons.shopping_bag_sharp,
                      color: Colors.black,
                    )
                ),
              ],
            )
          ],
        ),
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: FutureBuilder(
                future: dbRef.child(pid).get(),
                builder:(context ,AsyncSnapshot<DataSnapshot> snapshot){

                  if(snapshot.hasData){

                    _productModel=ProductModel.fromJson(snapshot.data!.value);

                     return ListView(
                         shrinkWrap: true,
                         physics: const ScrollPhysics(),
                        children: [
                          Container(
                            height: 400,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:  Image.network(_productModel.image,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(25),
                            color: Colors.white,
                            child:ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                 Text(_productModel.brand,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.all(5),),
                                  Text(_productModel.pname,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.all(5),),
                                Row(
                                  children:  [
                                    Text(_productModel.price.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(4),),
                                    const Text("499",
                                      style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(4),),
                                    const Text('40% OFF',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.green,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                                const Text('inclusive of all taxes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(2)),
                          Container(
                            height: 360,
                            padding: const EdgeInsets.all(25),
                            color: Colors.white,
                            child: ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                const Text('COLOUR OPTION',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                StatefulBuilder(builder: (context, StateSetter setstate){
                                  return Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Material(
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(3),
                                              onTap: (){
                                                setState(() {

                                                });

                                              },
                                              child:  Container(
                                                width: 40,
                                                height: 40,
                                                padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey),
                                                  shape: BoxShape.circle,
                                                  color: _productModel.color,
                                                ),
                                              )
                                            ),
                                          ),
                                        )
                                      ]
                                  );

                                }
                                ),
                                const Padding(padding: EdgeInsets.all(15)),
                                const Text('SELECT SIZE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.all(12)),
                                StatefulBuilder(builder: (context, StateSetter setstate){
                                  return Row(
                                    children: List.generate(
                                        sizes.length,
                                            (index) =>
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Material(
                                                child: InkWell(
                                                  borderRadius: BorderRadius.circular(3),
                                                  onTap: (){
                                                    setState(() {
                                                      selectedSize=sizes[index];
                                                      //print(selectedSize);
                                                    });

                                                  },
                                                  child: Ink(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                        color: selectedSize == sizes[index]
                                                            ? const Color(0xFF667EEA)
                                                            : const Color(0xFFF3F3F3),
                                                        borderRadius: BorderRadius.circular(3)),
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        sizes[index],
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .headline6
                                                            ?.copyWith(
                                                            color: selectedSize == sizes[index]
                                                                ? Colors.white
                                                                : Colors.black87),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                    ),
                                  );

                                }
                                ),
                                const Padding(
                                    padding: EdgeInsets.all(15)),
                                Row(
                                    children: [
                                      Container(
                                        width: 160,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors
                                                    .blueAccent),
                                            borderRadius: BorderRadius
                                                .circular(5)
                                        ),
                                        child: TextButton(
                                            style: TextButton
                                                .styleFrom(
                                              backgroundColor: Colors
                                                  .blueAccent,
                                              textStyle: const TextStyle(
                                                  color: Colors
                                                      .white),
                                            ),
                                            child: const Text(
                                              'ADD TO CART ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  fontSize: 18,
                                                  color: Colors
                                                      .white
                                              ),
                                            ),
                                            onPressed: () {
                                             addtocart(context,pid,selectedSize);
                                            }
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(
                                              left: 10)),
                                      Container(
                                        width: 140,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors
                                                    .black),
                                            borderRadius: BorderRadius
                                                .circular(5)
                                        ),
                                        child: TextButton(
                                            style: TextButton
                                                .styleFrom(
                                              backgroundColor: Colors
                                                  .white,
                                              textStyle: const TextStyle(
                                                  color: Colors
                                                      .black
                                              ),
                                            ),
                                            child: const Text(
                                              'BUY NOW',
                                              style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  fontSize: 18,
                                                  color: Colors
                                                      .black
                                              ),
                                            ),
                                            onPressed: () {
                                              checkaddress(
                                                  context, pid,selectedSize);
                                            }
                                        ),
                                      ),
                                    ]
                                ),
                              ],
                            ),
                          ),
                        ]
                    );
                  }
                  return const CircularProgressIndicator();
                },
              )
            )
        )
    );
  }


  void addtocart(context,_pid,selectedSize) {
    var size =selectedSize;
    var pid=_pid;
    var cartRef= FirebaseFirestore.instance.collection("ShoppingCart")
        .doc(FirebaseAuth.instance.currentUser?.uid.toString()).collection(FirebaseAuth.instance.currentUser!.uid);
    var quan=0;


    cartRef.doc(pid).get().then((docData) => {
      if (docData.exists) {
        quan=docData.get("quantity"),
        quan=quan+1,
        cartRef.doc(pid).update({"quantity":quan
        }),
        print("quantity update")

      } else {
        cartRef.doc(pid).set(
            {
              "pid":pid,
              "size":size,
              "quantity":1,
              "image":_productModel.image,
              "brand":_productModel.brand,
              "pname":_productModel.pname,
              "price":_productModel.price
              //"product_state":
            }).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Successfully Added')));
        }).catchError((onError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(onError.toString())));
        })
      }
    });

  }


  void checkaddress(context, _pid, selectedSize) {
    var size=selectedSize;
    var pid = _pid;
    if (kDebugMode) {
      print(size);
    }
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginScreen()));
    }else{
      print("_______Checkout Buy Now_________");

      Navigator.push(context, MaterialPageRoute(builder: (context)=> Check_Out_Page(pid,size))
      );
    }

  }


}

