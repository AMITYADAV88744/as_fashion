
import 'package:as_fashion/Screen/My_Account/My_Account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../Screen/LoginPage/Login_Screen.dart';
import '../Screen/MyWishListPage.dart';
import '../Screen/My_Address/My_Address.dart';
import '../Screen/My_Order/My_Order_Page.dart';

class MyMenu extends StatefulWidget {
   const MyMenu({Key? key}) : super(key: key);

  @override
  State<MyMenu> createState() => _MyMenuState();

}


final ScrollController _controllerOne = ScrollController();

class _MyMenuState extends State<MyMenu>  {

   greeting() {
    var hour = DateTime.now().hour;

    if (hour <= 12) {
      return const Text("Good Morning",
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black
        ),
      );
    } else if ((hour > 12) && (hour <= 16)) {
      return const Text(
          "Good Afternoon",
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black
        ),
      );
    } else if ((hour > 16) && (hour < 20)) {
      return const Text(
          "Good Evening",
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black
        ),
      );
    } else {
      return const Text(
          "Good Night",
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: StreamBuilder(
          stream:FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            String? phone=FirebaseAuth.instance.currentUser?.phoneNumber;

            return SingleChildScrollView(
              controller: _controllerOne,
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.white,
                      child:ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children:  [
                          greeting(),
                          const Padding(padding: EdgeInsets.all(10)),
                          FirebaseAuth.instance.currentUser==null
                              ?GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                              },
                              child:const Text("Login / Signup",
                                style:TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                              )
                          ):
                         StreamBuilder(
                             stream: FirebaseFirestore.instance.collection("Users")
                                 .doc(FirebaseAuth.instance.currentUser!.uid).snapshots(includeMetadataChanges: false),
                             builder: (context,AsyncSnapshot<DocumentSnapshot>snapshotdata){
                               if(snapshotdata.data?.exists==true){
                                 return Row(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     CircleAvatar(
                                       radius: 35,
                                       child: ClipOval(
                                         child: snapshotdata.data?.get("image").isEmpty==true ?
                                         Image.asset("assets/avtar_team.png",
                                           height: 150,
                                           width: 150,
                                           fit: BoxFit.fitHeight,
                                         ) : Image.network(snapshotdata.data?.get("image"),
                                           width: 150,
                                           height: 150,
                                           fit: BoxFit.cover,
                                         ),
                                       ),
                                     ),

                                    Padding(padding: const EdgeInsets.all(15),
                                    child:Center(
                                      child: Column(
                                        mainAxisAlignment:MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshotdata.data?.get("name"),
                                            style: const TextStyle(
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                            ),
                                          ),

                                          Text(
                                            snapshotdata.data?.get("phone"),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                            ),
                                          ),
                                        ],
                                      )
                                    ) ,
                                    )

                                   ],
                                 );
                               }
                               return  Row(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   CircleAvatar(
                                     radius: 35,
                                     child: ClipOval(
                                       child: Image.asset("assets/avtar_team.png",
                                         height: 150,
                                         width: 150,
                                         fit: BoxFit.fitHeight,
                                       ) ,
                                     ),
                                   ),
                                   Padding(padding: const EdgeInsets.all(15),
                                     child:Center(
                                       child: InkWell(
                                         onTap:(){
                                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyAccount()));
                                         },
                                           child: const Text(
                                             "Click to Add ",
                                             style: TextStyle(
                                                 fontSize: 20,
                                                 fontWeight: FontWeight.bold,
                                                 color: Colors.blueAccent
                                             ),
                                           ),
                                       )
                                     ) ,
                                   )
                                 ],
                               );
                             }
                         )
                        ],
                      ),
                  ),
                  const Divider(
                    height: 5,
                    endIndent: 1,
                    thickness: 2,
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.white,
                    height: 150,
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children:  [
                        const Text("SHOP IN",
                          style:TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),),
                        const Padding(padding: EdgeInsets.all(10)),
                        const Text("MEN",
                          style:TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                       const  Padding(padding: EdgeInsets.all(10)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            const Text("WOMEN",
                              style:TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Image.asset("assets/commingsoon.jpg",height: 35, width: 45,)
                          ]
                        ),
                        Padding(padding: const EdgeInsets.all(10)),
                      ],
                    ),
                  ),
                  FirebaseAuth.instance.currentUser==null
                      ?Visibility(
                    visible:false,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.white,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: const [
                          Text("MY ACCOUNT",
                            style:TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Text("MY ORDER",
                            style:TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Text("MY WISHLIST",
                            style:TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                        ],
                      ),
                    ),
                  ):Visibility(
                    visible: true,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      color: const Color.fromARGB(232,232,232,232),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children:  [
                          GestureDetector(
                            onTap: (){},
                            child: const Text("PROFILE ",
                              style:TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(8)),
                          GestureDetector(
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyAccount()));
                            },
                            child: const Text("MY ACCOUNT ",
                              style:TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(8)),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>  const My_Address()));
                            },
                            child: const Text("MY ADDRESS ",
                              style:TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(8)),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>  const MyOrderPage()));
                            },
                            child: const Text("MY ORDERS ",
                              style:TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(8)),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyWishListPage()));
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
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: const Color.fromARGB(232,232,232,232),
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children:  [
                        const Text("CONTACT US",
                          style:TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(8)),
                        InkWell(
                          onTap: (){
                            launch('https://wa.me/919369117542');
                          },
                          child:const Text("Help & Support",
                            style:TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ) ,
                        ),
                        const Padding(padding: EdgeInsets.all(8)),
                        const Text("Feedback & Suggestion",
                          style:TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(8)),
                        const Text("Become Seller",
                          style:TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: const Color.fromARGB(232,232,232,232),
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children:  [
                        const Text("Social Media",
                          style:TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),),
                        const Padding(padding: EdgeInsets.all(8)),
                        InkWell(
                          onTap: (){
                            launch('https://instagram.com/a.s_fashion_');
                          },
                          child: const Text("Instagram",
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
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.white,
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children:  [
                        FirebaseAuth.instance.currentUser ==null
                        ? const Text("Login",
                          style:TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ):GestureDetector(
                          onTap:() {
                             FirebaseAuth.instance.signOut();
                          },
                          child: const Text("Log out",
                            style:TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(10)),

                      ],
                    ),
                  ),

                ],
              ),
            );
          },

        )
    );
  }

}
