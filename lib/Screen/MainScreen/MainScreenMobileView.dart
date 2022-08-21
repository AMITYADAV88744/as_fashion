
import 'package:as_fashion/Screen/LandingPage/LandingPage.dart';
import 'package:as_fashion/Screen/LoginPage/Login_Screen.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../../components/CustomSearch.dart';
import '../../components/side_menu.dart';
import '../../controllers/MenuController.dart';
import '../../model/category_model.dart';
import '../../model/product_model.dart';
import '../MyShoppingCart/MyCartPage.dart';
import '../MyWishListPage.dart';
import '../ProductDetail/product_details.dart';

class MainScreenMobileView extends StatefulWidget{
  const MainScreenMobileView({Key? key}) : super(key: key);

  @override
  MainScreenMobileViewState createState() => MainScreenMobileViewState();
}

class MainScreenMobileViewState extends State<MainScreenMobileView> {
  final orderRef=FirebaseFirestore.instance.collection("Categories");
  final headerCat=FirebaseFirestore.instance.collection("HeaderCategories");
  final banner=FirebaseFirestore.instance.collection("BannerHead");

  List<CategoryModel> _categoryModel = [];


  final List<ProductModel> _productModel = [];
  final  newCollection =
  FirebaseDatabase.instance.reference().child('Products');


  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 3,
      child:Scaffold(
        key: context
            .read<MenuController>()
            .scaffoldKey,
        appBar: AppBar(
          elevation: 1,
          leading:IconButton(
            onPressed:
            context
                .read<MenuController>()
                .controlMenu,
            icon:const Icon(
              Icons.menu,
              color: Colors.black,
            ),
          ),
          title: const Text('A.S Fashion',style: TextStyle(color: Colors.black),),
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
        body: SizedBox(
          child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              children:[
                Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget> [
                  SizedBox(
                    height: 180,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: banner.snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState==ConnectionState.waiting){
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if(snapshot.connectionState==ConnectionState.active){

                          if(snapshot.hasData){
                            if(snapshot.data?.docs.isEmpty==true){
                              return const Center(
                                  child: Text("Admin Server Down")
                              );
                            }else{

                              return CarouselSlider.builder(

                                //Slider Container properties
                                options: CarouselOptions(
                                  height: 180.0,
                                  enlargeCenterPage: true,
                                  pageSnapping: true,
                                  autoPlay: true,
                                  aspectRatio: 16 / 9,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enableInfiniteScroll: true,
                                  autoPlayAnimationDuration: const Duration(milliseconds: 900),
                                  viewportFraction: 0.8,

                                ),
                                itemBuilder: (BuildContext context, int index, int realIndex) {
                                  return  Container(
                                    height: 360,
                                    margin: EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      image:  DecorationImage(
                                        image: NetworkImage(snapshot.data?.docs[index]["image"]),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                }, itemCount: snapshot.data!.docs.length,
                              );
                            }
                          }
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                  Divider(
                    thickness: 4,
                    color: Colors.amber[200],
                  ),
                  Container(
                      color: Colors.blue[50],
                      height: 120,
                      child: _listHeaderCategory()
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],

                    ),
                    child:
                      Column(
                        children: [
                          ListTile(
                            title: const Text("Explore New Collection"),
                            subtitle: const Text("Curated,Just for You "),
                            trailing: IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LandingPage('')));
                              },
                              icon: const Icon(Icons.keyboard_arrow_right_sharp),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width-20,
                            height: 430,
                            child: FutureBuilder(
                              future: newCollection.get(),
                              builder: (context,AsyncSnapshot<DataSnapshot> snapshot){
                                if(snapshot.connectionState==ConnectionState.waiting){
                                  return const Center(child: CircularProgressIndicator());
                                }if(snapshot.hasData){
                                  _productModel.clear();

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
                                  return AlignedGridView.count(
                                      controller: ScrollController(),
                                      physics: const BouncingScrollPhysics(),
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5,
                                      itemCount:4,
                                      itemBuilder: (context, index) {

                                        return GestureDetector(
                                          onTap: () {
                                            var pid=_productModel[index].pid;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>  ProductDetails("titles",pid)));
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
                                                        padding: const EdgeInsets.all(15),
                                                        width: MediaQuery.of(context).size.width/2.5,
                                                        height: 160,
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
                                                                      Text(_productModel[index].brand,
                                                                        textAlign:TextAlign.left,
                                                                        style: const TextStyle(
                                                                          fontWeight: FontWeight.bold,
                                                                          color: Colors.black,
                                                                          fontSize: 12,
                                                                        ),
                                                                      ),
                                                                      const Padding(padding: EdgeInsets.zero),
                                                                      Text(_productModel[index].pname,
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
                          )
                        ],
                    ),
                  ),
                  Container(
                    color: Colors.blue[50],
                      height: 100,
                      child: _listPriceRangeCategory()
                  ),

                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.amber[100]
                    ),
                    child:
                    Column(
                      children: [
                        ListTile(
                          title: const Text("Flash Sale !!!"),
                          subtitle: const Text("End of Season Sale"),
                          trailing: IconButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LandingPage('')));
                            },
                            icon: const Icon(Icons.keyboard_arrow_right_sharp),
                          ),
                        ),
                        AlignedGridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          itemCount:4,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                //  Navigator.push(context, MaterialPageRoute(builder: (context) => const LandingPage()));
                              },
                              child: Card(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(15),
                                      width: MediaQuery.of(context).size.width/2.5,
                                      height: 160,
                                      child:  Image.network(
                                        'https://5.imimg.com/data5/YJ/BO/MY-10973479/mens-designer-casual-shirt-1000x1000.jpg',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    const Text('Super Combo Pack',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black
                                      ),
                                    ),
                                    const SizedBox(height: 5,)
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
                ),
              ]
          ),
        )
      ),
    );
  }
  Widget _listHeaderCategory() {
    return StreamBuilder<QuerySnapshot>(
      stream: headerCat.snapshots(),
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(snapshot.connectionState==ConnectionState.active){

          if(snapshot.hasData){
            if(snapshot.data?.docs.isEmpty==true){
              return const Center(
                child: CircularProgressIndicator()
              );
            }else{

              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data?.docs.length,
                 itemBuilder: (context,index){

                    // var orderid=snapshot.data?.docs[index]["order_no"];
                    return GestureDetector(
                      onTap: () {
                        var  title=snapshot.data!.docs[index]['name'];
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  LandingPage(title)),);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: Image.network(snapshot.data?.docs[index]["image"],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Text(snapshot.data?.docs[index]["name"],)
                          ],
                        )
                      )
                    );
                  }

              );
            }
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
  Widget _listPriceRangeCategory() {
    return StreamBuilder<QuerySnapshot>(
      stream: orderRef.snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.connectionState==ConnectionState.active){

            if(snapshot.hasData){
              if(snapshot.data?.docs.isEmpty==true){
                return const Center(
                  child: CircularProgressIndicator()
                );
              }else{
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: () {
                         var  title=snapshot.data!.docs[index]['name'];
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  LandingPage(title)),);
                          },
                        child: Padding(
                          padding: EdgeInsets.all(2),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.network(snapshot.data?.docs[index]["image"],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                      );
                    }

                );
              }
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
    );
  }

}
