
import 'dart:math';

import 'package:as_fashion/Screen/MainScreen/MainScreenPage.dart';
import 'package:as_fashion/Screen/My_Address/My_Address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'LandingPage/LandingPage.dart';

class BillingPage extends StatelessWidget {
  int sum;
  BillingPage( this.sum,  {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("_______BillingPage through cart_________");

    return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return    BillingMobile(sum);
            } else if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
              return     BillingMobile(sum);
            } else {
              return    BillingMobile(sum);
            }
          },
        )
    );
  }
}

class BillingMobile extends StatelessWidget{

  int sum;

  var image;

  BillingMobile(this.sum,    {Key? key}) : super(key: key);


  var quan=1,discount=50,total=0 ;
  bool phoneexit = true;

  var phone ,flatno,address,locality,city,pincode,state; /// firebase value initiallization

  var name;
   List _pid=[],quantity=[],sizes=[];

  TextEditingController nameController = TextEditingController(); // initialize the controller

  /// Product Database
  var cartRef=FirebaseFirestore.instance.collection("ShoppingCart").doc(FirebaseAuth.instance.currentUser?.uid);


  /// Order Database
  var order_ref= FirebaseFirestore.instance.collection("Orders").doc(FirebaseAuth.instance.currentUser?.uid.toString());



  /// User Database
  var user= FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid.toString()).snapshots(includeMetadataChanges: true);

  /// Address Database
  var addRef= FirebaseFirestore.instance.collection('Address').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection(FirebaseAuth.instance.currentUser!.uid).where('primary', isNotEqualTo: 'false');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading:IconButton(
          onPressed:(){
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) =>  LandingPage(""))
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
                                padding: EdgeInsets.all(2),
                                height: 30,
                                width: 110,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black
                                    ),
                                    borderRadius: BorderRadius
                                        .circular(1)
                                ),
                                child:  InkWell(
                                  onTap: (){

                                    print("_______AddressPage_________for Select");

                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context) => My_Address())
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
                                  Text(flatno+" "+address+"\n"+locality+" "+city+" \n"+state+"\n"+pincode,
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
                                    print("_______AddressPage_________for change");

                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context) =>  My_Address())
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
                          )
                      );                  }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),

              /// Product Container//////////////////////////////
              StreamBuilder<QuerySnapshot>(
                stream:cartRef.collection(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                builder: (context, snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }if(snapshot.hasData){
                    total=sum-discount;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment:CrossAxisAlignment.start ,
                      children: [
                        /// Product detail
                        Container(
                          height: 200,
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
                                  padding: const EdgeInsets.fromLTRB(15,5,15,5),
                                  color: Colors.grey,
                                  height: 35,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:const [
                                    Text("Product",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15
                                      ),
                                    ),
                                    VerticalDivider(thickness: 2,width: 2,),
                                    Text("Quan",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15
                                      ),
                                    ),
                                    VerticalDivider(thickness: 2,width: 2,),
                                   /* Text("Price",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15
                                      ),
                                    ),
                                    VerticalDivider(thickness: 2,width: 2,),
                                    */
                                    Text("Total",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15
                                      ),
                                    ),
                                  ],
                                )
                              ),


                              ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.fromLTRB(15,5,15,5),
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder:(context,index){
                                  var pid=snapshot.data!.docs[index]["pid"];
                                     image =snapshot.data?.docs[0]["image"];
                                    var pname =snapshot.data?.docs[index]["pname"];
                                    var brand =snapshot.data?.docs[index]["brand"];
                                    var price =snapshot.data?.docs[index]["price"];
                                    var quan=snapshot.data?.docs[index]["quantity"];
                                    var size =snapshot.data?.docs[index]["size"];
                                    var amount=quan*price;
                                  _pid.add(pid.toString());
                                  quantity.add(quan);
                                  sizes.add(size);
                                  //quan.add(quan);

                                  return  Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(pname.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                              fontSize: 15
                                          ),
                                        ),
                                        Text(quan.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                              fontSize: 15
                                          ),
                                        ),

                                      /*  Text(price.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                              fontSize: 15
                                          ),
                                        ),
                                        */
                                        Text(amount.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                              fontSize: 15
                                          ),
                                        ),
                                      ],
                                    );

                                  }
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
                                        'Confirm',
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
    var orderRef= FirebaseFirestore.instance.collection("Orders").doc(FirebaseAuth.instance.currentUser!.uid);

    var deleteRef= FirebaseFirestore.instance.collection("ShoppingCart").doc(FirebaseAuth.instance.currentUser!.uid);

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
          "pid":_pid,
          "order_no":orderId,
          "size":sizes,
          "color":"",
          "quantity":quantity,
          "image":image,
          "pay_state":"COD",

          //"product_state":
        }).whenComplete(() => {
          for(int i=0;i<_pid.length;i++){
            deleteRef.collection(FirebaseAuth.instance.currentUser!.uid).doc(_pid[i]).delete()
          }

    }).whenComplete(() =>  {

    print("_______MainScreen_________after order created"),
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MainScreenPage()
      ))

    });
  }
}
