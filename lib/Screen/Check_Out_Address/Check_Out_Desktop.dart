
import 'dart:math';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../payments.dart';
import '../BillingPage/ThankyouPage.dart';
import '../LandingPage/LandingPage.dart';

class CheckOutDesktop extends StatefulWidget {
  final String pid,size; ///intent value

  CheckOutDesktop(this.pid,this.size,{Key? key}) : super(key: key);

  @override
  State<CheckOutDesktop> createState(){

    return _CheckOutDesktopState(this.pid,this.size);
  }

}

class _CheckOutDesktopState extends State<CheckOutDesktop> {
  var image;


  _CheckOutDesktopState(this.pid,this.size); ///intent value

  final String pid,size; ///intent value

  var quan=1,discount=50, total=0;
  String? phone = FirebaseAuth.instance.currentUser?.phoneNumber;
  bool phoneexit = true;
  var flag=0;


  TextEditingController nameController = TextEditingController(); // initialize the controller
  TextEditingController phoneController =TextEditingController(); // initialize the controller
  TextEditingController flatnoController=TextEditingController(); // initialize the controller
  TextEditingController landmarkController= TextEditingController(); // initialize the controller
  TextEditingController addressController=TextEditingController(); // initialize the controller
  TextEditingController cityController = TextEditingController(); // initialize the controller
  TextEditingController stateController =TextEditingController();// initialize the controller
  TextEditingController pinController =TextEditingController();// initialize the controller

  /// Product Database
  final DatabaseReference productRef = FirebaseDatabase.instance.reference().child('Products');

  /// Order Database
  var order_ref= FirebaseFirestore.instance.collection("Orders").doc(FirebaseAuth.instance.currentUser?.uid.toString());

  /// Address Database
  var addref= FirebaseFirestore.instance.collection("Address").doc(FirebaseAuth.instance.currentUser?.uid.toString());

