

import 'dart:math';

import 'package:as_fashion/Screen/Check_Out_Address/Check_Out_Page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';




class AddAddressForm extends StatelessWidget {

  final  String pid,size;

  AddAddressForm(this.pid,this.size,{Key? key}) : super(key: key);

  final TextEditingController nameController=TextEditingController();
  final TextEditingController flatnoController = TextEditingController(); // initialize the controller
  final TextEditingController addressController=TextEditingController(); // initialize the controller
  final TextEditingController localityController=TextEditingController(); // initialize the controller
  final TextEditingController cityController = TextEditingController(); // initialize the controller
  final TextEditingController stateController =TextEditingController();// initialize the controller
  final TextEditingController pinController =TextEditingController();// initialize the controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading:  IconButton(
          onPressed:(){
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) =>   Check_Out_Page(pid, size),
            ));
          },
          icon:  const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.grey,
          ),
        ),
        title: const Text('My Address',
          style: TextStyle(
              color: Colors.black
          ),
        ),
        actions:[
          Padding(padding: const EdgeInsets.all(8),
              child: InkWell(
                  onTap: (){
                    addaddress(context,);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Save",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                  )
              )
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid.toString()).snapshots(includeMetadataChanges: true),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
            if(snapshot.data!.exists==false){
              if (kDebugMode) {
                print("not exists");
              }
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
                        labelText: "Name",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(15)),

                    TextField(
                      controller: flatnoController,
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
                        labelText: "HOUSE No. / FLAT No",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(15)),
                    TextField(
                      controller: addressController,
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
                        labelText: "ADDRESS",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(15)),

                    TextField(
                      controller: localityController,
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
                        labelText: "LANDMARK",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),

                    TextField(

                      controller: pinController,
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
                        labelText: "PINCODE",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(15)),

                    TextField(
                      controller: cityController,
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
                        labelText: "CITY",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    TextField(

                      controller: stateController,
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
                        labelText: "STATE",
                      ),
                    ),

                  ],
                ),
              );
            }
            else{
              if (kDebugMode) {
                print(" exists");
              }
              nameController.text=snapshot.data?.get("name");
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
                        labelText: "Name",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(15)),

                    TextField(
                      controller: flatnoController,
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
                        labelText: "HOUSE No. / FLAT No",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(15)),
                    TextField(
                      controller: addressController,
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
                        labelText: "ADDRESS",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(15)),

                    TextField(
                      controller: localityController,
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
                        labelText: "LANDMARK",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),

                    TextField(

                      controller: pinController,
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
                        labelText: "PINCODE",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(15)),

                    TextField(
                      controller: cityController,
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
                        labelText: "CITY",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    TextField(

                      controller: stateController,
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
                        labelText: "STATE",
                      ),
                    ),

                  ],
                ),
              );
            }

        },
      ),
    );
  }

  void  addaddress(context) {


    String  addressid='';
    final random = Random();
    for(int i = 0; i < 7; i++) {
      addressid = addressid + random.nextInt(9).toString();
    }
    var dref= FirebaseFirestore.instance.collection("Address").doc(FirebaseAuth.instance.currentUser?.uid.toString())
        .collection(FirebaseAuth.instance.currentUser!.uid).doc(addressid);
    dref.set(
        {
          "name":nameController.text.trim(),
          "flatno":flatnoController.text.trim(),
          "address":addressController.text.trim(),
          "landmark":localityController.text.trim(),
          "city":cityController.text.trim(),
          "state":stateController.text.trim(),
          "pincode":pinController.text.trim(),
          "addressid":addressid,
          "primary":"true"
        }
    ).whenComplete(() =>{
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  Check_Out_Page(pid, size))),
    });

  }
}



///Change Address
class ChangeAddressForm extends StatelessWidget {

 final  String pid,size,addressid;

  ChangeAddressForm(this.pid,this.size,this.addressid,{Key? key}) : super(key: key);

