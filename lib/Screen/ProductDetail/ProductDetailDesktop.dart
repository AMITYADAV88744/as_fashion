
import 'package:as_fashion/Screen/LoginPage/Login_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../components/header.dart';
import '../Check_Out_Address/Check_Out_Page.dart';

class ProductDetailsDesktop extends StatefulWidget {
  String pid;
   ProductDetailsDesktop( this.pid, {Key? key}) : super(key: key);

  @override
  State<ProductDetailsDesktop> createState(){
    return _ProductDetailsDesktopState(this.pid);

  }
}

class _ProductDetailsDesktopState extends State<ProductDetailsDesktop> {
  String pid;

  var image,brand,pname,color;
  late int price;

  _ProductDetailsDesktopState(this.pid);

  final DatabaseReference dbRef =
  FirebaseDatabase.instance.reference().child('Products').child("Male");
  late List<String> sizes = ["S", "M", "L", "XL"];
  late String selectedSize="M";
  late  bool isSelected=false;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Header(),
              const Padding(padding: EdgeInsets.zero),
              FutureBuilder(
                future: dbRef.child(pid).get(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {

                  if (snapshot.hasData) {
                    //retrieve data
                     image = snapshot.data?.value['image'];
                     brand = snapshot.data?.value['brand'];
                     pname = snapshot.data?.value['pname'];
                     price = snapshot.data?.value['price'];
                     color = snapshot.data?.value['color'];
                    //var size = snapshot.data?.value['size'];



                    return Container(
                      padding: const EdgeInsets.fromLTRB(50, 10, 10, 0),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded( //<-- Expanded widget
                            child: Container(
                              height: 550,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.network(image,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Expanded( //<-- Expanded widget
                              child: SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2,
                                child: ListView(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(25),

                                        color: Colors.white,
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Text(brand,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(5),),
                                            Text(pname,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black54,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(5),),
                                            Row(
                                              children: [
                                                Text(price.toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(4),),
                                                const Text('70% OFF',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight
                                                        .normal,
                                                    color: Colors.green,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Text('inclusive of all taxes',
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black54,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Padding(padding: EdgeInsets.all(2)),
                                      Container(
                                        height: 360,
                                        padding: const EdgeInsets.all(25),
                                        color: Colors.white,
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            const Text('COLOUR OPTION',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                            StatefulBuilder(builder: (context, StateSetter setstate){
                                              return Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Material(
                                                      child: InkWell(
                                                        borderRadius: BorderRadius.circular(3),
                                                        onTap: (){
                                                          setState(() {
                                                          });

                                                        },
                                                        child: Container(
                                                          margin: const EdgeInsets.only(
                                                            top: 20 / 4,
                                                            right: 20 / 2,
                                                          ),
                                                          padding: const EdgeInsets.all(2.5),
                                                          height: 30,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            border: Border.all(
                                                              color: isSelected ? Color(0xFF356C95) : Colors.transparent,
                                                            ),
                                                          ),
                                                          child: const DecoratedBox(
                                                            decoration: BoxDecoration(
                                                              color: Colors.redAccent,
                                                              shape: BoxShape.circle,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ]
                                              );

                                            }
                                            ),
                                            const Padding( padding: EdgeInsets.all(5)),
                                            const Padding(
                                                padding: EdgeInsets.all(20)),
                                            const Text('SELECT SIZE',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.all(12)),
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
                                                              height: 50,
                                                              width: 50,
                                                              decoration: BoxDecoration(
                                                                  color: selectedSize == sizes[index]
                                                                      ? Color(0xFF667EEA)
                                                                      : Color(0xFFF3F3F3),
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
                                            const Padding(
                                                padding: EdgeInsets.all(15)),
                                            Row(
                                                children: [
                                                  Container(
                                                    width: 170,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .blueAccent),
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
                                                                  .white),
                                                        ),
                                                        child: const Text(
                                                          'ADD TO CART ',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                              fontSize: 20,
                                                              color: Colors
                                                                  .white
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          addtocart(context,pid,selectedSize);
                                                        }
                                                    ),
                                                  ),
                                                  const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10)),
                                                  Container(
                                                    width: 140,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .black),
                                                        borderRadius: BorderRadius
                                                            .circular(5)
                                                    ),
                                                    child: TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor: Colors
                                                              .white,
                                                          textStyle: const TextStyle(
                                                              color: Colors
                                                                  .black
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          'BUY NOW',
                                                          style: TextStyle(
                                                              fontWeight: FontWeight
                                                                  .bold,
                                                              fontSize: 20,
                                                              color: Colors
                                                                  .black
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          check_add(
                                                              context, pid,selectedSize);
                                                        }
                                                    ),
                                                  ),
                                                ]
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]
                                ),
                              )
                          ),
                        ],
                      ),
                    );

                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )

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
    var quan;


    cartRef.doc(pid).get().then((docData) => {
      if (docData.exists) {
        quan=docData.get("quantity"),
        quan=quan+1,
        cartRef.doc(pid).update({"quantity":quan
        }),
        print("quantity update")

      } else {
        // document does not exist (only on online)
        cartRef.doc(pid).set(
            {
              "pid":pid,
              "size":size,
              "quantity":1,
              "image":image,
              "brand":brand,
              "pname":pname,
              "price":price
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



  void check_add(context, _pid, selectedSize) {
    var size=selectedSize;
    var pid = _pid;
    print(size);
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginScreen()));
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context)=> Check_Out_Page(pid,size))
      );
    }

  }
}
