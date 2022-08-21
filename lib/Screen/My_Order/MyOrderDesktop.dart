
import 'package:as_fashion/components/Footer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import '../../components/header.dart';

class MyOrderDesktop extends StatefulWidget {
  const MyOrderDesktop({Key? key}) : super(key: key);

  @override
  State<MyOrderDesktop> createState() => _MyOrderDesktopState();
}

class _MyOrderDesktopState extends State<MyOrderDesktop> {
  List<Map<dynamic, dynamic>> lists = [];


  var orderRef=FirebaseFirestore.instance.collection("Orders").doc(FirebaseAuth.instance.currentUser?.uid);

  double defaulttext=15;
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("_______________MyOrderDesktop______________");
    }

    return Scaffold(
        body:SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: ListView(
            shrinkWrap: true,
           physics: const BouncingScrollPhysics(),
           // crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Header(),
              const Padding(padding: EdgeInsets.zero),
               const Padding(
                padding: EdgeInsets.fromLTRB(50,50,30,0),
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
                height: MediaQuery.of(context).size.height/1.4,
                width: MediaQuery.of(context).size.width/3,
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
                        DateFormat format = DateFormat("hh:mm a").add_d().add_yMMM();

                        return AlignedGridView.count(
                            controller: ScrollController(),

                            physics: const BouncingScrollPhysics(),
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            itemCount:snapshot.data?.docs.length,
                            itemBuilder: (context, index){
                              return GestureDetector(
                                child: Padding(padding: const EdgeInsets.all(15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey
                                        ),
                                        borderRadius: BorderRadius
                                            .circular(10)
                                    ),
                                    height: 200,
                                    width: 500,
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:  [
                                        snapshot.data!.docs[index]["image"][0].toString().isNotEmpty==true?
                                        Image.network(snapshot.data?.docs[index]["image"][0],
                                          height: 150,
                                          width: 120,
                                          fit: BoxFit.fill,
                                        ):const SizedBox(
                                          height: 300,
                                          width: 250,
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
                                                  fontSize: 18
                                              ),
                                            ),
                                            const Padding(padding: EdgeInsets.only(top: 8)),
                                            const Text("Order Received",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                  fontSize: 15
                                              ),
                                            ),
                                            const Padding(padding: EdgeInsets.all(10)),
                                             Text("Delivered by ${DateFormat("dd MMM yyyy").format(
                                                 DateTime.parse(format.parse(snapshot.data?.docs[index]["or_dtime"])
                                                     .add(const Duration(days: 7)).toString()))}",
                                              style:const TextStyle(
                                                  fontSize:10,
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
              ),
              const Footer(),
            ],
          ),
        )
    );
  }
}
