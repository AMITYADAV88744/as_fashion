


import 'package:as_fashion/Screen/ProductDetail/product_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:overlay_container/overlay_container.dart';
import '../model/product_model.dart';
import 'MainScreen/MainScreenPage.dart';


class MyWishListPage extends StatelessWidget {
  const MyWishListPage( {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return   const MyWishListMobile();
            } else if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
              return    const MyWishListMobile();
            } else {
              return   const MyWishListMobile();
            }
          },
        )
    );
  }
}


class MyWishListMobile extends StatefulWidget {
  const MyWishListMobile({
    Key? key,
  }) : super(key: key);

  @override
  State<MyWishListMobile> createState() => _MyWishListMobileState();
}
class _MyWishListMobileState extends State<MyWishListMobile> {
  var pidd='';

  late var bottom,left;



  @override

  void initState() {
    super.initState();
  }
  List<Map<dynamic, dynamic>> lists = [];

  var wishRef=FirebaseFirestore.instance.collection("WishList").doc(FirebaseAuth.instance.currentUser?.uid);

  late List<String> sizes = ["S", "M", "L", "XL"];
  late String selectedSize="";
  late  bool isSelected=false;
  bool _dropdownShown = false;
  late ProductModel _productModel;


  final DatabaseReference dbRef =
  FirebaseDatabase.instance.reference().child('Products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
         // backgroundColor: Colors.white,
          leading:IconButton(
            onPressed:(){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const MainScreenPage()
              ));
              },
            icon:const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black,
            ),
          ),
          title: const Text("My WishList",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),
          ),
        ),
        body:SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height-50,
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: wishRef.collection(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                          builder: (context, snapshot){
                            if(snapshot.connectionState==ConnectionState.active){
                              if(snapshot.hasData){
                                if(snapshot.data?.docs.isEmpty ==true){
                                  return const Center(
                                    child: Text("You Wishlist is  Empty",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 25
                                      ),
                                    ),
                                  );
                                }else{

                                  return  ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data?.docs.length,
                                      itemBuilder: (context,index){
                                        var pid =snapshot.data?.docs[index]["pid"];
                                        List image =snapshot.data?.docs[index]["image"];
                                        var pname =snapshot.data?.docs[index]["pname"];
                                        var brand =snapshot.data?.docs[index]["brand"];
                                        var price =snapshot.data?.docs[index]["price"];
                                        return Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey
                                                ),
                                                borderRadius: BorderRadius
                                                    .circular(10)
                                            ),
                                            height: 200,
                                            width: MediaQuery.of(context).size.width,
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              children: [
                                                InkWell(

                                                  onTap: (){
                                                    Navigator.pushReplacement(
                                                        context, MaterialPageRoute(builder: (context) =>  ProductDetails(pid,"Product Detail")
                                                    ));
                                                  },
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
                                                            ],
                                                          ),

                                                        ],
                                                      ),
                                                      Padding(padding: EdgeInsets.all(10)),
                                                      /*  Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children:[
                                                          const Icon(
                                                            Icons.delete,
                                                            color: Colors.white70,
                                                          ),
                                                          IconButton(onPressed: (){},
                                                              icon: const Icon(
                                                                Icons.delete,
                                                                color: Colors.grey,
                                                              )
                                                          ),
                                                        ]
                                                    )
                                                    */
                                                    ],
                                                  ),
                                                ),
                                                const Padding(padding: EdgeInsets.all(5)),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [

                                                    ElevatedButton(
                                                        onPressed: (){
                                                          setState(() {
                                                            pidd=snapshot.data?.docs[index]["pid"];
                                                            _dropdownShown = !_dropdownShown;
                                                          });
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                            fixedSize: const Size(110, 40),
                                                            primary: Colors.amber
                                                        ),
                                                        child: const Text("Add to Cart",
                                                          style: TextStyle(
                                                              color: Colors.black
                                                          ),
                                                        )
                                                    ),
                                                    const Padding(padding: EdgeInsets.all(20)),

                                                    ElevatedButton(
                                                        onPressed: (){
                                                          var addWish=FirebaseFirestore.instance.collection("WishList")
                                                              .doc(FirebaseAuth.instance.currentUser?.uid).collection(FirebaseAuth.instance.currentUser!.uid.toString());

                                                          addWish.doc(snapshot.data?.docs[index]["pid"]).delete();

                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                            fixedSize: const Size(90, 40),
                                                            primary: Colors.white70
                                                        ),
                                                        child: const Text("Remove ",
                                                          style: TextStyle(
                                                              color: Colors.black
                                                          ),
                                                        )

                                                    ),

                                                  ],
                                                )
                                              ],
                                            )
                                        );
                                      }
                                  );
                                }
                              }
                              else{
                                return const Center(
                                  child: Text("List not available",
                                    style: TextStyle(
                                        color: Colors.black
                                    ),
                                  ),
                                );
                              }
                            }
                            return const Center(
                                child: CircularProgressIndicator()
                            );

                          }
                      ),

                    ],
                  )
              ),

              OverlayContainer(
                show: _dropdownShown,
                // Let's position this overlay to the right of the button.
                position: const OverlayContainerPosition(
                  // Left position.
                    0,380
                  // Bottom position.
                ),
                // The content inside the overlay.
                child: Container(
                    height: 360,
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
                                    "Select Size",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20
                                    ),

                                  ),
                                )
                              ],
                            )
                        ),
                        FutureBuilder(
                            future: dbRef.child(pidd).get(),
                            builder:(context,AsyncSnapshot<DataSnapshot>  snapshot) {
                              if(snapshot.hasData){
                                _productModel=ProductModel.fromJson(snapshot.data!.value);

                                return  Container(
                                    height: 300,
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:  [

                                            Image.network(_productModel.image[0],
                                              height: 80,
                                              width: 70,
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
                                                      fontSize: 12
                                                  ),
                                                ),
                                                const Padding(padding: EdgeInsets.only(top: 8)),
                                                Text(_productModel.brand,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey,
                                                      fontSize: 10
                                                  ),
                                                ),
                                                const Padding(padding: EdgeInsets.all(10)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Padding(padding: EdgeInsets.all(7)),
                                        const Text('SELECT SIZE',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const Padding(padding: EdgeInsets.all(10)),
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
                                                            height: 40,
                                                            width: 40,
                                                            decoration: BoxDecoration(
                                                                color: selectedSize == sizes[index]
                                                                    ? Colors.amber
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
                                        }),
                                        const Padding(padding: EdgeInsets.all(10)),
                                        Center(
                                          child:  ElevatedButton(
                                            onPressed: (){
                                              setState(() {
                                                _dropdownShown=!_dropdownShown;

                                              });
                                              addtocart(context,pidd,selectedSize);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.amber,
                                              fixedSize: const Size(300, 40),
                                            ),
                                            child: const Text("Continue",
                                              style: TextStyle(
                                                  color: Colors.black
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                );
                              }
                              return const Center(child: CircularProgressIndicator(),);
                            })
                      ],
                    )
                ),
              ),
            ],
          ),
        )

    );
  }
  void addtocart(context,_pid,selectedSize) {
    var size =selectedSize;
    var pid=_pid;
    var cartRef= FirebaseFirestore.instance.collection("ShoppingCart")
        .doc(FirebaseAuth.instance.currentUser?.uid.toString()).collection(FirebaseAuth.instance.currentUser!.uid);
    var quan=0;


    cartRef.doc(pid).get().then((docData) => {
      if (docData.exists) {
        quan=docData.get("quantity"),
        quan=quan+1,
        cartRef.doc(pid).update({"quantity":quan
        }).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Successfully Added')));
        }).catchError((onError) async {

        ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(onError.toString())));
        }),
        print("quantity update")

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
