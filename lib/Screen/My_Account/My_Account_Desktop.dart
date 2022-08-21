
import 'dart:io';
import 'package:as_fashion/Screen/LandingPage/LandingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/header.dart';

class MyAccountDesktop extends StatefulWidget {
  const MyAccountDesktop({Key? key}) : super(key: key);

  @override
  State<MyAccountDesktop> createState() => _MyAccountDesktopState();
}

class _MyAccountDesktopState extends State<MyAccountDesktop> {
  TextEditingController nameController = TextEditingController(); // initialize the controller
  TextEditingController phoneController = TextEditingController();// initialize the controller
  TextEditingController genderController = TextEditingController(); // initialize the controller
  TextEditingController emailController = TextEditingController(); // initialize the controller


  String? phone=FirebaseAuth.instance.currentUser?.phoneNumber;

  bool phoneexit=true;

  var imagesNetwork; /// online image file

  var imageFile; /// initialize local file image


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body:SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              Header(),
              const Padding(padding: EdgeInsets.zero),
              const Padding(
                padding: EdgeInsets.fromLTRB(50,50,30,0),
                child:  Text("My Profile",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 37,
                      color: Colors.black
                  ),
                ),
              ),
              SizedBox(
                height: 550,
                child: StreamBuilder(
                  stream:FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid).snapshots(includeMetadataChanges: true) ,
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return const Center(
                        child:CircularProgressIndicator() ,
                      );
                    }
                    if(snapshot.connectionState==ConnectionState.active){
                      if(snapshot.data?.exists==true){
                        nameController.text=snapshot.data?.get("name");
                        phoneController.text=snapshot.data?.get("phone");
                        emailController.text=snapshot.data?.get("email");
                        genderController.text=snapshot.data?.get("gender");
                        imagesNetwork=snapshot.data?.get("image");

                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.only(top: 15),
                              width: MediaQuery.of(context).size.width/1.5,
                              height: MediaQuery.of(context).size.height/1.5,
                              child: ListView(
                                padding: const EdgeInsets.all(25),
                                shrinkWrap: true,
                                children:   [
                                  StatefulBuilder(builder:(context ,StateSetter setstate){
                                    return Center(
                                      child: InkWell(
                                        onTap: () {
                                          pickFile();
                                        },
                                        child: CircleAvatar(
                                          radius: 70,
                                          child: ClipOval(
                                            child: imagesNetwork.isEmpty==true ?
                                            imageFile==null?
                                            Image.asset("assets/avtar_team.png",
                                              height: 150,
                                              width: 150,
                                              fit: BoxFit.contain,
                                            ): Image.file(
                                              imageFile,
                                              height: 150,
                                              width: 150,
                                              fit: BoxFit.cover,
                                            )
                                                : Image.network(imagesNetwork,
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  ),


                                  TextField(
                                    controller: nameController,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.cyan
                                        ),
                                      ),
                                      labelText: "NAME",
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.all(15)),
                                  TextField(
                                    controller: genderController,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.cyan
                                        ),
                                      ),
                                      labelText: "GENDER",
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.all(15)),

                                  TextField(
                                    enabled: phone==null?
                                    phoneexit:false,
                                    controller: phoneController,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.cyan
                                        ),
                                      ),
                                      labelText: "CONTACT NO",
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.all(15)),

                                  TextField(
                                    controller: emailController,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.cyan
                                        ),
                                      ),
                                      labelText: "EMAIL",
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.all(15)),
                                  ElevatedButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        textStyle: const TextStyle(color: Colors.white),
                                      ),

                                      child:const Text('Update ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26,
                                            color: Colors.white
                                        ),
                                      ),
                                      onPressed: () {
                                        update_profile(context);
                                      }
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      else{
                        //if(snapshot.hasData){
                        // nameController.text=snapshot.data.d
                        // nameController.text=snapshot.data?.get("name");
                        phoneController.text=FirebaseAuth.instance.currentUser!.phoneNumber!;
                        // emailController.text=FirebaseAuth.instance.currentUser!.email!;
                        //genderController.text=snapshot.data?.get("gender");
                        return Padding(
                          padding: const EdgeInsets.all(50),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.only(top: 25),
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width/2,
                              height: MediaQuery.of(context).size.height/1.5,
                              child: ListView(
                                padding: const EdgeInsets.all(25),
                                shrinkWrap: true,
                                children:   [
                                  StatefulBuilder(builder:(context ,StateSetter setstate){
                                    return Center(
                                      child: InkWell(
                                        onTap: () {
                                          pickFile();
                                        },
                                        child: CircleAvatar(
                                          radius: 70,
                                          child: ClipOval(
                                              child: imageFile==null?
                                              Image.asset("assets/avtar_team.png",
                                                height: 150,
                                                width: 150,
                                                fit: BoxFit.contain,
                                              ):
                                              Image.file(
                                                imageFile,
                                                height: 150,
                                                width: 150,
                                                fit: BoxFit.cover,
                                              )
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  ),

                                  TextField(
                                    controller: nameController,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.cyan
                                        ),
                                      ),
                                      labelText: "NAME",
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.all(15)),
                                  TextField(
                                    controller: genderController,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.cyan
                                        ),
                                      ),
                                      labelText: "GENDER",
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.all(15)),

                                  TextField(
                                    enabled: phone==null?
                                    phoneexit:false,
                                    controller: phoneController,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.cyan
                                        ),
                                      ),
                                      labelText: "CONTACT NO",
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.all(15)),

                                  TextField(
                                    controller: emailController,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(15),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.cyan
                                        ),
                                      ),
                                      labelText: "EMAIL",
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.all(15)),
                                  ElevatedButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        textStyle: const TextStyle(color: Colors.white),
                                      ),

                                      child:const Text('Update ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26,
                                            color: Colors.white
                                        ),
                                      ),
                                      onPressed: () {
                                        update_profile(context);
                                      }
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                        //  }
                      }
                    }
                    return const CircularProgressIndicator();

                  },
                ),
              )
            ],
          ),

        ),
    );

  }
  void pickFile() async {

    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }

  }

  void update_profile(context) {
    FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid.toString()).set(
        {
          "phone":phoneController.text.trim(),
          "email": emailController.text.trim(),
          "name":nameController.text.trim(),
          "gender":genderController.text.trim(),
          "image":""

        }
    ).whenComplete(() =>{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LandingPage())),
    });
  }
}
