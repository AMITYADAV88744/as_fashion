
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart%20';
import '../ProductDetail/Pnicode.dart';
import 'My_Address.dart';



class AddressForm extends StatelessWidget {

    final String  addressid;


    AddressForm(this.addressid,{Key? key}) : super(key: key);

   final TextEditingController nameController=TextEditingController();
   final TextEditingController flatnoController = TextEditingController(); // initialize the controller
   final TextEditingController addressController=TextEditingController(); // initialize the controller
   final TextEditingController localityController=TextEditingController(); // initialize the controller
   final TextEditingController cityController = TextEditingController(); // initialize the controller
   final TextEditingController stateController =TextEditingController();// initialize the controller
   final TextEditingController pinController =TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
          onPressed:(){
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) =>  const My_Address(),
            ));
          },
          icon:  const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
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
                addupdate(context);
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
                      onChanged: (text){
                        _makeGetRequest(text);
                      },
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

    _makeGetRequest(text) async {
      var pincode='';
      pincode=text;
      // make request
      List postoffice=[];
      // int pincode=229001;
      var url = Uri.parse("https://api.postalpincode.in/pincode/$pincode");
      Response response = await http.get(url);

      // sample info available in response
      int statusCode = response.statusCode;
      Map<String, String> headers = response.headers;
      String json = response.body;
      List<PostOffice> postofficess=[];
      final parsed = jsonDecode(json);

      postoffice=parsed[0]["PostOffice"] ;
      //var welcom= Welcome.fromJson(parsed);
      postoffice=parsed[0]["PostOffice"];
      if (kDebugMode) {
        print(postoffice.length);
      }

      postoffice.forEach((element) {

        postofficess.add(PostOffice.fromJson(element));
      });
      cityController.text=postofficess[0].block.toString();
      stateController.text=postofficess[0].state.toString();

      if (kDebugMode) {
        print(postofficess[0].state);
      }
      if (kDebugMode) {
        print(postofficess[0].country);
      }
      if (kDebugMode) {
        print(postofficess[0].block);
      }
    }
 void  addupdate(context) {

   var dref= FirebaseFirestore.instance.collection("Address")
       .doc(FirebaseAuth.instance.currentUser?.uid.toString())
       .collection(FirebaseAuth.instance.currentUser!.uid).doc(addressid);
   dref.set(
       {
         "addressid":addressid,
         "name":nameController.text.trim(),
         "flatno":flatnoController.text.trim(),
         "address":addressController.text.trim(),
         "landmark":localityController.text.trim(),
         "city":cityController.text.trim(),
         "state":stateController.text.trim(),
         "pincode":pinController.text.trim(),
         "primary":""
       }
   ).whenComplete(() =>{
       Navigator.push(context, MaterialPageRoute(builder: (context) => const My_Address())),
   });

  }
}

class AddressFormAdd extends StatefulWidget {
  const AddressFormAdd({Key? key}) : super(key: key);

  @override
  State<AddressFormAdd> createState() => _AddressFormAddState();
}

class _AddressFormAddState extends State<AddressFormAdd> {
  final TextEditingController nameController=TextEditingController();
  final TextEditingController flatnoController = TextEditingController(); // initialize the controller
  final TextEditingController addressController=TextEditingController(); // initialize the controller
  final TextEditingController localityController=TextEditingController(); // initialize the controller
  final TextEditingController cityController = TextEditingController(); // initialize the controller
  late  TextEditingController stateController =TextEditingController();// initialize the controller
  final TextEditingController pinController =TextEditingController();



  @override
  Widget build(BuildContext context) {
    print("_______________AddressFormMobile______________");

    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
          onPressed:(){
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) =>  const My_Address(),
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
                    addupdate(context);
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
        stream: FirebaseFirestore.instance.collection("Users")
            .doc(FirebaseAuth.instance.currentUser?.uid.toString()).snapshots(includeMetadataChanges: true),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if(snapshot.hasData){

              //nameController.text= snapshot.data?.get("name");
              return  Container(
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
                      style:  const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration:  const InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.cyan
                          ),
                        ),
                        labelText: "PINCODE",
                      ),
                      onChanged: (text){
                        _makeGetRequest(text);
                      },
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
                    decoration:  InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.cyan
                        ),
                      ),
                      labelText: "STATE",
                      errorText: _makeGetRequest(stateController.text.trim()),
                    ),
                  ),

                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }


  _makeGetRequest(text) async {
    var pincode='';
    pincode=text;
    // make request
    List postoffice=[];
    // int pincode=229001;
    var url = Uri.parse("https://api.postalpincode.in/pincode/$pincode");
    Response response = await http.get(url);

    // sample info available in response
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String json = response.body;
    List<PostOffice> postofficess=[];
    final parsed = jsonDecode(json);

    postoffice=parsed[0]["PostOffice"] ;
    //var welcom= Welcome.fromJson(parsed);
    postoffice=parsed[0]["PostOffice"];
    if (kDebugMode) {
      print(postoffice.length);
    }

    postoffice.forEach((element) {
      postofficess.add(PostOffice.fromJson(element));
    });
    cityController.text=postofficess[0].block.toString();
    stateController.text=postofficess[0].state.toString();

    print(postofficess[0].state);
    print(postofficess[0].country);
    print(postofficess[0].block);
  }

  void  addupdate(context) {
    String  addressid='';
    final random = Random();
    for(int i = 0; i < 7; i++) {
      addressid = addressid + random.nextInt(9).toString();
    }
    var dref= FirebaseFirestore.instance.collection("Address")
        .doc(FirebaseAuth.instance.currentUser?.uid.toString())
        .collection(FirebaseAuth.instance.currentUser!.uid).doc(addressid);
    dref.set(
        {
          "addressid":addressid,
          "name":nameController.text.trim(),
          "flatno":flatnoController.text.trim(),
          "address":addressController.text.trim(),
          "landmark":localityController.text.trim(),
          "city":cityController.text.trim(),
          "state":stateController.text.trim(),
          "pincode":pinController.text.trim(),
          "primary":""
        }
    ).whenComplete(() =>{
      Navigator.push(context, MaterialPageRoute(builder: (context) => const My_Address())),
    });

  }
}

