
import 'package:as_fashion/Screen/MyShoppingCart/MyCartPage.dart';
import 'package:as_fashion/Screen/MyWishListPage.dart';
import 'package:as_fashion/Screen/My_Order/My_Order_Page.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../Screen/LandingPage/LandingPage.dart';
import '../Screen/LoginPage/Login_Screen.dart';
import '../Screen/My_Account/My_Account_Desktop.dart';
import '../Screen/My_Address/My_Address.dart';
import '../constants.dart';

class Header extends StatelessWidget {
   Header({Key? key}) : super(key: key);


  late List menuItems=[ "MY ACCOUNT","MY ORDER","MY ADDRESS"];
 // CustomPopupMenuController _controller = CustomPopupMenuController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.white70
          ),
          borderRadius: BorderRadius
              .circular(1)
      ),
      height: 70,
     // color: Colors.white,
      child: Row(
       // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:  [
          const Padding(padding: EdgeInsets.only(left: 130)),
          const Text('A.S Fashion',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 25
              ),
          ),
          //const Padding(padding: EdgeInsets.only(left: 45)),
          TextButton(
            onPressed:(){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const LandingDesktop()));
            },
            child: const Text('MEN',
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black54,
                  fontSize: 20
              ),
            ),
          ),
         // const Padding(padding: EdgeInsets.only(left: 30)),
          TextButton(
            onPressed: press(),
            child: const Text('WOMEN',
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black54,
                  fontSize: 20
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 15)),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width/4,
            padding: const EdgeInsets.fromLTRB(20,5,10,5),
            decoration:BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: const [
                Icon(Icons.search_sharp,size: 30,),
               // Padding(padding: EdgeInsets.only(left: 15)),
                Text('Are you loking for?',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    fontSize: 20
                  ),
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 35)),
          const VerticalDivider(width: 5,thickness: 5,),
         // const Padding(padding: EdgeInsets.only(left: 25)),
          Row(
            children: [
              StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return FirebaseAuth.instance.currentUser ==null
                      ?TextButton(
                    onPressed:(){
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: const Text('Login',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black54,
                          fontSize: 20
                      ),
                    ),
                  ):
                  CustomPopupMenu(
                    menuBuilder: () => ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        width: 180,
                        padding: const EdgeInsets.all(20),
                        color: const Color.fromARGB(232,232,232,232),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children:  [
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyAccountDesktop()));
                              },
                              child: const Text("MY ACCOUNT ",
                                style:TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(12)),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                    context, MaterialPageRoute(
                                    builder: (context) => const My_Address()
                                )
                                );
                              },
                              child: const Text("MY ADDRESS ",
                                style:TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(12)),
                            GestureDetector(
                              onTap: (){
                                 Navigator.push(
                                     context, MaterialPageRoute
                                   (builder: (context) => const MyOrderPage()
                                 )
                                 );
                              },
                              child: const Text("MY ORDERS ",
                                style:TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(12)),
                            GestureDetector(
                              onTap: (){
                                //  Navigator.push(context, MaterialPageRoute(builder: (context) => const My_Account_Desktop()));
                              },
                              child: const Text("MY WISHLIST ",
                                style:TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    verticalMargin: -10,
                    pressType:PressType.singleClick ,
                    child:   const Icon(
                        Icons.account_circle_rounded,
                        color: Colors.black
                    ),
                  );
                },
              ),
              const Padding(padding: EdgeInsets.only(left: 12)),
              IconButton(
                  onPressed:(){
                    if(FirebaseAuth.instance.currentUser !=null){
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => const MyWishListPage()
                      )
                      );
                    }else{
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder: (context) => const LoginScreen()
                        )
                        );
                    }
                  },
                  icon: const Icon(Icons.favorite_border_sharp,
                    color: Colors.black,
                  )
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              IconButton(
                  onPressed:(){
                    if(FirebaseAuth.instance.currentUser !=null){
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => const MyCartPage()
                      )
                      );
                    }else{
                      Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => const LoginScreen()
                      )
                      );
                    }
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
    );
  }




  login() {}

  press() {}
}


class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(defaultPadding * 0.75),
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
