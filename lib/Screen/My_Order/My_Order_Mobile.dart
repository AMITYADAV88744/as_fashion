
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../MainScreen/MainScreenPage.dart';
import '../MyShoppingCart/MyCartPage.dart';
import '../MyWishListPage.dart';
import 'MyOrderDetail.dart';

class MyOrderMobile extends StatelessWidget {
   MyOrderMobile({Key? key}) : super(key: key);

   final orderRef=FirebaseFirestore.instance.collection("Orders").doc(FirebaseAuth.instance.currentUser?.uid);

   @override
  Widget build(BuildContext context) {

    if (kDebugMode) {
      print("_______________MyOrderMobile______________");
    }

    return Scaffold(
        appBar: AppBar(
          leading:  IconButton(
            onPressed:(){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const MainScreenPage()
              ));
            },
            icon:  const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
          ),
          title: const Text('My Orders',
            style: TextStyle(
                color: Colors.black
            ),
          ),
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
                      Icons.favorite_outlined,
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
        body:StreamBuilder<QuerySnapshot>(
          stream:orderRef.collection(FirebaseAuth.instance.currentUser!.uid).snapshots() ,
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.connectionState==ConnectionState.active){

              if(snapshot.hasData){
                if(snapshot.data?.docs.isEmpty==true){
                  return const Center(
                    child: Text("You Order List is  Empty",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 25
                      ),
                    ),
                  );
                }else{
                  return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context,index){
                        var or_dtime=snapshot.data!.docs[index]["or_dtime"];
                        DateFormat format = DateFormat("hh:mm a").add_d().add_yMMM();


                        var or_status=snapshot.data!.docs[index]["or_status"];
                        var orderid=snapshot.data?.docs[index]["order_no"];
                        return GestureDetector(
                          onTap: (){

                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) =>  MyOrderDetail(orderid)));
                          },
                          child: Padding(padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey
                                  ),
                                  borderRadius: BorderRadius
                                      .circular(10)
                              ),
                              height: 170,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  snapshot.data!.docs[index]["image"].toString().isNotEmpty==true?
                                  Image.network(snapshot.data?.docs[index]["image"][0],
                                    height: 150,
                                    width: 110,
                                    fit: BoxFit.fill,
                                  ):const SizedBox(
                                    height: 150,
                                    width: 110,
                                  ),
                                  const Padding(padding: EdgeInsets.all(20)),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      Text(snapshot.data?.docs[index]["order_no"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 15
                                        ),
                                      ),
                                      const Padding(padding: EdgeInsets.only(top: 8)),
                                      const Text("Order Received",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                            fontSize: 12
                                        ),
                                      ),
                                      const Padding(padding: EdgeInsets.all(10)),
                                       Text(
                                           or_status=="Delivered" ?
                                           "Order has been Delivered " :
                                           "Expected by ${DateFormat("dd MMM yyyy").
                                           format(DateTime.parse(format.parse(or_dtime)
                                               .add(const Duration(days: 7))
                                               .toString()))}",
                                         style:const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                  );
                }
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
    );
  }
}
