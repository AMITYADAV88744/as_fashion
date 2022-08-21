
import 'package:as_fashion/Screen/LandingPage/LandingPage.dart';
import 'package:as_fashion/Screen/LoginPage/Login_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../../components/side_menu.dart';
import '../../controllers/MenuController.dart';
import '../MyShoppingCart/MyCartPage.dart';
import '../MyWishListPage.dart';

class MainScreenMobileView extends StatefulWidget{
  const MainScreenMobileView({Key? key}) : super(key: key);

  @override
  MainScreenMobileViewState createState() => MainScreenMobileViewState();
}

class MainScreenMobileViewState extends State<MainScreenMobileView> {

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 3,
      child:Scaffold(
        key: context
            .read<MenuController>()
            .scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LandingPage()));
                        },
                        child: CircleAvatar(
                          radius: 50,
                          child: ClipOval(
                            child: Image.asset('assets/category.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LandingPage()));
                        },
                        child: CircleAvatar(
                          radius: 50,
                          child: ClipOval(
                            child: Image.asset('assets/category.png',

                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LandingPage()));
                        },
                        child: CircleAvatar(
                          radius: 50,
                          child: ClipOval(
                            child: Image.asset('assets/category.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Image.asset('assets/category.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(25,0,0,0),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LandingPage()
                              ),
                            );},
                          child: CircleAvatar(
                            radius: 60,
                            child: ClipOval(
                              child: Image.asset('assets/category.png',

                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 20)),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LandingPage()));
                          },
                          child: CircleAvatar(
                            radius: 60,
                            child: ClipOval(
                              child: Image.asset('assets/category.png',

                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 20)),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LandingPage()));
                          },
                          child: CircleAvatar(
                            radius: 60,
                            child: ClipOval(
                              child: Image.asset('assets/category.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
               SizedBox(
                 child:
                   AlignedGridView.count(
                   shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                   crossAxisCount: 2,
                   mainAxisSpacing: 2,
                   crossAxisSpacing: 2,
                   itemCount:4,
                   itemBuilder: (BuildContext context, int index) {
                     return GestureDetector(
                       onTap: () {
                         Navigator.push(
                             context, MaterialPageRoute(
                             builder: (context) => const LandingPage()));
                       },
                       child: Card(
                         child: Column(
                           children: [
                             Container(
                               padding: const EdgeInsets.all(15),
                               width: MediaQuery.of(context).size.width/2.5,
                               height: 130,
                               child:  Image.asset(
                                 'assets/category.png',
                                 fit: BoxFit.fill,
                               ),
                             ),
                             const Text('Category',
                               style: TextStyle(
                                   fontWeight: FontWeight.normal,
                                   color: Colors.grey
                               ),)
                           ],
                         ),
                       ),
                     );
                   },
                 ),
               )
              ]
          ),
        )
      ),
    );
  }
}
