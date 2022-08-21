
import 'package:as_fashion/Screen/ProductDetail/product_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'MainScreen/MainScreenPage.dart';


class MyWishListPage extends StatelessWidget {
  const MyWishListPage( {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return   const MyWishListMobile();
            } else if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
              return    const MyWishListMobile();
            } else {
              return   const MyWishListMobile();
            }
          },
        )
    );
  }
}


class MyWishListMobile extends StatefulWidget {
  const MyWishListMobile({
    Key? key,
  }) : super(key: key);

  @override
  State<MyWishListMobile> createState() => _MyWishListMobileState();
}
class _MyWishListMobileState extends State<MyWishListMobile> {

  @override
  void initState() {
    super.initState();
  }
  List<Map<dynamic, dynamic>> lists = [];

  var wishRef=FirebaseFirestore.instance.collection("WishList").doc(FirebaseAuth.instance.currentUser?.uid);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading:IconButton(
            onPressed:(){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const MainScreenPage()
              ));},
            icon:const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.grey,
            ),
          ),
          title: const Text("My WishList",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),
          ),
        ),
        body:Padding(
          padding: EdgeInsets.all(15),
          child: StreamBuilder<QuerySnapshot>(
              stream: wishRef.collection(FirebaseAuth.instance.currentUser!.uid).snapshots(),
              builder: (context, snapshot){
                if(snapshot.connectionState==ConnectionState.active){
                  if(snapshot.hasData){
                    if(snapshot.data?.docs.isEmpty ==true){
                      return  const Center(
                        child: Text("You Wishlist Empty",
                          style: TextStyle(
                              color: Colors.grey,
                            fontSize: 25
                          ),
                        ),
                      );
                    }else{
                      return  ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context,index){
                            var pid =snapshot.data?.docs[index]["pid"];
                            var image =snapshot.data?.docs[index]["image"];
                            var pname =snapshot.data?.docs[index]["pname"];
                            var brand =snapshot.data?.docs[index]["brand"];
                            var price =snapshot.data?.docs[index]["price"];

                            return Column(
                              children: [
                                Container(
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

                                      Image.network(image,
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
                                            ],
                                          )
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey
                                      ),
                                      borderRadius: BorderRadius
                                          .circular(1)
                                  ),
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Center(
                                        child:TextButton(
                                            onPressed:(){
                                              Navigator.pushReplacement(
                                                  context, MaterialPageRoute(builder: (context) =>  ProductDetails(pid)
                                              ));
                                            },
                                            child: const Text("Check Product",
                                              style: TextStyle(
                                                  fontSize: 20
                                              ),
                                            )
                                        ),
                                      ),
                                      const VerticalDivider(
                                        width: 2,
                                        thickness: 2,
                                      ),
                                      Center(
                                        child:TextButton(
                                          onPressed:(){
                                            var addWish=FirebaseFirestore.instance.collection("WishList")
                                                .doc(FirebaseAuth.instance.currentUser?.uid).collection(FirebaseAuth.instance.currentUser!.uid.toString());

                                            addWish.doc(snapshot.data?.docs[index]["pid"]).delete();

                                          },
                                          child: const Text(
                                            "Remove  item",
                                            style: TextStyle(
                                                fontSize: 20
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            );
                          }
                      );
                    }
                  }
                  else{
                   return const Center(
                      child: Text("List not available",
                        style: TextStyle(
                            color: Colors.black
                        ),
                      ),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator()
                );

              }
          ),
        )
    );
  }


}
