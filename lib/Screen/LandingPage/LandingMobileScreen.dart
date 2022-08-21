
import 'package:as_fashion/Screen/MainScreen/MainScreenPage.dart';
import 'package:as_fashion/Screen/MyShoppingCart/MyCartPage.dart';
import 'package:as_fashion/Screen/MyWishListPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/ProductGridView.dart';
import '../../components/side_menu.dart';
import '../../controllers/MenuController.dart';

class LandingMobileScreen extends StatefulWidget{
  const LandingMobileScreen({Key? key}) : super(key: key);

  @override
  LandingMobileScreenState createState() => LandingMobileScreenState();
}

class LandingMobileScreenState extends State<LandingMobileScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context
          .read<MenuController>()
          .scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        title: const Text('A.S Fashion',style: TextStyle(color: Colors.black),),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed:(){

                  },
                  icon: const Icon(Icons.search_sharp,
                    color: Colors.black,
                  )
              ),
              IconButton(
                  onPressed:(){
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => const MyWishListPage()
                    ));
                  },
                  icon: const Icon(
                    Icons.favorite_border_sharp,
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
      drawer: const SideMenu(),
      body: const ProductGridView(),
    );
  }
  login() {}
}

