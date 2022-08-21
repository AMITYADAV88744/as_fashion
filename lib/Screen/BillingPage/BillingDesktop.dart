
import 'dart:math';

import 'package:as_fashion/Screen/MyShoppingCart/MyCartPage.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_container/overlay_container.dart';

import '../../payments.dart';
import '../My_Address/AddressForm.dart';
import '../My_Address/My_Address.dart';
import 'ThankyouPage.dart';

class BillingDesktop extends StatefulWidget {

  final int sum;
  const BillingDesktop( this.sum, {Key? key}) : super(key: key);

  @override
  State<BillingDesktop> createState(){
    return _BillingDesktopState(this.sum);
  }
}

class _BillingDesktopState extends State<BillingDesktop> {
  var name;

  var image='';



  _BillingDesktopState(this.sum);
  var sum;
  List<int> total=[];
  int price=0,discount=0;

  int l_price=0;
  var flatno='',address='',locality='',city='',pincode='',state=''; /// firebase value initiallization

  final List _pid=[],quantity=[],sizes=[];

  /// Product Database
  var cartRef=FirebaseFirestore.instance.collection("ShoppingCart").doc(FirebaseAuth.instance.currentUser?.uid);

  /// Order Database
  var order_ref= FirebaseFirestore.instance.collection("Orders").doc(FirebaseAuth.instance.currentUser?.uid.toString());

