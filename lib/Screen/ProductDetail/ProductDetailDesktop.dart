
import 'package:as_fashion/Screen/LoginPage/Login_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:color_parser/color_parser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../components/Footer.dart';
import '../../components/extenstion.dart';
import '../../components/header.dart';
import '../../model/product_model.dart';
import '../Check_Out_Address/Check_Out_Page.dart';
import 'ProductAddtionalDetail.dart';

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

  double defaulttext=12;

  _ProductDetailsDesktopState(this.pid);

  final DatabaseReference dbRef =
  FirebaseDatabase.instance.reference().child('Products');
  late List<String> sizes = ["S", "M", "L", "XL"];
  late String selectedSize="M";
  late  bool isSelected=false;
  late ProductModel _productModel;

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
                    _productModel=ProductModel.fromJson(snapshot.data!.value);
                    List sizes=_productModel.size;
                    List<Color> col=[];
                    ColorParser parser;
                    List<String> colname=[];
                    for(int i=0;i<_productModel.color.length;i++){
                      col.add(HexColor.fromHex(_productModel.color[i]));
                      colname.add(ColorParser.hex(_productModel.color[i]).toName().toString());
                    }
                    int ima=_productModel.image.length;
                    print(ima);
                    parser = ColorParser.hex(_productModel.color[0]);
                    return Container(
                      padding: const EdgeInsets.fromLTRB(80, 70, 50, 0),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex:6,//<-- Expanded widget
                            child: Container(
                              height: 550,
                              width: 200,
                             padding:const EdgeInsets.fromLTRB(30, 30, 10, 30),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.amber),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex:3,
                                    child: SizedBox(
                                      width: 70,
                                      child: ListView(
                                        children: [
                                          Image.network(
                                            _productModel.image[0],
                                            height: 100,
                                            width: 100,
                                          ),
                                          const Padding(padding: EdgeInsets.all(2)),
                                          ima>=2?
                                         Image.network(
                                           _productModel.image[1],
                                           height: 100,
                                           width: 100,
                                         ):SizedBox(width: 10,)
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Image.network(
                                      _productModel.image[0],
                                    // fit: BoxFit.fill,
                                    ),
                                  )
                                ],
                              )
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(3)),
                          Expanded( //
                              flex:6,//<-- Expanded widget
                              child: SizedBox(
                                width:MediaQuery.of(context).size.width,
                                child: ListView(
                                //  padding:const EdgeInsets.fromLTRB(0, 50, 118, 0),
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(25),
                                        width: 260,
                                        color: Colors.white,
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Text(_productModel.brand,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(5),),
                                            Text(_productModel.pname,
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
                                                Text(_productModel.price.toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                const Padding(padding: EdgeInsets.all(4),),
                                                Text(_productModel.l_price.toString(),
                                                  style: const TextStyle(
                                                    decoration: TextDecoration.lineThrough,
                                                    fontWeight: FontWeight.normal,
                                                    color: Colors.grey,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                const Padding(padding: EdgeInsets.all(4),),
                                                Text('${_productModel.discount}% OFF',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight
                                                        .normal,
                                                    color: Colors.amber,
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
                                                                .amber),
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
                                      const Padding(padding: EdgeInsets.all(2)),
                                      ///   Product detail   ////////////////////////////////////////////////////////////////
                                      ProductAddtionalDetail(pid),
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
              ),
              Footer()

            ],
          ),
        )
    );
  }


  void addtocart(context,pid,selectedSize) {
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