 final TextEditingController nameController=TextEditingController();
 final TextEditingController flatnoController = TextEditingController(); // initialize the controller
 final TextEditingController addressController=TextEditingController(); // initialize the controller
 final TextEditingController localityController=TextEditingController(); // initialize the controller
 final TextEditingController cityController = TextEditingController(); // initialize the controller
 final TextEditingController stateController =TextEditingController();// initialize the controller
 final TextEditingController pinController =TextEditingController();// initialize the controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading:  IconButton(
          onPressed:(){
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) =>   Check_Out_Page(pid, size),
            ));
          },
          icon:  const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.grey,
          ),
        ),
        title: const Text('My Address',
          style: TextStyle(
              color: Colors.black
          ),
        ),
        actions:[
          Padding(padding: const EdgeInsets.all(8),
              child: InkWell(
                  onTap: (){
                    addupdate(context,addressid);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Save",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                  )
              )
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Address").doc(
            FirebaseAuth.instance.currentUser?.uid).collection(FirebaseAuth.instance.currentUser!.uid).doc(addressid).snapshots(
            includeMetadataChanges: true),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.active) {
            /// User Database
            var user= FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser?.uid.toString()).snapshots(includeMetadataChanges: true);
            user.forEach((element) {
              nameController.text=element.get("name");
            });

            if(snapshot.data!.exists==false){
              if (kDebugMode) {
                print("not exists");
              }
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
                        labelText: "Name",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(15)),

                    TextField(
                      controller: flatnoController,
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
                        labelText: "HOUSE No. / FLAT No",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(15)),
                    TextField(
                      controller: addressController,
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
                        labelText: "ADDRESS",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(15)),

                    TextField(
                      controller: localityController,
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
                        labelText: "LANDMARK",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),

                    TextField(

                      controller: pinController,
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
                        labelText: "PINCODE",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(15)),

                    TextField(
                      controller: cityController,
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
                        labelText: "CITY",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    TextField(

                      controller: stateController,
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
                        labelText: "STATE",
                      ),
                    ),

                  ],
                ),
              );
            }
            else{
              if (kDebugMode) {
                print(" exists");
              }
              flatnoController.text=snapshot.data?.get("flatno");
              addressController.text = snapshot.data?.get("address");
              localityController.text=snapshot.data?.get("landmark");
              cityController.text = snapshot.data?.get("city");
              stateController.text = snapshot.data?.get("state");
              pinController.text = snapshot.data?.get("pincode");
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
                        labelText: "Name",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(15)),

                    TextField(
                      controller: flatnoController,
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
                        labelText: "HOUSE No. / FLAT No",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(15)),
                    TextField(
                      controller: addressController,
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
                        labelText: "ADDRESS",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(15)),

                    TextField(
                      controller: localityController,
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
                        labelText: "LANDMARK",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),

                    TextField(

                      controller: pinController,
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
                        labelText: "PINCODE",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(15)),

                    TextField(
                      controller: cityController,
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
                        labelText: "CITY",
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    TextField(

                      controller: stateController,
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
                        labelText: "STATE",
                      ),
                    ),

                  ],
                ),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void  addupdate(context, addressid) {

    var dref= FirebaseFirestore.instance.collection("Address").doc(FirebaseAuth.instance.currentUser?.uid.toString())
        .collection(FirebaseAuth.instance.currentUser!.uid).doc(addressid);
    dref.set(
        {
          "name":nameController.text.trim(),
          "flatno":flatnoController.text.trim(),
          "address":addressController.text.trim(),
          "landmark":localityController.text.trim(),
          "city":cityController.text.trim(),
          "state":stateController.text.trim(),
          "pincode":pinController.text.trim(),
          "addressid":addressid,
          "primary":"true"
        }
    ).whenComplete(() =>{
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  Check_Out_Page(pid, size))),
    });

  }
}