  /// User Database
  var user= FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid.toString()).snapshots(includeMetadataChanges: true);

  /// Address Database
  var addRef= FirebaseFirestore.instance.collection('Address').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection(FirebaseAuth.instance.currentUser!.uid).where('primary', isNotEqualTo: 'false');

  final caddRef=FirebaseFirestore.instance.collection("Address").doc(FirebaseAuth.instance.currentUser?.uid);

  /// Overlay
  bool _dropdownShown = false;


  /// Product Database
  final DatabaseReference productRef = FirebaseDatabase.instance.reference().child('Products');
  String? phone = FirebaseAuth.instance.currentUser?.phoneNumber;
  bool phoneexit = true;
  var flag=0;
  Widget build(BuildContext context) {
    GroupController controller = GroupController(initSelectedItem: [2]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MyCartPage()));
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.grey,
          ),
        ),
        title: const Text('Billing Page',
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: cartRef.collection(
                    FirebaseAuth.instance.currentUser!.uid).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data?.docs.isEmpty == true) {
                      return const Center(
                        child: Text("You Cart is  Empty",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 25
                          ),
                        ),
                      );
                    }
                    else {
                      total.clear();

                      return Container(
                        padding: const EdgeInsets.fromLTRB(200, 10, 120, 0),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height,
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded( //<-- Expanded widget
                                flex: 6,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(35, 35, 0, 35),
                                  child: SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height,
                                    child: ListView(
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      children: [

                                        StreamBuilder<QuerySnapshot>(
                                          stream: addRef.snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }
                                            if (snapshot.connectionState ==
                                                ConnectionState.active) {
                                              if (snapshot.data?.docs.isEmpty ==
                                                  true) {
                                                return Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey
                                                        ),
                                                        borderRadius: BorderRadius
                                                            .circular(1)
                                                    ),
                                                    height: 200,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width,
                                                    padding: const EdgeInsets
                                                        .all(20),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .start,
                                                          children: const [
                                                            Text("Name : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                              ),
                                                            ),
                                                            Text("",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .all(10)),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            const Text(
                                                              "Contact : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                              ),
                                                            ),
                                                            Text(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .phoneNumber
                                                                .toString(),
                                                              style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .all(10)),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .start,
                                                          children: const [
                                                            Text("Address : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                              ),
                                                            ),
                                                            Text(" ",
                                                              maxLines: 4,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .all(10)),
                                                        Container(
                                                          padding: const EdgeInsets
                                                              .all(2),
                                                          height: 30,
                                                          width: 110,
                                                          decoration: BoxDecoration(
                                                              border: Border
                                                                  .all(
                                                                  color: Colors
                                                                      .black
                                                              ),
                                                              borderRadius: BorderRadius
                                                                  .circular(1)
                                                          ),
                                                          child: InkWell(
                                                            onTap: () {
                                                              if (kDebugMode) {
                                                                print(
                                                                    "_______AddressPage_________for Select");
                                                              }

                                                              Navigator
                                                                  .pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (
                                                                          context) => const My_Address())
                                                              );
                                                            },
                                                            child: const Text(
                                                              " Select Address",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blueAccent
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                );
                                              }
                                              else {
                                                snapshot.data?.docs.forEach((
                                                    element) {
                                                  name = element.get("name");
                                                  flatno =
                                                      element.get("flatno");
                                                  address =
                                                      element.get("address");
                                                  locality =
                                                      element.get("landmark");
                                                  pincode =
                                                      element.get("pincode");
                                                  city = element.get("city");
                                                  state = element.get("state");
                                                  //  addressid=element.get("addressid");


                                                });
                                                return Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey
                                                        ),
                                                        borderRadius: BorderRadius
                                                            .circular(1)
                                                    ),
                                                    height: 220,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width,
                                                    padding: const EdgeInsets
                                                        .all(20),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            const Text(
                                                              "Name : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                              ),
                                                            ),
                                                            Text(name,
                                                              style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .all(8)),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            const Text(
                                                              "Contact : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                              ),
                                                            ),
                                                            Text(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .phoneNumber
                                                                .toString(),
                                                              style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .all(8)),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            const Text(
                                                              "Address : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                              ),
                                                            ),
                                                            Text(
                                                              "$flatno $address\n$locality $city \n$state\n$pincode",
                                                              maxLines: 4,
                                                              style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                        Container(
                                                          height: 25,
                                                          width: 57,
                                                          padding: const EdgeInsets
                                                              .all(2),
                                                          decoration: BoxDecoration(
                                                              border: Border
                                                                  .all(
                                                                  color: Colors
                                                                      .black
                                                              ),
                                                              borderRadius: BorderRadius
                                                                  .circular(1)
                                                          ),
                                                          child: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                //  _dropdownShown = !_dropdownShown;
                                                              });
                                                              print(
                                                                  "_______AddressPage_________for change");
                                                              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  My_Address()));

                                                            },
                                                            child: const Text(
                                                              "Change",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blueAccent
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                );
                                              }
                                            }
                                            return const Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          height: MediaQuery
                                              .of(context)
                                              .size
                                              .height / 1.5,
                                          child: ListView.builder(
                                              itemCount: snapshot.data?.docs
                                                  .length,
                                              itemBuilder: (context, index) {
                                                var pid = snapshot.data
                                                    ?.docs[index]["pid"];
                                                 image = snapshot.data
                                                    ?.docs[index]["image"];
                                                var pname = snapshot.data
                                                    ?.docs[index]["pname"];
                                                var brand = snapshot.data
                                                    ?.docs[index]["brand"];
                                                price = snapshot.data
                                                    ?.docs[index]["price"];
                                                // l_price =snapshot.data?.docs[index]["l_price"];

                                                var quan = snapshot.data
                                                    ?.docs[index]["quantity"];
                                                var size = snapshot.data
                                                    ?.docs[index]["size"];
                                                //print(pid);

                                               // var amount=quan*price;
                                                _pid.add(pid.toString());
                                                quantity.add(quan);
                                                sizes.add(size);
                                                total.add(quan * price);
                                                sum = total.reduce((value,
                                                    element) =>
                                                value + element);
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
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width,
                                                  padding: const EdgeInsets.all(
                                                      20),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [

                                                      Image.network(image,
                                                        height: 100,
                                                        width: 90,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      const Padding(
                                                          padding: EdgeInsets
                                                              .all(10)),
                                                      Column(
                                                        // mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Text(pname,
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15
                                                            ),
                                                          ),
                                                          const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  top: 8)),
                                                          Text(brand,
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .grey,
                                                                fontSize: 12
                                                            ),
                                                          ),
                                                          const Padding(
                                                              padding: EdgeInsets
                                                                  .all(10)),
                                                          Text("Size : $size",
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey
                                                            ),
                                                          ),
                                                          const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  top: 8)),
                                                          Row(
                                                            //crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceEvenly,
                                                            children: [
                                                              Text(
                                                                "Price : $price",
                                                                style: const TextStyle(
                                                                    fontSize: 12,
                                                                    color: Colors
                                                                        .grey
                                                                ),
                                                              ),
                                                              const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                      left: 25)),
                                                              const Text(
                                                                "Quan: ",
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: Colors
                                                                        .grey
                                                                ),
                                                              ),
                                                              //_decrementButton(index,quan,pid),
                                                              Text(
                                                                '$quan',
                                                                style: const TextStyle(
                                                                    fontSize: 12.0),
                                                              ),
                                                              //_incrementButton(index,quan,pid),
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
                                      ],
                                      // padding: const EdgeInsets.fromLTRB(35,35,35,5),

                                    ),
                                  ),
                                )
                            ),
                            Expanded( //<-- Expanded widget
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      35, 35, 35, 5),
                                  child: FutureBuilder(
                                      future: Future.delayed(
                                          const Duration(seconds: 2)),
                                      builder: (context, snapshot) {
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            const Padding(
                                                padding: EdgeInsets.all(2)),

                                            ///Price Summaryy
                                            Container(
                                              height: 230,
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width,

                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey
                                                  ),
                                                  borderRadius: BorderRadius
                                                      .circular(5)
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(25, 5, 0, 5),
                                                    color: Colors.grey,
                                                    height: 35,
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width,
                                                    child: const Text(
                                                      "PRICE SUMMARY",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          color: Colors.black,
                                                          fontSize: 15
                                                      ),
                                                    ),
                                                  ),
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 26)),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(15, 5, 15, 0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              "Total MRP (Incl. of taxes)",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            Text(
                                                              price.toString(),
                                                              style: const TextStyle(
                                                                color: Colors
                                                                    .grey,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .only(top: 20)),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          children: const [
                                                            Text(
                                                              "Delivery Charges",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            Text(
                                                              "Free",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .only(top: 20)),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          children: const [
                                                            Text(
                                                              "Discount",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            Text("0",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .only(top: 20)),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            const Text(
                                                              "Subtotal",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            Text(sum.toString(),
                                                              style: const TextStyle(
                                                                color: Colors
                                                                    .grey,
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
                                            Container(
                                              padding: const EdgeInsets
                                                  .fromLTRB(25, 5, 0, 5),
                                              color: Colors.grey,
                                              height: 35,
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width,
                                              child: const Text(
                                                "Select Payment Mode",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 15
                                                ),
                                              ),
                                            ),
                                            Container(
                                                padding: const EdgeInsets
                                                    .fromLTRB(25, 5, 10, 5),
                                                height: 100,
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey
                                                    ),
                                                    borderRadius: BorderRadius
                                                        .circular(1)
                                                ),
                                                child: StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return SimpleGroupedCheckbox<
                                                        int>(
                                                      controller: controller,
                                                      //groupTitle:"Basic",
                                                      onItemSelected: (data) {
                                                        print(data);
                                                        if (data == 1) {
                                                          setState(() {
                                                            flag == 0;
                                                          });
                                                          //controller.disabledItemsByTitles(["Cash on Delivery"]);
                                                          controller
                                                              .enabledItemsByTitles(
                                                              [
                                                                "Online Payment Method"
                                                              ]);
                                                        } else if (data == 2) {
                                                          setState(() {
                                                            flag == 1;
                                                          });
                                                          controller
                                                              .enabledItemsByTitles(
                                                              [
                                                                "Cash on Delivery"
                                                              ]);
                                                          //controller.disabledItemsByTitles(["Online Payment Method"]);
                                                        }
                                                      },
                                                      itemsTitle: const [
                                                        "Online Payment Method",
                                                        "Cash on Delivery",
                                                      ],
                                                      values: const [1, 2,],
                                                      groupStyle: GroupStyle(
                                                          activeColor: Colors
                                                              .blueAccent,
                                                          itemTitleStyle: const TextStyle(
                                                              fontSize: 13)),
                                                      checkFirstElement: false,
                                                    );
                                                  },
                                                )
                                            ),
                                            FutureBuilder(
                                                future: Future.delayed(
                                                    const Duration(seconds: 2)),
                                                builder: (context, s) {
                                                  return Container(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          25, 5, 10, 5),
                                                      height: 50,
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors.grey
                                                          ),
                                                          borderRadius: BorderRadius
                                                              .circular(1)
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .center,
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Text("Total: $sum",
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 22
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                fixedSize: const Size(
                                                                    160, 45)
                                                            ),
                                                            onPressed: () {
                                                              payment(context);
                                                            },
                                                            child: const Text(
                                                              "Proceed",
                                                              style: TextStyle(
                                                                  fontSize: 22,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight: FontWeight
                                                                      .bold

                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                  );
                                                }
                                            ),
                                          ],
                                        );
                                      }),
                                )
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator(),);
                  }
                }),
            OverlayContainer(
              show: _dropdownShown,
              position: const OverlayContainerPosition(
                // Left position.
                  -14, 470
                // Bottom position.
              ),
              // The content inside the overlay.
              child: Container(
                  height: 550,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 3,
                        spreadRadius: 6,
                      )
                    ],
                  ),
                  child: Column(
                    // shrinkWrap: true,
                    //physics: BouncingScrollPhysics(),
                    children: [
                      Container(
                          height: 50,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey
                              ),
                              borderRadius: BorderRadius
                                  .circular(1)
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _dropdownShown = !_dropdownShown;
                                  });
                                },
                                icon: const Icon(
                                  Icons.clear,
                                  size: 20,
                                ),
                              ),
                              const Center(
                                child: Text(
                                  "Select Address",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20
                                  ),

                                ),
                              )
                            ],
                          )
                      ),
                      SizedBox(
                        height: 450,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child:
                        ListView(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                stream: caddRef.collection(
                                    FirebaseAuth.instance.currentUser!.uid)
                                    .orderBy("primary", descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.active) {
                                    if (snapshot.data?.docs.isEmpty == true) {
                                      return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 0, 10),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                  context, MaterialPageRoute(
                                                  builder: (
                                                      context) => const AddressFormAdd()
                                              ));
                                            },
                                            child: Container(
                                              height: 250,
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey
                                                  ),
                                                  borderRadius: BorderRadius
                                                      .circular(10)
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .center,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .center,
                                                children: const [
                                                  Icon(
                                                    Icons.add,
                                                    size: 35,
                                                    color: Colors.blueAccent,
                                                  ),
                                                  Text("Add Address",
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight: FontWeight
                                                          .normal,
                                                      color: Colors.blueAccent,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                      );
                                    }
                                    else {
                                      return ListView.builder(
                                          physics: const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: snapshot.data?.docs.length,
                                          itemBuilder: (context, index) {
                                            var name = snapshot.data
                                                ?.docs[index]["name"];
                                            var addressid = snapshot.data
                                                ?.docs[index]["addressid"];
                                            var flatno = snapshot.data
                                                ?.docs[index]["flatno"];
                                            var address = snapshot.data
                                                ?.docs[index]["address"];
                                            var city = snapshot.data
                                                ?.docs[index]["city"];
                                            var state = snapshot.data
                                                ?.docs[index]["state"];
                                            var locality = snapshot.data
                                                ?.docs[index]["landmark"];
                                            var pincode = snapshot.data
                                                ?.docs[index]["pincode"];
                                            var primary = snapshot.data
                                                ?.docs[index]["primary"];
                                            var trues = "true";
                                            return Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 200,
                                                    padding: const EdgeInsets
                                                        .all(10),
                                                    width: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .width,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey
                                                        ),
                                                        borderRadius: BorderRadius
                                                            .circular(10)
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .start,
                                                      children: [
                                                        primary == trues ?
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          children: const [
                                                            Text("Default : ",
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .grey
                                                              ),
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .all(5)),
                                                            Divider(
                                                              color: Colors
                                                                  .grey,
                                                              height: 3,
                                                              thickness: 1,
                                                              indent: 3,
                                                            )
                                                          ],
                                                        ) : Visibility(
                                                            visible: false,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment
                                                                  .start,
                                                              children: const [
                                                                Text(
                                                                  "Default : ",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey
                                                                  ),
                                                                ),
                                                                Divider(
                                                                  color: Colors
                                                                      .grey,
                                                                  height: 3,
                                                                  thickness: 3,
                                                                  indent: 3,
                                                                )
                                                              ],
                                                            )
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .all(5)),
                                                        Text(name,
                                                          maxLines: 1,
                                                          style: const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .all(5)),
                                                        Text(flatno + " " +
                                                            address + " " +
                                                            locality,
                                                          maxLines: 3,
                                                          style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(city,
                                                              style: const TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                    left: 5)),
                                                            Text(state,
                                                              style: const TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(pincode,
                                                          style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .all(5)),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .start,
                                                          children: [

                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator
                                                                      .pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (
                                                                              context) =>
                                                                              AddressForm(
                                                                                  addressid)));
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                    fixedSize: const Size(
                                                                        90, 40),
                                                                    primary: Colors
                                                                        .white70

                                                                ),
                                                                child: const Text(
                                                                  "Edit",
                                                                  style: TextStyle(
                                                                      fontSize: 12,
                                                                      color: Colors
                                                                          .black
                                                                  ),
                                                                )

                                                            ),
                                                            const Padding(
                                                                padding: EdgeInsets
                                                                    .all(25)),
                                                            Visibility(
                                                              visible: primary ==
                                                                  trues ?
                                                              false : true,
                                                              child: ElevatedButton(
                                                                  onPressed: () async {
                                                                    /*  var collection = FirebaseFirestore.instance
                                                                          .collection('Address').doc(FirebaseAuth.instance.currentUser!.uid)
                                                                          .collection(FirebaseAuth.instance.currentUser!.uid);
                                                                      var querySnapshots = await collection.get();
                                                                      for (var doc in querySnapshots.docs) {
                                                                        await doc.reference.update({
                                                                          'primary': 'false',
                                                                        }).whenComplete(() =>
                                                                          //  changeprimary(snapshot.data?.docs[index]["addressid"], context)
                                                                        );
                                                                      }
                                                                      */
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                      fixedSize: const Size(
                                                                          119,
                                                                          40),
                                                                      primary: Colors
                                                                          .white70
                                                                  ),
                                                                  child: const Text(
                                                                    "Select",
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors
                                                                            .black
                                                                    ),
                                                                  )
                                                              ),
                                                            ),

                                                          ],
                                                        )

                                                      ],
                                                    ),
                                                  ),

                                                ],
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
                            ]
                        ),
                      )
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  void payment(context) {
    if (kDebugMode) {
      print(flag);
    }
    String  orderId='';
    String pstate;
    var now = DateTime.now();
    var formatterTime = DateFormat('hh:mm a');
    String actualTime = formatterTime.add_d().add_yMMM().format(now);
    final random = Random();
    for(int i = 0; i < 7; i++) {
      orderId = orderId + random.nextInt(9).toString();
    }
    var orderRef= FirebaseFirestore.instance.collection("Orders").doc(FirebaseAuth.instance.currentUser!.uid);
    var deleteRef= FirebaseFirestore.instance.collection("ShoppingCart").doc(FirebaseAuth.instance.currentUser!.uid);
    var adminOrder= FirebaseFirestore.instance.collection("AdminOrders");
    if(flag==0){
      pstate='COD';
    }else{
      pstate='Online';
    }
    orderRef.collection(FirebaseAuth.instance.currentUser!.uid.toString()).doc(orderId).set(
        {
          "or_dtime":actualTime,
          "payment":"",
          "name":name,
          "phone":FirebaseAuth.instance.currentUser!.phoneNumber,
          "flatno":flatno,
          "address":address,
          "city":city,
          "landmark":locality,
          "state":state,
          "pincode":pincode,
          "pid":_pid,
          "order_no":orderId,
          "size":sizes,
          "color":"",
          "quantity":quantity,
          "image":"",
          "or_status": "placed",
          "userID":FirebaseAuth.instance.currentUser!.uid,
          "pay_state":pstate,
          //"product_state":
        }).whenComplete(() => {
      for(int i=0;i<_pid.length;i++){
        deleteRef.collection(FirebaseAuth.instance.currentUser!.uid).doc(_pid[i]).delete()
      }
    }).whenComplete(() => {
      adminOrder.doc(orderId).set(
          {
            "or_dtime":actualTime,
            "payment":"",
            "name":name,
            "phone":FirebaseAuth.instance.currentUser!.phoneNumber,
            "flatno":flatno,
            "address":address,
            "city":city,
            "landmark":locality,
            "state":state,
            "pincode":pincode,
            "pid":_pid,
            "order_no":orderId,
            "size":sizes,
            "color":"",
            "quantity":quantity,
            "image":"",
            "or_status": "Pending",
            "userID":FirebaseAuth.instance.currentUser!.uid,
            "pay_state":pstate,
            "product_state":""
          })
    }).whenComplete(() =>{
      if(flag==1){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const ThankYouPage())),
      }else if(flag==0){
        print("_________Thankyou  Page_______________after Order Create_____________"),
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Webpayment(name: name,price:sum,orderId: orderId,)))
      }
    });
  }
}
