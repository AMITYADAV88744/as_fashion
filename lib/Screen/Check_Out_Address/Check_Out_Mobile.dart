
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:overlay_container/overlay_container.dart' ;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../payments.dart';
import '../BillingPage/ThankyouPage.dart';
import '../LandingPage/LandingPage.dart';
import '../My_Address/AddressForm.dart';
import '../My_Address/My_Address.dart';

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

  var phone='' ,flatno='',address='',locality='',city='',pincode='',state='',  addressid='',aid='',name='';
  List image=[];

  TextEditingController nameController = TextEditingController(); // initialize the controller

  /// Product Database
  final DatabaseReference productRef = FirebaseDatabase.instance.reference().child('Products');

  /// Order Database
  var order_ref= FirebaseFirestore.instance.collection("Orders").doc(FirebaseAuth.instance.currentUser?.uid.toString());

  /// Address Database
 var addRef= FirebaseFirestore.instance.collection('Address').doc(FirebaseAuth.instance.currentUser!.uid)
     .collection(FirebaseAuth.instance.currentUser!.uid).where('primary', isEqualTo: 'true');
  final caddRef=FirebaseFirestore.instance.collection("Address").doc(FirebaseAuth.instance.currentUser?.uid);


  /// User Database
  var user= FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid.toString())
      .snapshots(includeMetadataChanges: true);


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
     // print(flag);
      List _pid=[],quantity=[],sizes=[];
      _pid.add(pid);
      quantity.add(quan);
      sizes.add(size);
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
            "or_dtime":actualTime,
            //"payment":paymentId,
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
            "pay_state":pstate,

            //"product_state":
          }).whenComplete(() => {
        deleteRef.collection(FirebaseAuth.instance.currentUser!.uid).doc(pid).delete(),
        adminOrder.doc(orderId).set(
            {
              "or_dtime":actualTime,
              "payment":"",
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
              "pay_state":pstate,
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
        //backgroundColor: Colors.white,
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
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
                height: MediaQuery.of(context).size.height-80,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(10, 10 ,10, 0),
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
                                        child:  const Text(
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
                                              color: Colors.white54
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
                                        child:  const Text(
                                          "Change",
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
                                            Text("Qty: $quan",
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
                                            children: const [
                                              Text("Delivery Charges",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text("Free",
                                                style: TextStyle(
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
                                                fontWeight: FontWeight.normal,
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
                                              color: Colors.amber,
                                            ),
                                            borderRadius: BorderRadius
                                                .circular(5)
                                        ),
                                        child: TextButton(
                                            style: TextButton
                                                .styleFrom(
                                              backgroundColor: Colors
                                                  .amber,
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
                                              //openCheckout(context,total,name,FirebaseAuth.instance.currentUser!.phoneNumber);
                                              //payment(context);
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
                  ],
                )
            ),
            OverlayContainer(
              show: _dropdownShown,
              position: const OverlayContainerPosition(
                // Left position.
                  0,380
                // Bottom position.
              ),
              // The content inside the overlay.
              child: Container(
                  height: 400,
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
                              )
                            ],
                          )
                      ),
                      SizedBox(
                        height: 350,
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
                                                  context, MaterialPageRoute(builder: (context) =>  AddressFormAdd()
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
                                                    color: Colors.amber,
                                                  ),
                                                  Text("Add Address",
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.amber,
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
                                          physics: BouncingScrollPhysics(),
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
        ),
      )
    );
  }

  void payment( paymentId) {
    List _pid=[],quantity=[],sizes=[];
    _pid.add(pid);
    quantity.add(quan);
    sizes.add(size);
    String  orderId='';
    var now = DateTime.now();
    var formatterTime = DateFormat('hh:mm a');
    String actualTime = formatterTime.add_d().add_yMMM().format(now);
    print(actualTime);
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
         // "pay_state":,

          //"product_state":
        }).whenComplete(() => {
        deleteRef.collection(FirebaseAuth.instance.currentUser!.uid).doc(pid).delete(),
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
            "userID":FirebaseAuth.instance.currentUser!.uid,
            "pay_state":"",
            "product_state":""
          })

    }).whenComplete(() =>  {
      print("_________Thankyou  Page_______________after Order Create_____________"),

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