  /// User Database
  var user= FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid.toString()).snapshots();


  @override
  Widget build(BuildContext context) {
    GroupController controller = GroupController(initSelectedItem: [2]);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>  LandingPage("Title")));
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.grey,
            ),
          ),
          title: const Text('Address',
            style: TextStyle(
                color: Colors.black
            ),
          ),
        ),
        body:
        Container(
          padding: const EdgeInsets.fromLTRB(50, 10, 10, 0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:  [
              Expanded( //<-- Expanded widget
                  child:SizedBox(
                    width: MediaQuery.of(context).size.width/3,
                    child: StreamBuilder(
                      stream: addref.snapshots(includeMetadataChanges: true),
                      builder: (context,AsyncSnapshot<DocumentSnapshot>snapshot){
                        if(snapshot.connectionState==ConnectionState.waiting){
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data!.data().toString().contains("address") !=false)  {
                          user.forEach((element) {
                            nameController.text=element.get("name");
                          });
                          phoneController.text=FirebaseAuth.instance.currentUser!.phoneNumber.toString();
                          flatnoController.text=snapshot.data?.get("flatno");
                          addressController.text=snapshot.data?.get("address");
                          cityController.text=snapshot.data?.get("city");
                          stateController.text=snapshot.data?.get("state");
                          landmarkController.text=snapshot.data?.get("landmark");
                          pinController.text=snapshot.data?.get("pincode");

                          return Padding(
                            padding: const EdgeInsets.all(40),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.only(top: 25),
                                color: Colors.white,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height / 1,
                                child: ListView(
                                  padding: const EdgeInsets.all(25),
                                  shrinkWrap: true,
                                  children: [

                                    TextField(
                                      controller: nameController,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.cyan
                                          ),
                                        ),
                                        labelText: "NAME",
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(15)),
                                    TextField(
                                      enabled: phone == null ?
                                      phoneexit : false,
                                      controller: phoneController,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.cyan
                                          ),
                                        ),
                                        labelText: "CONTACT NO",
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(15)),
                                    TextField(
                                      controller: flatnoController,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.cyan
                                          ),
                                        ),
                                        labelText: "HOUSE No. / FLAT No",
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(15)),
                                    TextField(
                                      controller: addressController,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.cyan
                                          ),
                                        ),
                                        labelText: "ADDRESS",
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(15)),
                                    TextField(
                                      controller: pinController,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.cyan
                                          ),
                                        ),
                                        labelText: "PIN-CODE",
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(10)),

                                    TextField(

                                      controller: cityController,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.cyan
                                          ),
                                        ),
                                        labelText: "CITY",
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(10)),
                                    TextField(

                                      controller: stateController,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.cyan
                                          ),
                                        ),
                                        labelText: "STATE",
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        if (snapshot.data!.data().toString().contains("address") !=true) {
                          user.forEach((element) {
                            nameController.text=element.get("name");
                            phoneController.text=element.get("phone");
                          });
                          return Padding(
                            padding: const EdgeInsets.all(40),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.only(top: 25),
                                color: Colors.white,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height / 1,
                                child: ListView(
                                  padding: const EdgeInsets.all(25),
                                  shrinkWrap: true,
                                  children: [

                                    TextField(
                                      controller: nameController,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.cyan
                                          ),
                                        ),
                                        labelText: "NAME",
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(15)),
                                    TextField(
                                      enabled: phone == null ?
                                      phoneexit : false,
                                      controller: phoneController,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.cyan
                                          ),
                                        ),
                                        labelText: "CONTACT NO",
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(15)),
                                    TextField(
                                      controller: flatnoController,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.cyan
                                          ),
                                        ),
                                        labelText: "HOUSE No. / FLAT No",
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(15)),
                                    TextField(
                                      controller: addressController,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.cyan
                                          ),
                                        ),
                                        labelText: "ADDRESS",
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(15)),
                                    TextField(
                                      controller: pinController,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.cyan
                                          ),
                                        ),
                                        labelText: "PIN-CODE",
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(10)),

                                    TextField(

                                      controller: cityController,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.cyan
                                          ),
                                        ),
                                        labelText: "CITY",
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(10)),
                                    TextField(

                                      controller: stateController,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(15),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.cyan
                                          ),
                                        ),
                                        labelText: "STATE",
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  )
              ),
              Expanded( //<-- Expanded widget
                child:Padding(
                  padding: const EdgeInsets.fromLTRB(35,35,35,5),
                  child: FutureBuilder(
                    future:productRef.child(pid).get() ,
                    builder: (context,AsyncSnapshot<DataSnapshot>snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }if(snapshot.hasData){

                        image = snapshot.data?.value['image'][0];
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
                              height: 210,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(25),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  Image.network(image,
                                    height: 170,
                                    width: 140,
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
                                            fontSize: 20
                                        ),
                                      ),
                                      const Padding(padding: EdgeInsets.only(top: 8)),
                                      Text(brand,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                            fontSize: 18
                                        ),
                                      ),
                                      const Padding(padding: EdgeInsets.all(15)),
                                      Text("Size : $size",
                                        style:const TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey
                                        ),
                                      ),
                                      const Padding(padding: EdgeInsets.only(top: 20)),
                                      Row(
                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children:  [
                                          Text("Price : $price",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey
                                            ),
                                          ),
                                          const Padding(padding: EdgeInsets.only(left: 25)),
                                          Text("Quan: $quan",
                                            style: const TextStyle(
                                                fontSize: 18,
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

                            //Price Summaryy
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
                              padding: const EdgeInsets.fromLTRB(25,5,0,5),
                              color: Colors.grey,
                              height: 35,
                              width: MediaQuery.of(context).size.width,
                              child: const Text("Select Payment Mode",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 15
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(25,5,10,5),
                              height: 100,
                              width: MediaQuery.of(context).size.width/2,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey
                                  ),
                                  borderRadius: BorderRadius
                                      .circular(1)
                              ),
                              child:StatefulBuilder(
                                builder: (context, setState) {
                                 return SimpleGroupedCheckbox<int>(
                                   controller: controller,
                                   //groupTitle:"Basic",
                                   onItemSelected: (data) {
                                     print(data);
                                     if (data == 1) {
                                       setState(() {
                                         flag=0;
                                       });
                                       //controller.disabledItemsByTitles(["Cash on Delivery"]);
                                       controller.enabledItemsByTitles(["Online Payment Method"]);

                                     } else if (data == 2) {
                                       setState(() {
                                         flag=1;
                                       });
                                       controller.enabledItemsByTitles([ "Cash on Delivery"]);
                                       //controller.disabledItemsByTitles(["Online Payment Method"]);
                                     }
                                   },
                                   itemsTitle: const ["Online Payment Method", "Cash on Delivery",],
                                   values: const [1, 2,],
                                   groupStyle: GroupStyle(
                                       activeColor: Colors.amber,
                                       itemTitleStyle: const TextStyle(fontSize: 13)),
                                   checkFirstElement: false,
                                 );
                                },
                              )
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
                                              fontSize: 15
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
                                      width: 250,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          border: Border.all(),
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
                                           // print(flag);
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
                ),

              ),
            ],
          ),
        )
    );
  }


  void payment(context) {
    print( "Flag $flag");
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
    if(flag==1){
       pstate='COD';
    }else{
      pstate='Online';

    }
    orderRef.collection(FirebaseAuth.instance.currentUser!.uid.toString()).doc(orderId).set(
        {
          "or_dtime":actualTime,
          "payment":"paymentId",
          "name":nameController.text.trim(),
          "phone":FirebaseAuth.instance.currentUser!.phoneNumber,
          "flatno":flatnoController.text.trim(),
          "address":addressController.text.trim(),
          "city":cityController.text.trim(),
          "landmark":landmarkController.text.trim(),
          "state":stateController.text.trim(),
          "pincode":pinController.text.trim(),
          "pid":_pid,
          "order_no":orderId,
          "size":sizes,
          "color":"",
          "quantity":quantity,
          "image":image,
          "or_status": "placed",
           "pay_state":pstate,

          //"product_state":
        }).whenComplete(() => {
      deleteRef.collection(FirebaseAuth.instance.currentUser!.uid).doc(pid).delete(),
      adminOrder.doc(orderId).set(
          {
            "or_dtime":actualTime,
            "payment":"",
            "name":nameController.text.trim(),
            "phone":FirebaseAuth.instance.currentUser!.phoneNumber,
            "flatno":flatnoController.text.trim(),
            "address":addressController.text.trim(),
            "city":cityController.text.trim(),
            "landmark":landmarkController.text.trim(),
            "state":stateController.text.trim(),
            "pincode":pinController.text.trim(),
            "pid":_pid,
            "order_no":orderId,
            "size":sizes,
            "color":"",
            "quantity":quantity,
            "image":image,
            "or_status": "Pending",
            "userID":FirebaseAuth.instance.currentUser!.uid,
            "pay_state":pstate,
            "product_state":""
          })

    }).whenComplete(() =>  {

      if(flag==1){
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const ThankYouPage())),

      }else if(flag==0){
        print("_________Thankyou  Page_______________after Order Create_____________"),
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Webpayment(name: nameController.text.trim(),price:total, orderId: orderId,)))

      }

    });

  }
}
