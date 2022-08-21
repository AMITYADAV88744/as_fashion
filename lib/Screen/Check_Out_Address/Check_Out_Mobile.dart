
import 'dart:math';
import 'package:as_fashion/Screen/MainScreen/MainScreenPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../LandingPage/LandingPage.dart';
import 'ChangeAddressForm.dart';

class CheckOutMobile extends StatefulWidget {
 final String pid,size;
  const CheckOutMobile(this.pid,this.size,{Key? key}) : super(key: key);

  @override
  State<CheckOutMobile> createState(){

    return _CheckOutMobileState(this.pid,this.size);
  }
}

class _CheckOutMobileState extends State<CheckOutMobile> {

  _CheckOutMobileState(this.pid,this.size); ///intent value

  String pid,size;
  var quan=1,discount=50,total=0 ;
  bool phoneexit = true;


  /// firebase value initiallization

  var phone='' ,flatno='',address='',locality='',city='',pincode='',state='',  addressid='',image='',aid='',name='';

  TextEditingController nameController = TextEditingController(); // initialize the controller

  /// Product Database
  final DatabaseReference productRef = FirebaseDatabase.instance.reference().child('Products').child("Male");

  /// Order Database
  var order_ref= FirebaseFirestore.instance.collection("Orders").doc(FirebaseAuth.instance.currentUser?.uid.toString());

  /// Address Database
 var addRef= FirebaseFirestore.instance.collection('Address').doc(FirebaseAuth.instance.currentUser!.uid)
     .collection(FirebaseAuth.instance.currentUser!.uid).where('primary', isEqualTo: 'true');

  /// User Database
  var user= FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid.toString())
      .snapshots(includeMetadataChanges: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading:IconButton(
          onPressed:(){
            Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const LandingPage())
            );
            },
          icon:const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.grey,
          ),
        ),
        title: const Text("Billing Detail",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            color: Colors.grey
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15,15,15,0),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [

            ///Address

            StreamBuilder<QuerySnapshot>(
              stream: addRef.snapshots(),
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if(snapshot.connectionState==ConnectionState.active){

                  if(snapshot.data?.docs.isEmpty==true){

                    return Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey
                            ),
                            borderRadius: BorderRadius
                                .circular(1)
                        ),
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(20),
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:  const [
                                Text("Name : ",
                                  style: TextStyle(
                                      color: Colors.grey
                                  ),
                                ),
                                Text("",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(10)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:  [
                                const Text("Contact : ",
                                  style: TextStyle(
                                      color: Colors.grey
                                  ),
                                ),
                                Text(FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(10)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text("Address : ",
                                  style:TextStyle(
                                      color: Colors.grey
                                  ),
                                ),
                                Text(" ",
                                  maxLines: 4,
                                  style:TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(10)),
                            Container(
                              height: 25,
                              width: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black
                                  ),
                                  borderRadius: BorderRadius
                                      .circular(1)
                              ),
                              child:  InkWell(
                                onTap: (){
                                  print("_______AddressForm_________for Select");
                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (context) =>  AddAddressForm(pid,size))
                                  );
                                },
                                child: const Text(
                                  " Select Address",
                                  style: TextStyle(
                                      color: Colors.blueAccent
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    );
                  }
                  else{
                    snapshot.data?.docs.forEach((element) {
                      name=element.get("name");
                      flatno=element.get("flatno");
                      address=element.get("address");
                      locality=element.get("landmark");
                      pincode=element.get("pincode");
                      city=element.get("city");
                      state=element.get("state");
                      addressid=element.get("addressid");
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
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(20),
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:  [
                                const Text("Name : ",
                                  style: TextStyle(
                                      color: Colors.grey
                                  ),
                                ),
                                Text(name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:  [
                                const Text("Contact : ",
                                  style: TextStyle(
                                      color: Colors.grey
                                  ),
                                ),
                                Text(FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(8)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text("Address : ",
                                  style:TextStyle(
                                      color: Colors.grey
                                  ),
                                ),
                                 Text("$flatno $address\n$locality $city \n$state\n$pincode",
                                  maxLines: 4,
                                  style:const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 25,
                              width: 57,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black
                                  ),
                                  borderRadius: BorderRadius
                                      .circular(1)
                              ),
                              child:  InkWell(
                                onTap: (){
                                  if (kDebugMode) {
                                    print("_______AddressForm_________for Change");
                                  }

                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (context) =>  ChangeAddressForm(pid,size,addressid))
                                  );
                                },
                                child: const Text(
                                  "Change",
                                  style: TextStyle(
                                      color: Colors.blueAccent
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),

            ///Product Detail

            FutureBuilder(
              future:productRef.child(pid).get() ,
              builder: (context,AsyncSnapshot<DataSnapshot>snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }if(snapshot.hasData){
                  image = snapshot.data?.value['image'];
                  var brand = snapshot.data?.value['brand'];
                  var pname = snapshot.data?.value['pname'];
                  var price = snapshot.data?.value['price'];
                  total=(price*quan)-discount;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment:CrossAxisAlignment.start ,
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
                                    Text("Quan: $quan",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),

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
                                      Text(price.toString(),
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
                                      Text(discount.toString(),
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
                                      Text(total.toString(),
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
                      Container(
                          padding: const EdgeInsets.fromLTRB(25,5,10,5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey
                              ),
                              borderRadius: BorderRadius
                                  .circular(1)
                          ),
                          height: 52,
                          width: MediaQuery.of(context).size.width,
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Total",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 13
                                    ),
                                  ),
                                  Text(total.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 15
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 150,
                                height: 52,
                                decoration: BoxDecoration(
                                    border: Border.all(),
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
                                              .black
                                      ),
                                    ),
                                    child: const Text(
                                      'Proceed',
                                      style: TextStyle(
                                          fontWeight: FontWeight
                                              .bold,
                                          fontSize: 20,
                                          color: Colors
                                              .black
                                      ),
                                    ),
                                    onPressed: () {
                                      payment(context);
                                    }
                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        )
      ),
    );
  }

  void payment(context) {
    String  orderId='';
    final random = Random();
    for(int i = 0; i < 7; i++) {
      orderId = orderId + random.nextInt(9).toString();
    }
    var orderRef= FirebaseFirestore.instance.collection("Orders").doc(FirebaseAuth.instance.currentUser?.uid.toString());


    FirebaseFirestore.instance.collection("Address").doc(FirebaseAuth.instance.currentUser?.uid).set(
        {
          "name":name,
          "flatno":flatno,
          "address":address,
          "landmark":locality,
          "city":city,
          "state":state,
          "pincode":pincode,
        }
    ).whenComplete(() =>{

      orderRef.collection(FirebaseAuth.instance.currentUser!.uid.toString()).doc(orderId).set(
          {

           "name":name,
           "phone":FirebaseAuth.instance.currentUser!.phoneNumber,
            "flatno":flatno,
            "address":address,
            "city":city,
            "landmark":locality,
            "state":state,
            "pincode":pincode,
            "pid":pid,
            "order_no":orderId,
            "size":size,
            "color":"",
            "quantity":quan,
            "pay_state":"COD",
            "image":image
            //"product_state":
          }).whenComplete(() => {
            print("_________Main Page_______________after Order Create_____________"),
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreenPage())),
      }),
    });
  }
}
