
import 'package:as_fashion/components/Footer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../components/header.dart';
import '../BillingPage/BillingPage.dart';

class MyShoppingCartDesktop extends StatefulWidget {
  const MyShoppingCartDesktop({Key? key}) : super(key: key);

  @override
  State<MyShoppingCartDesktop> createState() => _MyShoppingCartDesktopState();
}

class _MyShoppingCartDesktopState extends State<MyShoppingCartDesktop> {

  var cartRef=FirebaseFirestore.instance.collection("ShoppingCart").doc(FirebaseAuth.instance.currentUser?.uid);
  List<int> total=[];
  int sum=0,price=0,discount=0;

  int l_price=0;

  double defaulttext=15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Header(),
              const Padding(padding: EdgeInsets.zero),

              StreamBuilder<QuerySnapshot>(
                  stream: cartRef.collection(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                  builder: (context, snapshot) {
                  if(snapshot.connectionState==ConnectionState.active){
                    if(snapshot.data?.docs.isEmpty==true){
                      return const Center(
                        child: Text("You Cart is  Empty",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 25
                          ),
                        ),
                      );
                    }
                    else{
                      total.clear();

                      return Container(
                        padding: const EdgeInsets.fromLTRB(200, 10, 120, 0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:  [
                            Expanded( //<-- Expanded widget
                              flex: 6,
                              child: Padding(
                                padding: EdgeInsets.all(35),
                                child: ListView.builder(
                                    itemCount: snapshot.data?.docs.length,
                                    itemBuilder: (context,index){
                                      var pid =snapshot.data?.docs[index]["pid"];
                                      var image =snapshot.data?.docs[index]["image"];
                                      var pname =snapshot.data?.docs[index]["pname"];
                                      var brand =snapshot.data?.docs[index]["brand"];
                                      price =snapshot.data?.docs[index]["price"];
                                     // l_price =snapshot.data?.docs[index]["l_price"];

                                      var quan=snapshot.data?.docs[index]["quantity"];
                                      var size =snapshot.data?.docs[index]["size"];
                                      //print(pid);
                                       total.add(quan*price);
                                       sum=total.reduce((value, element) => value+element);
                                      if (kDebugMode) {
                                         print(sum);
                                      }
                                      return Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey
                                            ),
                                            borderRadius: BorderRadius
                                                .circular(1)
                                        ),
                                        height: 170,
                                        width: MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.all(20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:  [

                                            Image.network(image[0],
                                              height: 100,
                                              width: 90,
                                              fit: BoxFit.fill,
                                            ),
                                            const Padding(padding: EdgeInsets.all(10)),
                                            Column(
                                              // mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children:  [
                                                Text(pname,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 15
                                                  ),
                                                ),
                                                const Padding(padding: EdgeInsets.only(top: 8)),
                                                Text(brand,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey,
                                                      fontSize: 12
                                                  ),
                                                ),
                                                const Padding(padding: EdgeInsets.all(10)),
                                                Text("Size : $size",
                                                  style:const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey
                                                  ),
                                                ),
                                                const Padding(padding: EdgeInsets.only(top: 8)),
                                                Row(
                                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children:  [
                                                    Text("Price : $price",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey
                                                      ),
                                                    ),
                                                    const Padding(padding: EdgeInsets.only(left: 25)),
                                                    const Text("Quan: ",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey
                                                      ),
                                                    ),
                                                    _decrementButton(index,quan,pid),
                                                    Text(
                                                      '$quan',
                                                      style: const TextStyle(fontSize: 12.0),
                                                    ),
                                                    _incrementButton(index,quan,pid),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                ),
                              )
                            ),
                            Expanded( //<-- Expanded widget
                              flex: 4,
                              child:Padding(
                                padding: const EdgeInsets.fromLTRB(35,35,35,5),
                                child: FutureBuilder(
                                    future: Future.delayed(const Duration(seconds: 2)),
                                    builder: (context, snapshot) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:CrossAxisAlignment.start ,
                                      children: [

                                        Container(
                                          height: 100,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey
                                              ),
                                              borderRadius: BorderRadius
                                                  .circular(1)
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(20),
                                            child: Text(""
                                                "Whistles! Get extra 20% Cashback on prepaid orders above Rs.499."
                                                " Coupon code - NEW20. Applicable for new customers only!",
                                              maxLines: 4,
                                              style: TextStyle(
                                                  color: Colors.black54
                                              ),
                                            ),
                                          )
                                        ),
                                        const Padding(padding:EdgeInsets.all(2)),
                                        ///Price Summaryy
                                        Container(
                                          height: 230,
                                          width: MediaQuery.of(context).size.width,

                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey
                                              ),
                                              borderRadius: BorderRadius
                                                  .circular(1)
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.fromLTRB(25,5,0,5),
                                                color: Colors.grey,
                                                height: 35,
                                                width: MediaQuery.of(context).size.width,
                                                child: const Text("PRICE SUMMARY",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 15
                                                  ),
                                                ),
                                              ),
                                              const Padding(padding: EdgeInsets.only(top: 26)),
                                              Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children:  [
                                                        const Text("Total MRP (Incl. of taxes)",
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text(sum.toString(),
                                                          style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Padding(padding: EdgeInsets.only(top: 20)),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: const [
                                                        Text("Delivery Charges",
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text("Free",
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Padding(padding: EdgeInsets.only(top: 20)),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children:  [
                                                        const Text("Discount",
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text("0",
                                                          style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Padding(padding: EdgeInsets.only(top: 20)),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children:  [
                                                        const Text("Subtotal",
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text(sum.toString(),
                                                          style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],

                                          ),
                                        ),
                                        FutureBuilder(
                                            future: Future.delayed(const Duration(seconds: 2)),
                                            builder: (context,s){
                                              return Container(
                                                  padding: const EdgeInsets.fromLTRB(25,5,10,5),
                                                  height: 50,
                                                  width: MediaQuery.of(context).size.width,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey
                                                      ),
                                                      borderRadius: BorderRadius
                                                          .circular(1)
                                                  ),
                                                  child:Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children:  [
                                                      Text("Total: $sum",
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                            fontSize: 22
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            fixedSize: const Size(160, 45)
                                                        ),
                                                        onPressed:(){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  BillingPage(sum)));
                                                        },
                                                        child: const Text("Proceed",
                                                          style: TextStyle(
                                                              fontSize: 22,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold

                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              );
                                            }
                                        )
                                      ],
                                    );
                                  }),
                                )
                              ),
                          ],
                        ),
                      );
                    }
                  }else{
                    return const Center(child: CircularProgressIndicator(),);
                  }

              }),
              const Footer()
            ],
          ),
        )
    );
  }


  /// Increment in quantity

  Widget _incrementButton(int index,quan,pid) {
    return StatefulBuilder(builder: (context,StateSetter setstate){
      return InkWell(
        child: const Icon(
          Icons.add,
          color: Colors.black87,

        ),

        onTap: () {
          var doc = FirebaseFirestore.instance.collection('ShoppingCart')
              .doc(FirebaseAuth.instance.currentUser!.uid).collection(FirebaseAuth.instance.currentUser!.uid).doc(pid);

          doc.get().then((value) => {
            quan=quan+1,
            doc.update({"quantity":quan
            }),
            print(quan),
          });
        },
      );

    });
  }


  /// Decrement in quantity
  Widget _decrementButton(int index,quan,pid) {
    return StatefulBuilder(builder: (context,StateSetter setstate){
      return InkWell(
        child: const Icon(
          Icons.remove, color: Colors.black87,
        ),

        onTap: () {
          var doc = FirebaseFirestore.instance.collection('ShoppingCart')
              .doc(FirebaseAuth.instance.currentUser!.uid).collection(FirebaseAuth.instance.currentUser!.uid).doc(pid);

          doc.get().then((value) => {
            quan=quan-1,
            if(quan==0){
              doc.delete()
            }else{
              doc.update({"quantity":quan
              }),
              print(quan),
            }
          });
        },
      );

    });
  }
}
