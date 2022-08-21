
import 'dart:math';

import 'package:as_fashion/Screen/My_Address/My_Address.dart';
import 'package:as_fashion/Screen/BillingPage/ThankyouPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:overlay_container/overlay_container.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../payments.dart';
import '../LandingPage/LandingPage.dart';
import '../My_Address/AddressForm.dart';
import 'BillingDesktop.dart';

class BillingPage extends StatelessWidget {
  final int sum;
  const BillingPage( this.sum,  {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("_______BillingPage through cart_________");
    }

    return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return    BillingMobile(sum);
            } else if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
              return     BillingMobile(sum);
            } else {
              return    BillingDesktop(sum);
            }
          },
        )
    );
  }
}

class BillingMobile extends StatefulWidget {
   final int sum;
   const BillingMobile( this.sum, {Key? key}) : super(key: key);

  @override
  State<BillingMobile> createState(){
    return _BillingMobileState(this.sum);
  }
}

class _BillingMobileState extends State<BillingMobile> {

  int sum;

  var price;

  late int ship_char=0;

  _BillingMobileState(this.sum);


  List image=[];

  var quan=1,discount=50,total=0 ;
  bool phoneexit = true;

  var phone='' ,flatno='',address='',locality='',city='',pincode='',state=''; /// firebase value initiallization

  var name='';
 final List _pid=[],quantity=[],sizes=[];

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

  final caddRef=FirebaseFirestore.instance.collection("Address").doc(FirebaseAuth.instance.currentUser?.uid);

