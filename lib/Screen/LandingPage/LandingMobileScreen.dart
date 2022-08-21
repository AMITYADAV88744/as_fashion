
import 'package:as_fashion/Screen/MainScreen/MainScreenPage.dart';
import 'package:as_fashion/Screen/MyShoppingCart/MyCartPage.dart';
import 'package:as_fashion/Screen/MyWishListPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../../components/CustomSearch.dart';
import '../../components/side_menu.dart';
import '../../controllers/MenuController.dart';
import '../../model/product_model.dart';
import '../LoginPage/Login_Screen.dart';
import '../ProductDetail/product_details.dart';

class LandingMobileScreen extends StatefulWidget{
  String titles;
   LandingMobileScreen( this.titles, {Key? key}) : super(key: key);

  @override
  State<LandingMobileScreen> createState(){
    return LandingMobileScreenState(this.titles);

  }
}

class LandingMobileScreenState extends State<LandingMobileScreen> {
  String titles;
  LandingMobileScreenState(this.titles);


  late int s=0;
  List<ProductModel> get productModel => _productModel;
  final List<ProductModel> _productModel = [];


  final  dbRef =
  FirebaseDatabase.instance.reference().child('Products').orderByChild("subcategory").equalTo("OverSized");

  final  wis =
  FirebaseDatabase.instance.reference().child('Products');

