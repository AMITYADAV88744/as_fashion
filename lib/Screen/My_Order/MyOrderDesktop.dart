
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../components/header.dart';

class MyOrderDesktop extends StatefulWidget {
  const MyOrderDesktop({Key? key}) : super(key: key);

  @override
  State<MyOrderDesktop> createState() => _MyOrderDesktopState();
}

class _MyOrderDesktopState extends State<MyOrderDesktop> {
  List<Map<dynamic, dynamic>> lists = [];


  var orderRef=FirebaseFirestore.instance.collection("Orders").doc(FirebaseAuth.instance.currentUser?.uid);
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("_______________MyOrderDesktop______________");
    }

    return Scaffold(
        body:SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: ListView(
            shrinkWrap: true,
           physics: const BouncingScrollPhysics(),
           // crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Header(),
              const Padding(padding: EdgeInsets.zero),
               const Padding(
                padding: EdgeInsets.fromLTRB(50,50,30,15),
                child:  Text("My Orders",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 37,
                      color: Colors.black
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(50,0,70,0),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width/5,
                child:  StreamBuilder<QuerySnapshot>(
                  stream:orderRef.collection(FirebaseAuth.instance.currentUser!.uid).snapshots() ,
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if(snapshot.connectionState==ConnectionState.active){

                      if(snapshot.hasData){
                        return ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context,index){
                              return GestureDetector(
                                child: Padding(padding: const EdgeInsets.all(15),
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
                                        snapshot.data!.docs[index]["image"].toString().isNotEmpty==true?
                                        Image.network(snapshot.data?.docs[index]["image"],
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
                                            const Text("Delevered by 27 Aug 2022 ",
                                              style:TextStyle(
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
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              )
            ],
          ),
        )
    );
  }
}
