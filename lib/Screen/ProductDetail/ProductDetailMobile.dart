


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:color_parser/color_parser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../components/CustomSearch.dart';
import '../../components/extenstion.dart';
import '../../model/product_model.dart';
import '../Check_Out_Address/Check_Out_Page.dart';
import '../LandingPage/LandingPage.dart';
import '../LoginPage/Login_Screen.dart';
import '../MyShoppingCart/MyCartPage.dart';
import '../MyWishListPage.dart';

class ProductDetailsMobile extends StatefulWidget {
  String pid,titles;
  ProductDetailsMobile( this.titles,this.pid, {Key? key}) : super(key: key);

  @override
  State<ProductDetailsMobile> createState(){
    return _ProductDetailsMobileState(this.pid,this.titles);

  }
}

class _ProductDetailsMobileState extends State<ProductDetailsMobile> {
   String pid,titles;

  _ProductDetailsMobileState(this.pid,this.titles);

  final DatabaseReference dbRef =
  FirebaseDatabase.instance.reference().child('Products');
  late List<String> sizes = ["S", "M", "L", "XL"];
  late String selectedSize="";
  late  bool isSelected=false;


 late ProductModel _productModel;
 List<String> colname=[];

   @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(pid);
      print("_______Product detail_________");
    }
    return Scaffold(
       backgroundColor:const Color.fromARGB(232,232,232,232),
        appBar: AppBar(
          leading:IconButton(
            onPressed:(){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) =>  LandingPage(titles)
              ));
            },
            icon:const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: const Text('Product Detail',style: TextStyle(color: Colors.black),),
          actions: [
            Row(
              children: [
                IconButton(
                    onPressed:(){
                      showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(),
                      );},
                    icon: const Icon(Icons.search_sharp,
                      color: Colors.black,
                    )
                ),
                FirebaseAuth.instance.currentUser !=null ?
                IconButton(onPressed:(){
                  Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context) =>  const MyWishListPage()));
                },
                    icon: const Icon(Icons.favorite_outlined,
                      color: Colors.black,
                    )
                ):IconButton(onPressed:(){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) =>
                  const LoginScreen()));},
                    icon: const Icon(Icons.favorite_outlined,
                      color: Colors.black,
                    )
                ),

                /// Cart
                FirebaseAuth.instance.currentUser !=null ?
                IconButton(onPressed:(){
                  Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context) =>  const MyCartPage()));
                },
                    icon: const Icon(Icons.shopping_bag_sharp,
                      color: Colors.black,
                    )
                ):IconButton(onPressed:(){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) =>
                  const LoginScreen()));
                },
                    icon: const Icon(Icons.shopping_bag_sharp,
                      color: Colors.black,
                    )
                ),
              ],
            )
          ],
        ),

        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: FutureBuilder(
                future: dbRef.child(pid).get(),
                builder:(context ,AsyncSnapshot<DataSnapshot> snapshot){

                  if(snapshot.hasData){

                    _productModel=ProductModel.fromJson(snapshot.data!.value);

                    colname.clear();
                    List sizes=_productModel.size;
                    List<Color> col=[];
                    ColorParser parser;
                    for(int i=0;i<_productModel.color.length;i++){
                      col.add(HexColor.fromHex(_productModel.color[i]));
                      colname.add(ColorParser.hex(_productModel.color[i]).toName().toString());
                    }

                    parser = ColorParser.hex(_productModel.color[0]);


                    return ListView(
                         shrinkWrap: true,
                         padding: const EdgeInsets.all(5),
                         physics: const ScrollPhysics(),
                        children: [
                          _productModel.stock_qty==0?
                          Container(
                            child: Stack(
                              children: <Widget>[
                                Image.network(_productModel.image[0],), //This
                                // should be a paged
                                // view.
                                Positioned(
                                  bottom: 0,
                                  right: 20,
                                  child:FloatingActionButton(
                                      elevation: 2,
                                      backgroundColor: Colors.white,
                                      onPressed: (){},
                                      child: const Icon(
                                        Icons.favorite_outline,
                                        color: Colors.red,
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ):
                          Container(
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: <Widget>[
                                Image.network(
                                  _productModel.image[0],
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fitWidth,
                                ),
                                Positioned(
                                  top: 10,
                                  right: 20,
                                  child: SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: FloatingActionButton(
                                        elevation: 2,
                                        backgroundColor: Colors.white,
                                        onPressed: (){
                                          _wishList();

                                        },
                                        child: const Icon(
                                          Icons.favorite_outline,
                                          color: Colors.red,
                                        )
                                    ),
                                  )
                                ),
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(2)),
                          Container(
                            padding: const EdgeInsets.all(15),
                            color: Colors.white,
                            child:ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                Text(_productModel.brand,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                               // const Padding(padding: EdgeInsets.all(5),),
                                Text(_productModel.pname,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                                //const Padding(padding: EdgeInsets.all(5),),
                                Row(
                                  children:  [
                                    Text(_productModel.price.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(4),),
                                    Text(_productModel.l_price.toString(),
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.all(4),),
                                    Text('${_productModel.discount}% OFF',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.amber,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const Text('inclusive of all taxes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(2)),
                          ///   Color and Size  Option   ////////////////////////////////////////////////////////////////
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(10),
                            color: Colors.white,
                            child: ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                const Text('Colour Option',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                StatefulBuilder(builder: (context, StateSetter setstate){
                                  return Row(
                                    children: List.generate(
                                        col.length,
                                            (index) =>
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Material(
                                                child: InkWell(
                                                    borderRadius: BorderRadius.circular(3),
                                                    onTap: (){
                                                      setState(() {
                                                        // selectedSize=sizes[index];
                                                        //print(selectedSize);
                                                      });

                                                    },
                                                    child:Container(
                                                      width: 35,
                                                      height: 35,
                                                      padding: const EdgeInsets.all(12),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: col[index]),
                                                        shape: BoxShape.circle,
                                                        color: col[index],
                                                      ),
                                                    )
                                                ),
                                              ),
                                            )
                                    ),
                                  );
                                }
                                ),
                                const Padding(padding: EdgeInsets.all(8)),
                                const Text('Available Size',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.all(8)),
                                StatefulBuilder(builder: (context, StateSetter setstate){
                                  return Row(
                                    children: List.generate(
                                        sizes.length,
                                            (index) =>
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Material(
                                                child: InkWell(
                                                  borderRadius: BorderRadius.circular(3),
                                                  onTap: (){
                                                    setState(() {
                                                      selectedSize=sizes[index];
                                                      //print(selectedSize);
                                                    });

                                                  },
                                                  child: Ink(
                                                    height: 35,
                                                    width: 35,
                                                    decoration: BoxDecoration(
                                                        color: selectedSize == sizes[index]
                                                            ?  Colors.amber
                                                            : const Color(0xFFF3F3F3),
                                                        borderRadius: BorderRadius.circular(3)),
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        sizes[index],
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .headline6
                                                            ?.copyWith(
                                                            color: selectedSize == sizes[index]
                                                                ? Colors.white
                                                                : Colors.black87),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                    ),
                                  );
                                }
                                ),
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(2)),
                          ///   Product detail   ////////////////////////////////////////////////////////////////
                          ///
                         // ProductAddtionalDetail(pid),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 450,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15,15,70,15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Product Details",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.all(15)),
                                  _productModel.subcategory=="Shirts"?shirt():t_shirt(),
                                  const Padding(padding: EdgeInsets.only(top: 20)),
                                  const Text("Details",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(_productModel.discrip,
                                    maxLines: 4,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ]
                    );
                  }
                  return const CircularProgressIndicator();
                },
              )
            ),
        ),
        bottomSheet: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white
                      ),
                      borderRadius: BorderRadius
                          .circular(0)
                  ),
                  child: TextButton(
                      style: TextButton
                          .styleFrom(
                        backgroundColor: Colors.white,
                        textStyle: const TextStyle(
                            color: Colors
                                .white),
                      ),
                      child: const Text(
                        'ADD TO CART ',
                        style: TextStyle(
                            fontWeight: FontWeight
                                .bold,
                            fontSize: 18,
                            color: Colors
                                .black
                        ),
                      ),
                      onPressed: () {
                        addtocart(context,pid,selectedSize);
                      }
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.amber
                      ),
                      borderRadius: BorderRadius
                          .circular(0)
                  ),
                  child: TextButton(
                      style: TextButton
                          .styleFrom(
                        backgroundColor: Colors
                            .amber,
                        textStyle: const TextStyle(
                            color: Colors
                                .white
                        ),
                      ),
                      child: const Text(
                        'BUY NOW',
                        style: TextStyle(
                            fontWeight: FontWeight
                                .bold,
                            fontSize: 18,
                            color: Colors
                                .black
                        ),
                      ),
                      onPressed: () {
                        checkaddress(context, pid,selectedSize);
                      }
                  ),
                ),
              ]
          ),

        ),
    );
  }
   Widget shirt() {
     return ListView(
       shrinkWrap: true,
       physics: const NeverScrollableScrollPhysics(),
       children: [

         Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children:   [
             const Text("Sleeve",
               style: TextStyle(
                   color: Colors.grey,
                   fontSize: 12,
                   fontWeight: FontWeight.bold
               ),
             ),
             Text(_productModel.sleevtyp,
               style: const TextStyle(
                   color: Colors.black,
                   fontSize: 12,
                   fontWeight: FontWeight.bold
               ),
             ),
           ],
         ),
         const Padding(padding: EdgeInsets.all(10)),
         Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children:   [
             const Text("Fabric",
               style: TextStyle(
                   color: Colors.grey,
                   fontSize: 12,
                   fontWeight: FontWeight.bold
               ),
             ),
             Text(_productModel.fabrictyp,
               style: const TextStyle(
                   color: Colors.black,
                   fontSize: 12,
                   fontWeight: FontWeight.bold
               ),
             ),
           ],
         ),
         const Padding(padding: EdgeInsets.all(10)),
         Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children:   [
             const Text("Neck Type",
               style: TextStyle(
                   color: Colors.grey,
                   fontSize: 12,
                   fontWeight: FontWeight.bold
               ),
             ),
             Text(_productModel.necktyp,
               style: const TextStyle(
                   color: Colors.black,
                   fontSize: 12,
                   fontWeight: FontWeight.bold
               ),
             ),
           ],
         ),
         const Padding(padding: EdgeInsets.all(10)),
         Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children:   [
             const Text("Pattern ",
               style: TextStyle(
                   color: Colors.grey,
                   fontSize: 12,
                   fontWeight: FontWeight.bold
               ),
             ),
             Text(_productModel.pattertyp,
               style: const TextStyle(
                   color: Colors.black,
                   fontSize: 12,
                   fontWeight: FontWeight.bold
               ),
             ),
           ],
         ),
       ],
     );
   }

   Widget t_shirt() {
     return ListView(
       shrinkWrap: true,
       physics: const NeverScrollableScrollPhysics(),
       children: [

         Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children:   [
             const Text("Sleeve",
               style: TextStyle(
                   color: Colors.grey,
                   fontSize: 12,
                   fontWeight: FontWeight.bold
               ),
             ),
             Text(_productModel.sleevtyp,
               style: const TextStyle(
                   color: Colors.black,
                   fontSize: 12,
                   fontWeight: FontWeight.bold
               ),
             ),
           ],
         ),
         const Padding(padding: EdgeInsets.all(10)),
         Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children:   [
             const Text("Fabric",
               style: TextStyle(
                   color: Colors.grey,
                   fontSize: 12,
                   fontWeight: FontWeight.bold
               ),
             ),
             Text(_productModel.fabrictyp,
               style: const TextStyle(
                   color: Colors.black,
                   fontSize: 12,
                   fontWeight: FontWeight.bold
               ),
             ),
           ],
         ),
         const Padding(padding: EdgeInsets.all(10)),
         Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children:   [
             const Text("Collar Type",
               style: TextStyle(
                   color: Colors.grey,
                   fontSize: 12,
                   fontWeight: FontWeight.bold
               ),
             ),
             Text(_productModel.necktyp,
               style: const TextStyle(
                   color: Colors.black,
                   fontSize: 12,
                   fontWeight: FontWeight.bold
               ),
             ),
           ],
         ),
         const Padding(padding: EdgeInsets.all(10)),
         Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children:   [
             const Text("Pattern ",
               style: TextStyle(
                   color: Colors.grey,
                   fontSize: 12,
                   fontWeight: FontWeight.bold
               ),
             ),
             Text(_productModel.pattertyp,
               style: const TextStyle(
                   color: Colors.black,
                   fontSize: 12,
                   fontWeight: FontWeight.bold
               ),
             ),
           ],
         ),
         const Padding(padding: EdgeInsets.all(10)),
         Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children:   [
             const Text("Color ",
               style: TextStyle(
                   color: Colors.grey,
                   fontSize: 12,
                   fontWeight: FontWeight.bold
               ),
             ),
             Text(colname.join(' , ').toString(),
               style: const TextStyle(
                   color: Colors.black,
                   fontSize: 12,
                   fontWeight: FontWeight.bold
               ),
             ),
           ],
         ),
       ],
     );
   }

   _wishList() {

     if(FirebaseAuth.instance.currentUser==null){
       ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Please Login First')));

     }else {
       var pid = _productModel.pid;
       var addWish = FirebaseFirestore.instance.collection("WishList")
           .doc(FirebaseAuth.instance.currentUser?.uid).collection(
           FirebaseAuth.instance.currentUser!.uid.toString());

       addWish.doc(pid).get().then((docData) =>
       {
         if (docData.exists) {
           addWish.doc(_productModel.pid).delete().then((value) {
             ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('Removed From Wish list')));
           })
         } else
           {
             addWish.doc(_productModel.pid).set({
               "pid": _productModel.pid,
               "image": _productModel.image,
               "pname": _productModel.pname,
               "brand": _productModel.brand,
               "price": _productModel.price
             }).then((_) {
               ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Successfully Added')));
             }).catchError((onError) {
               ScaffoldMessenger.of(context)
                   .showSnackBar(SnackBar(content: Text(onError.toString())));
             }),
           }
       });
       return null;
     }
   }
  void addtocart(context,pid,selectedSize) {

     if(FirebaseAuth.instance.currentUser==null){
       ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Please Login First')));

     }else{
       var size =selectedSize;
       var cartRef= FirebaseFirestore.instance.collection("ShoppingCart")
           .doc(FirebaseAuth.instance.currentUser?.uid.toString()).collection(FirebaseAuth.instance.currentUser!.uid);
       var quan=0;


       cartRef.doc(pid).get().then((docData) => {
         if (docData.exists) {
           quan=docData.get("quantity"),
           quan=quan+1,
           cartRef.doc(pid).update({"quantity":quan
           }),
         } else {
           cartRef.doc(pid).set(
               {
                 "pid":pid,
                 "size":size,
                 "quantity":1,
                 "image":_productModel.image,
                 "brand":_productModel.brand,
                 "pname":_productModel.pname,
                 "price":_productModel.price
                 //"product_state":
               }).then((_) {
             ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('Successfully Added')));
           }).catchError((onError) {
             ScaffoldMessenger.of(context)
                 .showSnackBar(SnackBar(content: Text(onError.toString())));
           })
         }
       });

     }
  }


  void checkaddress(context, pid, selectedSize) {
    var size=selectedSize;
    if (kDebugMode) {
      print(size);
    }
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginScreen()));
    }else{
      if (kDebugMode) {
        print("_______Checkout Buy Now_________");
      }
      checksize();
    }

  }

  void checksize(){

     if(selectedSize.isEmpty){
       ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content:
           Text('Please Select Size',
             style: TextStyle(color: Colors.black),
           ),
             backgroundColor: Colors.amber,
           )
       );

     }
     else{
       Navigator.push(context, MaterialPageRoute(builder: (context)=> Check_Out_Page(pid,selectedSize)));
     }
  }


}