  @override
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("_____________Landing Page______________");
    }
    return Scaffold(
      key: context
          .read<MenuController>()
          .scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading:IconButton(
          onPressed:(){
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const MainScreenPage()
            ));
          },
          icon:const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          titles,
          style:const TextStyle(
            color: Colors.black,
          ),
        ) ,
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
      drawer: const SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width-20,
              height: MediaQuery.of(context).size.height-100,
              child:FutureBuilder(
                future: dbRef.once(),
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

                      Map<dynamic, dynamic> values = snapshot.data!.value;
                      values.forEach((key, values) {
                        _productModel.add(ProductModel.fromJson(values));
                      });
                      _productModel.sort((a, b) => a.price.compareTo(b.price));
                      for(ProductModel p in _productModel) {
                        if (kDebugMode) {
                          print(p.price);
                        }
                      }
                    }else if(s==2){
                      Map<dynamic, dynamic> values = snapshot.data!.value;
                      values.forEach((key, values) {
                        _productModel.add(ProductModel.fromJson(values));
                      });
                      _productModel.sort((b, a) => a.price.compareTo(b.price));
                      for(ProductModel p in _productModel) {
                        if (kDebugMode) {
                          print(p.price);
                        }
                      }
                    }else if(s==3){
                      Map<dynamic, dynamic> values = snapshot.data!.value;
                      values.forEach((key, values) {
                        _productModel.add(ProductModel.fromJson(values));
                      });
                      _productModel.sort((b, a) => a.uploadtime.compareTo(b.uploadtime));
                      for(ProductModel p in _productModel) {
                        if (kDebugMode) {
                          print(p.uploadtime);
                        }
                      }
                    }
                    return AlignedGridView.count(
                        controller: ScrollController(),
                        physics: const BouncingScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        itemCount:_productModel.length,
                        itemBuilder: (context, index) {

                          return GestureDetector(
                            onTap: () {
                              var pid=productModel[index].pid;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>  ProductDetails(titles,pid)));
                            },
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: Column(
                                  children: [
                                    ListView(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context).size.height/4,
                                          width: MediaQuery.of(context).size.width/2.5,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child:  Image.network(_productModel[index].image[0],
                                            //fit: BoxFit.fill,
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
                                                        Text(
                                                          productModel[index].pname,
                                                          overflow: TextOverflow.ellipsis,
                                                          textAlign:TextAlign.left,
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.grey,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                        Row(
                                                          children:  [
                                                            Text(_productModel[index].price.toString(),
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

                  return const Center(child: CircularProgressIndicator(),);
                },
              ),
            ),
          ],
        ),
      ),
      bottomSheet: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width/2)-2,
                height: 50,
                child: TextButton(
                    style: TextButton
                        .styleFrom(
                    //  backgroundColor: Colors.white,
                      textStyle: const TextStyle(
                          color: Colors.black
                      ),
                    ),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Sort By ',
                          style: TextStyle(
                              fontWeight: FontWeight
                                  .bold,
                              fontSize: 15,
                              color: Colors
                                  .black
                          ),
                        ),
                        Icon(
                          Icons.sort_rounded,
                          size: 15,
                          color: Colors.black,
                        )
                      ],
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(50),
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
                                  ListTile(
                                    title:  const Text('Price-low to high'),
                                    onTap: () {
                                      setState(() {
                                        s=1;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Price-high to low'),
                                    onTap: () {
                                      setState(() {
                                        s=2;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title:  const Text('Best Selling'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Newest'),
                                    onTap: () {
                                      setState(() {
                                        s=3;
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          });
                    }
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width/2)-2,
                height: 50,
                child: TextButton(
                    style: TextButton
                        .styleFrom(
                     // backgroundColor: Colors.white,
                      textStyle: const TextStyle(
                          color: Colors
                              .black
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Filter',
                          style: TextStyle(
                              fontWeight: FontWeight
                                  .bold,
                              fontSize: 15,
                              color: Colors
                                  .black
                          ),
                        ),
                        Icon(
                          Icons.filter_list,
                          size: 15,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(0),
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(30),
                              child: ListView(
                                shrinkWrap: true,
                               // mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height-50,
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      children:  const [
                                        ExpansionTile(

                                          title: Text('Category'),
                                          children: <Widget>[
                                            InkWell(
                                              child:ListTile(title: Text('T-shirt')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Gym Vest')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Oversize')),
                                            ),

                                          ],
                                        ),
                                        ExpansionTile(
                                          title: Text('Sizes'),
                                          children: <Widget>[
                                            InkWell(
                                              child:ListTile(title: Text('S')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('M')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('L')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('XL')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('XXL')),
                                            ),
                                          ],
                                        ),
                                        ExpansionTile(
                                          title: Text('Color'),
                                          children: <Widget>[
                                            InkWell(
                                              child:ListTile(title: Text('S')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('M')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('S')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('M')),
                                            ),
                                          ],
                                        ),
                                        ExpansionTile(
                                          title: Text('Design'),
                                          children: <Widget>[
                                            InkWell(
                                              child:ListTile(title: Text('Printed')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Solid')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Plain')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Color Block')),
                                            ),
                                          ],
                                        ),
                                        ExpansionTile(
                                          title: Text('Fit'),
                                          children: <Widget>[
                                            InkWell(
                                              child:ListTile(title: Text('Regular Fit')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Oversized')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Slim Fit')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Relaxed Fit')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Super Loose')),
                                            ),
                                          ],
                                        ),ExpansionTile(
                                          title: Text('Sleeve'),
                                          children: <Widget>[
                                            InkWell(
                                              child:ListTile(title: Text('Half Sleeve')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Full Sleeve')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Sleeveless')),
                                            ),

                                          ],
                                        ),ExpansionTile(
                                          title: Text('Neck'),
                                          children: <Widget>[
                                            InkWell(
                                              child:ListTile(title: Text('Round Neck')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Hood')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Polo')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Shirt Collar')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text(' Collar')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Crew Neck')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('V-Neck')),
                                            ),
                                          ],
                                        ),ExpansionTile(
                                          title: Text('Type'),
                                          children: <Widget>[
                                            InkWell(
                                              child:ListTile(title: Text('T-Shirt')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Vest')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Sweatshirt')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Hoodies')),
                                            ),
                                          ],
                                        ),ExpansionTile(
                                          title: Text('Discount'),
                                          children: <Widget>[
                                            InkWell(
                                              child:ListTile(title: Text('10 % Or More')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('20 % Or More')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('30 % Or More')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('40 % Or More')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('50 % Or More')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('60 % Or More')),
                                            ),

                                          ],
                                        ),ExpansionTile(
                                          title: Text('Sort By'),
                                          children: <Widget>[
                                            InkWell(
                                              child:ListTile(title: Text('Popular')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Newest')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Price:High to Low')),
                                            ),
                                            InkWell(
                                              child:ListTile(title: Text('Price: Low to High')),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    }
                ),
              ),
            ]
        ),
      ),
    );
  }
  _wishList(int i) {

    if (kDebugMode) {
      print(i);
    }
    var ind = i;
    var pid = _productModel[ind].pid;
     var addWish = FirebaseFirestore.instance.collection("WishList")
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
}

