
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../MainScreen/MainScreenPage.dart';

class MyAccountMobile extends StatefulWidget {
  const MyAccountMobile({Key? key}) : super(key: key);

  @override
  State<MyAccountMobile> createState() => _MyAccountMobileState();
}

class _MyAccountMobileState extends State<MyAccountMobile> {
  String? phone = FirebaseAuth.instance.currentUser?.phoneNumber;
  bool phoneexit = true;
  TextEditingController nameController = TextEditingController(); // initialize the controller
  TextEditingController phoneController =TextEditingController(); // initialize the controller
  TextEditingController genderController=TextEditingController(); // initialize the controller
  TextEditingController emailController= TextEditingController();

  var images;
  var imageFile;
  bool onlytext=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading:  IconButton(
          onPressed:(){
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) =>  const MainScreenPage(),
            ));
          },
          icon:  const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.grey,
          ),
        ),
        title: const Text('My Profile',
          style: TextStyle(
              color: Colors.black
          ),
        ),
        actions:  [
          Padding(padding: const EdgeInsets.all(8),
            child: InkWell(
                onTap: (){
                   const Center(child: CircularProgressIndicator(),);
                  updateprofile(context);
                },
                child:  const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Save",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").doc(
            FirebaseAuth.instance.currentUser?.uid).snapshots(
            includeMetadataChanges: true),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            if (kDebugMode) {
              print("waiting");
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.connectionState==ConnectionState.active){

            /// Email is not exists in database
            if(snapshot.data!.exists ==true){
              if (kDebugMode) {
                print("email  exit");
              }

               images=snapshot.data?.get("image");
              nameController.text = snapshot.data?.get("name");
              phoneController.text = snapshot.data?.get("phone");
              emailController.text = snapshot.data?.get("email");
              genderController.text = snapshot.data?.get("gender");

              return Container(
                padding: const EdgeInsets.only(top: 25),
                color: Colors.white,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 1,
                child: ListView(
                  padding:  const EdgeInsets.all(25),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    StatefulBuilder(builder:(context ,StateSetter setstate){
                      return Center(
                        child: InkWell(
                          onTap: () {
                            pickFile();
                          },
                          child: CircleAvatar(
                            radius: 70,
                            child: ClipOval(
                              child: images.isEmpty==true ?
                             imageFile==null?
                             Image.asset("assets/avtar_team.png",
                               height: 150,
                               width: 150,
                               fit: BoxFit.cover,
                             ): Image.file(
                               imageFile,
                               height: 150,
                               width: 150,
                               fit: BoxFit.cover,
                             )
                                  : Image.network(images,
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
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
                      enabled: phone == null ?
                      phoneexit : false,
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
                  ],
                ),
              );
            }
            /// Email is not exists in database
            if(snapshot.data!.exists !=true){
              if (kDebugMode) {
                print("email  not exit");
              }
              // nameController.text = snapshot.data?.get("name");
              phoneController.text = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
              //  emailController.text = snapshot.data?.get("email");
              // genderController.text = snapshot.data?.get("gender");

              return Container(
                padding: const EdgeInsets.only(top: 25),
                color: Colors.white,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 1,
                child: ListView(
                  padding: const EdgeInsets.all(25),
                  shrinkWrap: true,
                  children: [
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
                                fit: BoxFit.contain,
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
                      enabled: phone == null ?
                      phoneexit : false,
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
                  ],
                ),
              );
            }

          }
          if (kDebugMode) {
            print("nothing");
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
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
          onlytext=false;
        });
      }

  }


  updateprofile(context) async{

   if(onlytext==true){
     FirebaseFirestore.instance.collection("Users")
         .doc(FirebaseAuth.instance.currentUser?.uid.toString()).set(
         {
           "phone":phoneController.text.trim(),
           "email": emailController.text.trim(),
           "name":nameController.text.trim(),
           "gender":genderController.text.trim(),
           "image": images,
         }
     ).whenComplete(() =>{
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreenPage())),
     });
   }else{
     String url="";
     FirebaseStorage storage = FirebaseStorage.instance;
//Create a reference to the location you want to upload to in firebase
     Reference ref = storage.ref("Users").child(FirebaseAuth.instance.currentUser!.uid);

     UploadTask task1 = ref.putFile(imageFile);

// to get the url of the image from firebase storage
     url = await (await task1).ref.getDownloadURL();
     if (kDebugMode) {
       print("URRRRRRRRRRLLLLLLLLLLL ::\n::\n::\n:: $url");
     }
     FirebaseFirestore.instance.collection("Users")
         .doc(FirebaseAuth.instance.currentUser?.uid.toString()).set(
         {
           "phone":phoneController.text.trim(),
           "email": emailController.text.trim(),
           "name":nameController.text.trim(),
           "gender":genderController.text.trim(),
           "image":url,
         }
     ).whenComplete(() =>{
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreenPage())),
     });
   }

  }

}
