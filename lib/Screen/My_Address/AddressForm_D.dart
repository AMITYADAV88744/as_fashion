
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'My_Address.dart';

class AddressForm_D extends StatelessWidget {
  AddressForm_D({Key? key}) : super(key: key);

  TextEditingController nameController=TextEditingController();
  TextEditingController flatnoController = TextEditingController(); // initialize the controller
  TextEditingController addressController=TextEditingController(); // initialize the controller
  TextEditingController localityController=TextEditingController(); // initialize the controller
  TextEditingController cityController = TextEditingController(); // initialize the controller
  TextEditingController stateController =TextEditingController();// initialize the controller
  TextEditingController pinController =TextEditingController();// initialize the controller

  @override
  Widget build(BuildContext context) {

    print("_______________AddressFormDesktop______________");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
          Padding(padding: const EdgeInsets.fromLTRB(8,0,18,0),
            child: IconButton(
              icon: const Icon(Icons.check,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: () {
                add_update(context);
              },
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Address").doc(
            FirebaseAuth.instance.currentUser?.uid).snapshots(
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
              print("not exists");
              return Center(
              child: Padding(
                padding: EdgeInsets.all(50),
                child: Container(
                  padding: const EdgeInsets.only(top: 25),
                  color: Colors.white,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width/2,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 1.5,
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
                          labelText: "NAME",
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
                ),
              )
              );
            }
            else{
              print(" exists");
              flatnoController.text=snapshot.data?.get("flatno");
              addressController.text = snapshot.data?.get("address");
              localityController.text=snapshot.data?.get("landmark");
              cityController.text = snapshot.data?.get("city");
              stateController.text = snapshot.data?.get("state");
              pinController.text = snapshot.data?.get("pincode");
              return Center(
              child: Padding(
                padding: EdgeInsets.all(50),
                child: Container(
                  padding: const EdgeInsets.only(top: 25),
                  color: Colors.white,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width/2,
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
                          labelText: "NAME",
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
                ),
              )
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

  void  add_update(context) {
    var dref= FirebaseFirestore.instance.collection("Address").doc(FirebaseAuth.instance.currentUser?.uid.toString());
    dref..set(
        {
          "name":nameController.text.trim(),
          "flatno":flatnoController.text.trim(),
          "address":addressController.text.trim(),
          "landmark":localityController.text.trim(),
          "city":cityController.text.trim(),
          "state":stateController.text.trim(),
          "pincode":pinController.text.trim(),
        }
    ).whenComplete(() =>{
      Navigator.push(context, MaterialPageRoute(builder: (context) => const My_Address())),
    });

  }
}
