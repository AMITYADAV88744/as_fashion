


import 'package:as_fashion/Screen/ProductDetail/product_details.dart';
import 'package:as_fashion/model/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductGridView extends StatefulWidget {
  final int s;
   const ProductGridView( this.s, {Key? key}) : super(key: key);

  @override
  State<ProductGridView> createState() => _ProductGridViewState(this.s);
}

class _ProductGridViewState extends State<ProductGridView> {
  List<bool> isPressed=[];
  final int s;
  _ProductGridViewState(this.s); ///intent value

  @override
  void dispose() {
    super.dispose();
  }


  List<ProductModel> get productModel => _productModel;
  final List<ProductModel> _productModel = [];
  final Query dbRef =
  FirebaseDatabase.instance.reference().child('Products').reference();

  @override

  Widget build(BuildContext context) {
    print(s);
    return  SizedBox(
      height:double.maxFinite,
      
      child:FutureBuilder(
        future: dbRef.get(),
        builder: (context,AsyncSnapshot<DataSnapshot> snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }if(snapshot.hasData){
            _productModel.clear();

            if(s==0){
              Map<dynamic, dynamic> values = snapshot.data!.value;
              values.forEach((key, values) {
                _productModel.add(ProductModel.fromJson(values));

              });

            }else if(s==1){
              _productModel.sort((a, b) => a.l_price.compareTo(b.l_price));
              for(ProductModel p in _productModel) {
                print(p.l_price);
              }
            }
            return AlignedGridView.count(
                controller: ScrollController(),
                //scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                itemCount:_productModel.length,
                itemBuilder: (context, index) {

                  var pri=_productModel[index].l_price-(_productModel[index].discount*_productModel[index].l_price)~/100;

                  return GestureDetector(
                    onTap: () {
                      var pid=productModel[index].pid;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  ProductDetails(pid,"Product Detail")));
                      },
                    child: Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                      child: Column(
                        children: [
                          ListView(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height/3,
                                width: MediaQuery.of(context).size.width/2.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child:  Image.network(_productModel[index].image[0],
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(2),
                                child: Stack(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:  [
                                              Text(productModel[index].brand,
                                                textAlign:TextAlign.left,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const Padding(padding: EdgeInsets.zero),
                                               Text(productModel[index].pname,
                                                textAlign:TextAlign.left,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              Row(
                                                children:  [
                                                  Text(pri.toString(),
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const Padding(padding: EdgeInsets.all(1),),
                                                  Text(_productModel[index].l_price.toString(),
                                                    style: const TextStyle(
                                                      decoration: TextDecoration.lineThrough,
                                                      color: Colors.grey,
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                  const Padding(padding: EdgeInsets.all(1),),
                                                  Text('${_productModel[index].discount}% OFF',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      color: Colors.green,
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Padding(padding: EdgeInsets.zero),
                                      ],
                                    ),
                                    Positioned(
                                      //bottom: 5,
                                      right: 0,
                                      child: Column(
                                        children: [
                                    IconButton(
                                            onPressed:() {
                                              if (kDebugMode) {
                                                print(index);
                                              }
                                              setState(() {
                                               // fav[index]=true;
                                              });
                                              _wishList(index);
                                            },
                                            icon: const Icon(
                                              Icons.favorite_border_sharp,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ),
                    ),
                  );
                }
            );
          }
          print(1);
          return const Center(child: CircularProgressIndicator(),);
        },
      ),
    );

  }

  _wishList(int i) {

    if (kDebugMode) {
      print(i);
    }
    var ind = i;
    var pid = _productModel[ind].pid;

    final DatabaseReference favRef =
    FirebaseDatabase.instance.reference().
    child('Products').child(pid).child("Fav");
    favRef.child(FirebaseAuth.instance.currentUser!.uid.toString());

    favRef.update({
      "state":true,
    });


    /* var addWish = FirebaseFirestore.instance.collection("WishList")
        .doc(FirebaseAuth.instance.currentUser?.uid).collection(
        FirebaseAuth.instance.currentUser!.uid.toString());


    addWish.doc(pid).get().then((docData) =>
    {
      if (docData.exists) {
        addWish.doc(_productModel[ind].pid).delete().then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Removed From Wish list')));

        })
      } else
        {

        
          addWish.doc(_productModel[ind].pid).set({
            "pid": _productModel[ind].pid,
            "image": _productModel[ind].image,
            "pname": _productModel[ind].pname,
            "brand": _productModel[ind].brand,
            "price": _productModel[ind].price
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
  */
  }
}



