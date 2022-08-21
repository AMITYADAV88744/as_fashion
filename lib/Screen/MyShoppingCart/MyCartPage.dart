



import 'package:as_fashion/Screen/MainScreen/MainScreenPage.dart';
import 'package:as_fashion/Screen/ProductDetail/product_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../BillingPage/BillingPage.dart';
import 'MyShoppingCartDesktop.dart';



class MyCartPage extends StatelessWidget {
  const MyCartPage( {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("_______MyCart_________");
    }

    return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return    const MyShoppingCartMobile();
            } else if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
              return     const MyShoppingCartMobile();
            } else {
              return    const MyShoppingCartDesktop();
            }
          },
        )
    );
  }
}


class MyShoppingCartMobile extends StatefulWidget {
   const MyShoppingCartMobile({Key? key,}) : super(key: key);

   @override
   State<MyShoppingCartMobile> createState() => _MyShoppingCartMobileState();
}
class _MyShoppingCartMobileState extends State<MyShoppingCartMobile> {


  var totalpay=0;
  List<int> total=[];

  var cartRef=FirebaseFirestore.instance.collection("ShoppingCart").doc(FirebaseAuth.instance.currentUser?.uid);

  late int sum=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor:const Color.fromARGB(232,232,232,232),
        appBar: AppBar(
          elevation: 0,
          //backgroundColor: Colors.white,
          leading:IconButton(
            onPressed:(){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const MainScreenPage()
              ));},
            icon:const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
          ),
          title: const Text("My Shopping Cart",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),
          ),
        ),
        body:StreamBuilder<QuerySnapshot>(
            stream: cartRef.collection(FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (context, snapshot){
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
                  return Column(
                    children: [
                      Expanded(
                        child:ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context,index){
                            var pid =snapshot.data?.docs[index]["pid"];
                            List image =snapshot.data?.docs[index]["image"];
                            var pname =snapshot.data?.docs[index]["pname"];
                            var brand =snapshot.data?.docs[index]["brand"];
                            var price =snapshot.data?.docs[index]["price"];
                            var quan=snapshot.data?.docs[index]["quantity"];
                            var size =snapshot.data?.docs[index]["size"];
                            total.add(quan*price);
                            sum=total.reduce((value, element) => value+element);
                            if (kDebugMode) {
                              print(sum);
                            }
                            return InkWell(
                              onTap: (){
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) =>  ProductDetails(pid,"Product Detail")
                                ));                              },
                              child: Container(
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
                              ),
                            );
                          }
                      ),
                      ),
                     FutureBuilder(
                         future: Future.delayed(const Duration(seconds: 2)),
                         builder: (context,s){
                      return Container(
                          padding: const EdgeInsets.fromLTRB(25,5,10,5),
                          color: Colors.white70,
                          height: 50,
                          width: MediaQuery.of(context).size.width,
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
                }
              }
              return const Center(
                child: CircularProgressIndicator()
              );
            }
        ),

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
