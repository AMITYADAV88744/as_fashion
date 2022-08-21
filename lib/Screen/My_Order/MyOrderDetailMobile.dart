
import 'package:as_fashion/Screen/My_Order/My_Order_Page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../components/OrderStepStatus.dart';
import '../../model/product_model.dart';
import '../MyShoppingCart/MyCartPage.dart';
import '../MyWishListPage.dart';
import '../ProductDetail/product_details.dart';

class MyOrderDetailMobile extends StatelessWidget {

  final String orderid;
    MyOrderDetailMobile(this.orderid,{Key? key}) : super(key: key);



   late List pid=[],quan=[],size=[];
  late ProductModel _productModel;

  /// Order database
  final orderRef=FirebaseFirestore.instance.collection("Orders").doc(FirebaseAuth.instance.currentUser?.uid)
      .collection(FirebaseAuth.instance.currentUser!.uid);

  ///Product
  final DatabaseReference dbRef =
  FirebaseDatabase.instance.reference().child('Products');

  @override
  Widget build(BuildContext context) {

    print("_______________My_Order_Detail______________");
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
          onPressed:(){
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const MyOrderPage()
            ));
          },
          icon:  const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        title: const Text('Orders Detail',
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
      body:StreamBuilder(
          stream: orderRef.doc(orderid).snapshots(),
          builder: (context,AsyncSnapshot<DocumentSnapshot>snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }
            if(snapshot.connectionState==ConnectionState.active){
             var name=snapshot.data!.get("name");
             var phone=snapshot.data!.get("phone");
             var flatno=snapshot.data!.get("flatno");
             var address=snapshot.data!.get("address");
             var locality=snapshot.data!.get("landmark");
             var pincode=snapshot.data!.get("pincode");
             var city=snapshot.data!.get("city");
             var state=snapshot.data!.get("state");
              pid=snapshot.data?.get("pid");
              print(pid.length);
             if(pid.length>1){

              var image=snapshot.data?.get("image");

               quan=snapshot.data?.get("quantity");
               size=snapshot.data?.get("size");

              return ListView(
                shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  // mainAxisAlignment: MainAxisAlignment.start,
                   //crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Container(
                       width: MediaQuery.of(context).size.width,
                       height: 50,
                       padding: const EdgeInsets.all(15),
                       decoration: BoxDecoration(
                           border: Border.all(
                             color: Colors.white
                           ),
                           borderRadius: BorderRadius.circular(1)
                       ),
                       child:Text(
                           "Order ID : $orderid",
                         style: const TextStyle(
                           color: Colors.grey,
                         ),
                       ),
                     ),
                     const Padding(padding: EdgeInsets.all(3)),
                     SizedBox(
                       width: MediaQuery.of(context).size.width-2,
                       child: ListView.builder(
                           shrinkWrap: true,
                           itemCount: pid.length,
                           itemBuilder: (context, index) {
                             return  FutureBuilder(
                                 future:dbRef.child(pid[index]).get() ,
                                 builder: (context,AsyncSnapshot<DataSnapshot> snapshot){
                                   if(snapshot.hasData){
                                     _productModel=ProductModel.fromJson(snapshot.data!.value);
                                     return GestureDetector(
                                       onTap: (){

                                         Navigator.push(
                                             context,
                                             MaterialPageRoute(
                                                 builder: (context) =>  ProductDetails(pid[index],"Product Detail")));

                                       },
                                       child: Card(
                                         elevation: 1,
                                         /* decoration: BoxDecoration(
                                           border: Border.all(
                                               color: Colors.grey
                                           ),
                                           borderRadius: BorderRadius.circular(1)
                                       ),
                                       height: 130,
                                       width: MediaQuery.of(context).size.width,
                                       padding: const EdgeInsets.fromLTRB(20,20,0,5),
                                       */
                                         child: Row(
                                           mainAxisAlignment: MainAxisAlignment.start,
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children:  [
                                             Image.network(_productModel.image[0],
                                               height: 90,
                                               width: 90,
                                               fit: BoxFit.fill,
                                             ),
                                             const Padding(padding: EdgeInsets.all(10)),
                                             Column(
                                               // mainAxisAlignment: MainAxisAlignment.start,
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children:  [
                                                 Text(_productModel.pname,
                                                   style: const TextStyle(
                                                       fontWeight: FontWeight.bold,
                                                       color: Colors.black,
                                                       fontSize: 15
                                                   ),
                                                 ),
                                                 const Padding(padding: EdgeInsets.only(top: 8)),
                                                 Text(_productModel.brand,
                                                   style: const TextStyle(
                                                       fontWeight: FontWeight.bold,
                                                       color: Colors.grey,
                                                       fontSize: 12
                                                   ),
                                                 ),
                                                 const Padding(padding: EdgeInsets.only(top: 8)),
                                                 Row(
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   children:  [
                                                     Text("Qty : ${quan[index]}",
                                                       style:const TextStyle(
                                                           fontSize: 12,
                                                           color: Colors.grey
                                                       ),
                                                     ),
                                                     const VerticalDivider(
                                                       thickness: 5,
                                                       width: 5,
                                                       indent: 2,
                                                       color: Colors.black,
                                                     ),
                                                     Text("Size : ${size[index]}",
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
                                     );
                                   }
                                   return const SizedBox();
                                 }
                             );
                           }
                       ),
                     ),
                     Card(
                       color: Colors.white,
                       elevation: 1,
                       child: Padding(
                         padding: const EdgeInsets.all(15),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment: MainAxisAlignment.start,
                           children:  [
                             const Text(
                               "Order Tracking",
                               style: TextStyle(
                                   fontSize: 15,
                                   color: Colors.black,
                                   fontWeight: FontWeight.bold
                               ),
                             ),
                             const Padding(padding: EdgeInsets.all(10)),
                             OrderStepStatus(orderid),

                           ],
                         ),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(5),
                       child: Container(
                         width: MediaQuery.of(context).size.width,
                         height: 150,
                         padding: const EdgeInsets.all(15),
                         decoration: BoxDecoration(
                             border: Border.all(
                                 color: Colors.grey
                             ),
                             borderRadius: BorderRadius
                                 .circular(5)
                         ),
                         child: ListView(
                           shrinkWrap: true,
                           children: [
                            const Text("Shipping Detail: ",
                             style:TextStyle(
                               fontWeight: FontWeight.bold
                             ),
                             ),
                          const Padding(padding: EdgeInsets.all(10)),
                           Text(name,
                             style:const TextStyle(
                               fontWeight: FontWeight.w500,
                               color: Colors.grey
                             ),
                             ),
                             Text(flatno+" "+address+" "+locality+"\n "+city+" "+state+" "+pincode +" "+phone,
                               maxLines: 4,
                               style:const TextStyle(
                                 color: Colors.grey,
                                 fontWeight: FontWeight.w500,
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ],
               );
             }
             else{

               var image=snapshot.data?.get("image");
               quan=snapshot.data?.get("quantity");
               size=snapshot.data?.get("size");

               return ListView(
                 shrinkWrap: true,
                 physics: const BouncingScrollPhysics(),
                 children: [
                   Container(
                     width: MediaQuery.of(context).size.width,
                     height: 50,
                     padding: const EdgeInsets.all(15),
                     decoration: BoxDecoration(
                         border: Border.all(
                             color: Colors.white
                         ),
                         borderRadius: BorderRadius.circular(1)
                     ),
                     child:Text(
                       "Order ID : $orderid",
                       style: const TextStyle(
                         color: Colors.grey,
                       ),
                     ),
                   ),
                   const Padding(padding: EdgeInsets.all(3)),
                   SizedBox(
                     width: MediaQuery.of(context).size.width-2,
                     child: ListView.builder(
                         shrinkWrap: true,
                         itemCount: pid.length,
                         itemBuilder: (context, index) {
                           return  FutureBuilder(
                               future:dbRef.child(pid[index]).get() ,
                               builder: (context,AsyncSnapshot<DataSnapshot> snapshot){
                                 if(snapshot.hasData){
                                   _productModel=ProductModel.fromJson(snapshot.data!.value);
                                   return GestureDetector(
                                     onTap: (){

                                       Navigator.push(
                                           context,
                                           MaterialPageRoute(
                                               builder: (context) =>  ProductDetails(pid[index],"Product Detail")));

                                     },
                                     child: Card(
                                       elevation: 1,

                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.start,
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children:  [
                                           Image.network(_productModel.image[0],
                                             height: 90,
                                             width: 90,
                                             fit: BoxFit.fill,
                                           ),
                                           const Padding(padding: EdgeInsets.all(10)),
                                           Column(
                                             // mainAxisAlignment: MainAxisAlignment.start,
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children:  [
                                               Text(_productModel.pname,
                                                 style: const TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     color: Colors.black,
                                                     fontSize: 15
                                                 ),
                                               ),
                                               const Padding(padding: EdgeInsets.only(top: 8)),
                                               Text(_productModel.brand,
                                                 style: const TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     color: Colors.grey,
                                                     fontSize: 12
                                                 ),
                                               ),
                                               const Padding(padding: EdgeInsets.only(top: 8)),
                                               Row(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children:  [
                                                   Text("Qty : ${quan[index]}",
                                                     style:const TextStyle(
                                                         fontSize: 12,
                                                         color: Colors.grey
                                                     ),
                                                   ),
                                                   const VerticalDivider(
                                                     thickness: 5,
                                                     width: 5,
                                                     indent: 2,
                                                     color: Colors.black,
                                                   ),
                                                   Text("Size : ${size[index]}",
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
                                   );
                                 }
                                 return const SizedBox();
                               }
                           );
                         }
                     ),
                   ),
                   Card(
                       color: Colors.white,
                       elevation: 1,
                       child: Padding(
                         padding: const EdgeInsets.all(15),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment: MainAxisAlignment.start,
                           children:  [
                             const Text(
                               "Order Tracking",
                               style: TextStyle(
                                   fontSize: 15,
                                   color: Colors.black,
                                   fontWeight: FontWeight.bold
                               ),
                             ),
                             const Padding(padding: EdgeInsets.all(10)),
                             OrderStepStatus(orderid),
                           ],
                         ),
                       ),
                   ),
                   Padding(
                     padding: const EdgeInsets.all(0),
                     child: Card(
                       elevation: 2,
                     color: Colors.white,
                     /*  width: MediaQuery.of(context).size.width,
                       height: 150,
                       padding: const EdgeInsets.all(15),
                       decoration: BoxDecoration(
                         color: Colors.white,
                           border: Border.all(
                             color: Colors.white,

                           ),
                           borderRadius: BorderRadius.circular(10),
                       ),
                       
                      */
                       child: Padding(
                         padding: EdgeInsets.all(15),
                         child: ListView(
                           shrinkWrap: true,
                           children: [
                             const Text("Shipping Detail: ",
                               style:TextStyle(
                                   fontWeight: FontWeight.bold
                               ),
                             ),
                             const Padding(padding: EdgeInsets.all(10)),
                             Text(name,
                               style:const TextStyle(
                                   fontWeight: FontWeight.w500,
                                   color: Colors.grey
                               ),
                             ),
                             Text(flatno+" "+address+" "+locality+"\n "+city+" "+state+" "+pincode +"\n "+phone,
                               maxLines: 4,
                               style:const TextStyle(
                                 color: Colors.grey,
                                 fontWeight: FontWeight.w500,
                               ),
                             ),
                           ],
                         ),
                       )
                     ),
                   ),
                 ],
               );
             }
            }
            return const SizedBox();
          }
          ),
    );
  }
}