  /// Overlay
  bool _dropdownShown = false;


  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(price,name,number) async {
    if(kIsWeb){

      String  orderId='';
      String pstate;

      var now = DateTime.now();
      var formatterTime = DateFormat('hh:mm a');
      String actualTime = formatterTime.add_d().add_yMMM().format(now);
      // print(actualTime);
      final random = Random();
      for(int i = 0; i < 7; i++) {
        orderId = orderId + random.nextInt(9).toString();
      }
      var orderRef= FirebaseFirestore.instance.collection("Orders").doc(FirebaseAuth.instance.currentUser!.uid);

      var deleteRef= FirebaseFirestore.instance.collection("ShoppingCart").doc(FirebaseAuth.instance.currentUser!.uid);
      var adminOrder= FirebaseFirestore.instance.collection("AdminOrders");
      pstate='Online';

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
            "image":image,
            "or_status": "Pending",
            "pay_state":"COD",
            //"product_state":
          }).whenComplete(() => {
        for(int i=0;i<_pid.length;i++){
          deleteRef.collection(FirebaseAuth.instance.currentUser!.uid).doc(_pid[i]).delete()
        },

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
              "image":image,
              "or_status": "Pending",
              "pay_state":"COD",
            })

      }).whenComplete(() =>  {
        print("_________Thankyou  Page_______________after Order Create_____________"),
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Webpayment(name: nameController.text.trim(),price:total, orderId: orderId,)))

      });
    }else{
      var options = {
        'key': 'rzp_test_RKigzW35lO3ZvT',
        'amount': price*100,
        'name': "AS Fashion",
        'description': 'Payment',

        'prefill': {'contact': number, 'email': 'sy4306122@gmail.com'},
        'external': {
          'wallets': ['paytm'],
        },
        'config':{
          'display': {
            'blocks': {
              'banks': {
                'name': 'Methods with Offers',
                'instruments': [{
                  'method': 'upi',
                }]
              },
            },
            'sequence': ['block.banks'],
            'preferences': {
              'show_default_blocks': false,
            },
          },
          'other': { //  name for other block
            name: "Cash on Delivery Payment modes",
            'instruments': [
              {
                'method': "cod",

              },

            ]
          },
          'hide':[
            {
              'method': "wallet",

            },
          ]
        }
      };

      try {
        _razorpay.open(options);
      } catch (e) {
        debugPrint(e.toString());
      }
    }

  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    payment(response.paymentId);
    Fluttertoast.showToast(
        msg:"SUCCESS: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName}");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 1,
        leading:IconButton(
          onPressed:(){
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) =>  LandingPage(""))
            );
          },
          icon:const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        title: const Text("Billing Detail",
          style: TextStyle(
              color: Colors.black
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
                                      fontWeight: FontWeight.normal,
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
                                      fontWeight: FontWeight.normal,
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
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),

                                ],
                              ),
                              const Padding(padding: EdgeInsets.all(10)),
                              Container(
                                padding: const EdgeInsets.all(2),
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

                                    if (kDebugMode) {
                                      print("_______AddressPage_________for Select");
                                    }

                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context) => const My_Address())
                                    );
                                  },
                                  child: const Text(
                                    " Select Address",
                                    style: TextStyle(
                                        color: Colors.amber
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
                                      fontWeight: FontWeight.normal,
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
                                      fontWeight: FontWeight.normal,
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
                                      fontWeight: FontWeight.normal,
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
                                    setState(() {

                                      _dropdownShown = !_dropdownShown;
                                    });

                                  },
                                  child: const Text(
                                    "Change",
                                    style: TextStyle(
                                        color: Colors.amber
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
                                  color: Colors.amber,
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
                                      VerticalDivider(color:Colors.black,thickness: 2,width: 2,),
                                      Text("Quan",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 15
                                        ),
                                      ),
                                      VerticalDivider(color:Colors.black,thickness: 2,width: 2,),
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
                                    price =snapshot.data?.docs[index]["price"];
                                    var quan=snapshot.data?.docs[index]["quantity"];
                                    var size =snapshot.data?.docs[index]["size"];
                                    //ship_char=snapshot.data!.docs[index]["ship_char"];
                                    //discount=snapshot.data

                                    var amount=quan*price;
                                    _pid.add(pid.toString());
                                    quantity.add(quan);
                                    sizes.add(size);

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
                                padding: const EdgeInsets.fromLTRB(25,5,0,5),
                                color: Colors.amber,
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
                                            color: Colors.black,
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
                                        const Text("Delivery Charges",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(ship_char.toString(),
                                          style: const TextStyle(
                                            color: Colors.black,
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
                                            color: Colors.black,
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
                                            color: Colors.black,
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
                                      border: Border.all(
                                        color: Colors.amber
                                      ),
                                      borderRadius: BorderRadius
                                          .circular(5)
                                  ),
                                  child: TextButton(
                                      style: TextButton
                                          .styleFrom(
                                        backgroundColor: Colors
                                            .amber,

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
                                        showModalBottomSheet(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(30),
                                              ),
                                            ),
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            context: context,
                                            builder: (context) {
                                              return Padding(
                                                padding: const EdgeInsets.all(30),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    const ListTile(
                                                      title:  Text('Select Payment Method',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: const Text('Cash on Delivery'),
                                                      onTap: () {

                                                        var paymentID='';
                                                        payment( paymentID);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    ListTile(
                                                      title:  const Text('Online Payment Method'),
                                                      onTap: () {
                                                        openCheckout( price, name, FirebaseAuth.instance.currentUser?.phoneNumber);
                                                      },
                                                    ),

                                                  ],
                                                ),
                                              );
                                            }
                                        );
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

              OverlayContainer(
                show: _dropdownShown,
                position: const OverlayContainerPosition(
                  // Left position.
                    -14,470
                  // Bottom position.
                ),
                // The content inside the overlay.
                child: Container(
                    height: 550,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color:Colors.grey,
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
                            width: MediaQuery.of(context).size.width,
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
                                  onPressed: (){
                                    setState(() {
                                      _dropdownShown=!_dropdownShown;

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
                                ),
                              /*  IconButton(onPressed:(){},
                                    icon: Icon(
                                      Icons.add,
                                      size: 20,

                                    )
                                ),
                                */
                              ],
                            )
                        ),
                        SizedBox(
                          height: 450,
                          width: MediaQuery.of(context).size.width,
                          child:
                          ListView(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                  stream:caddRef.collection(FirebaseAuth.instance.currentUser!.uid).orderBy("primary",descending: true).snapshots() ,
                                  builder: (context,snapshot){
                                    if(snapshot.connectionState==ConnectionState.waiting){
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if(snapshot.connectionState==ConnectionState.active){

                                      if(snapshot.data?.docs.isEmpty==true){
                                        return Padding(
                                            padding: const EdgeInsets.fromLTRB(10,0,0,10),
                                            child: GestureDetector(
                                              onTap: (){
                                                Navigator.pushReplacement(
                                                    context, MaterialPageRoute(builder: (context) =>  const AddressFormAdd()
                                                ));
                                              },
                                              child: Container(
                                                height: 250,
                                                width: MediaQuery.of(context).size.width,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey
                                                    ),
                                                    borderRadius: BorderRadius
                                                        .circular(10)
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children:const [
                                                    Icon(
                                                      Icons.add,
                                                      size: 35,
                                                      color: Colors.blueAccent,
                                                    ),
                                                    Text("Add Address",
                                                      style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight: FontWeight.normal,
                                                        color: Colors.blueAccent,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                        );
                                      }
                                      else{

                                        return ListView.builder(
                                            physics: const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: snapshot.data?.docs.length,
                                            itemBuilder: (context,index){
                                              var name=snapshot.data?.docs[index]["name"];
                                              var addressid=snapshot.data?.docs[index]["addressid"];
                                              var flatno=snapshot.data?.docs[index]["flatno"];
                                              var address=snapshot.data?.docs[index]["address"];
                                              var city=snapshot.data?.docs[index]["city"];
                                              var state=snapshot.data?.docs[index]["state"];
                                              var locality=snapshot.data?.docs[index]["landmark"];
                                              var pincode=snapshot.data?.docs[index]["pincode"];
                                              var primary=snapshot.data?.docs[index]["primary"];
                                              var trues="true";
                                              return Padding(
                                                padding: const EdgeInsets.all(8),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: 200,
                                                      padding: const EdgeInsets.all(10),
                                                      width: MediaQuery.of(context).size.width,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors.grey
                                                          ),
                                                          borderRadius: BorderRadius
                                                              .circular(10)
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          primary==trues ?
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: const [
                                                              Text("Default : ",
                                                                style:TextStyle(
                                                                    fontSize: 10,
                                                                    color: Colors.grey
                                                                ),
                                                              ),
                                                              Padding(padding: EdgeInsets.all(5)),
                                                              Divider(
                                                                color: Colors.grey,
                                                                height: 3,
                                                                thickness: 1,
                                                                indent: 3,
                                                              )
                                                            ],
                                                          ):Visibility(
                                                              visible:false  ,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: const [
                                                                  Text("Default : ",
                                                                    style:TextStyle(
                                                                        color: Colors.grey
                                                                    ),
                                                                  ),
                                                                  Divider(
                                                                    color: Colors.grey,
                                                                    height: 3,
                                                                    thickness: 3,
                                                                    indent: 3,
                                                                  )
                                                                ],
                                                              )
                                                          ),
                                                          const Padding(padding: EdgeInsets.all(5)),
                                                          Text(name,
                                                            maxLines: 1,
                                                            style: const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          const Padding(padding: EdgeInsets.all(5)),
                                                          Text(flatno+" "+address+" "+locality,
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
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              const Padding(padding: EdgeInsets.only(left: 5)),
                                                              Text(state,
                                                                style: const TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors.black,
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
                                                          const Padding(padding: EdgeInsets.all(5)),
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [

                                                              ElevatedButton(
                                                                  onPressed: (){
                                                                    Navigator.pushReplacement(context, MaterialPageRoute(
                                                                        builder: (context) =>  AddressForm(addressid)));
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                      fixedSize: const Size(90, 40),
                                                                      primary: Colors.white70

                                                                  ),
                                                                  child: const Text("Edit",
                                                                    style: TextStyle(
                                                                        fontSize:12 ,
                                                                        color: Colors.black
                                                                    ),
                                                                  )

                                                              ),
                                                              const Padding(padding: EdgeInsets.all(25)),
                                                              Visibility(
                                                                visible: primary==trues ?
                                                                false:true,
                                                                child:ElevatedButton(
                                                                    onPressed:() async{
                                                                      var collection = FirebaseFirestore.instance
                                                                          .collection('Address').doc(FirebaseAuth.instance.currentUser!.uid)
                                                                          .collection(FirebaseAuth.instance.currentUser!.uid);
                                                                      var querySnapshots = await collection.get();
                                                                      for (var doc in querySnapshots.docs) {
                                                                        await doc.reference.update({
                                                                          'primary': 'false',
                                                                        }).whenComplete(() =>
                                                                            changeprimary(snapshot.data?.docs[index]["addressid"], context)
                                                                        );
                                                                      }
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                        fixedSize: const Size(119, 40),
                                                                        primary: Colors.white70
                                                                    ),
                                                                    child: const Text("Select",
                                                                      style: TextStyle(
                                                                          fontSize:12 ,
                                                                          color: Colors.black
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
          )

      ),

    );
  }

  void payment( paymentId) {
    var now = DateTime.now();
    var formatterTime = DateFormat('hh:mm a');
    String actualTime = formatterTime.add_d().add_yMMM().format(now);
    if (kDebugMode) {
      print(actualTime);
    }
    String  orderId='';
    final random = Random();
    for(int i = 0; i < 7; i++) {
      orderId = orderId + random.nextInt(9).toString();
    }
    var orderRef= FirebaseFirestore.instance.collection("Orders").doc(FirebaseAuth.instance.currentUser!.uid);

    var deleteRef= FirebaseFirestore.instance.collection("ShoppingCart").doc(FirebaseAuth.instance.currentUser!.uid);
    var adminOrder= FirebaseFirestore.instance.collection("AdminOrders");


    orderRef.collection(FirebaseAuth.instance.currentUser!.uid.toString()).doc(orderId).set(
        {
          "or_dtime":actualTime,
          "payment":paymentId,
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
          "or_status": "Pending",
          "pay_state":"COD",

          //"product_state":
        }).whenComplete(() => {
      for(int i=0;i<_pid.length;i++){
        deleteRef.collection(FirebaseAuth.instance.currentUser!.uid).doc(_pid[i]).delete()
      },

      adminOrder.doc(orderId).set(
          {
            "or_dtime":actualTime,
            "payment":paymentId,
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
            "or_status": "Pending",
            "pay_state":"COD",
          })

    }).whenComplete(() =>  {
    Navigator.pushReplacement(context, MaterialPageRoute(
    builder: (context) =>  const ThankYouPage())),
    });
  }


  changeprimary(addressid,context){


    var change= FirebaseFirestore.instance.collection('Address').doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(FirebaseAuth.instance.currentUser!.uid);

    if (kDebugMode) {
      print(addressid);
    }
    change.doc(addressid).update({
      "primary":"true"
    }).whenComplete((){

    });

  }

}



