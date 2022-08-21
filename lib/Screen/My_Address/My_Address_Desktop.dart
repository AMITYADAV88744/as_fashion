
import 'package:as_fashion/components/Footer.dart';
import 'package:as_fashion/components/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'AddressForm.dart';
import 'AddressForm_D.dart';
import 'My_Address.dart';

class My_Address_Desktop extends StatelessWidget {
   My_Address_Desktop({Key? key}) : super(key: key);
  final addRef=FirebaseFirestore.instance.collection("Address").doc(FirebaseAuth.instance.currentUser?.uid);

  @override
  Widget build(BuildContext context) {
    print("_______________MyAddressDesktop______________");

    return Scaffold(
        backgroundColor: const Color.fromARGB(233, 233, 232, 232),
        body:SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Header(),
              const Padding(padding: EdgeInsets.zero),
             const Padding(
                 padding: EdgeInsets.fromLTRB(70,30,30,30),
                 child:  Text("My Address",
                   style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 37,
                       color: Colors.black
                   ),
                 ),
             ),
              StreamBuilder<QuerySnapshot>(
                stream:addRef.collection(FirebaseAuth.instance.currentUser!.uid).orderBy("primary",descending: true).snapshots() ,
                builder: (context,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if(snapshot.connectionState==ConnectionState.active){

                    if(snapshot.data?.docs.isEmpty==true){
                      return Padding(
                          padding: const EdgeInsets.all(25),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) =>  AddressFormAdd()
                              ));
                            },
                            child: Container(
                              height: 600,
                              width: 300,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey
                                  ),
                                  borderRadius: BorderRadius
                                      .circular(10)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:const [
                                  Icon(
                                    Icons.add,
                                    size: 35,
                                    color: Colors.blueAccent,
                                  ),
                                  Text("Add Address",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.blueAccent,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                      );
                    }
                    else{
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(

                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context,index){
                              var name =snapshot.data?.docs[index]["name"];
                              var addressid=snapshot.data?.docs[index]["addressid"];
                              var flatno=snapshot.data?.docs[index]["flatno"];
                              var address=snapshot.data?.docs[index]["address"];
                              var city=snapshot.data?.docs[index]["city"];
                              var state=snapshot.data?.docs[index]["state"];
                              var locality=snapshot.data?.docs[index]["landmark"];
                              var pincode=snapshot.data?.docs[index]["pincode"];
                              var primary=snapshot.data?.docs[index]["primary"];
                              var trues="true";

                              return Padding(
                                padding: const EdgeInsets.fromLTRB(70,30,30,30),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 340,
                                      padding: const EdgeInsets.all(20),
                                      width: 350,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey
                                          ),
                                          borderRadius: BorderRadius
                                              .circular(10)
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [

                                          Visibility(
                                              visible:primary==trues? true :false ,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: const [
                                                  Padding(padding: EdgeInsets.only(left: 10),
                                                    child: Text("Default : ",
                                                      style:TextStyle(
                                                          color: Colors.grey
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(padding: EdgeInsets.all(5)),
                                                  Divider(
                                                    color: Colors.grey,
                                                    height: 3,
                                                    thickness: 3,
                                                    indent: 3,
                                                  )
                                                ],
                                              )
                                          ),
                                          Padding(padding: const EdgeInsets.all(5)),
                                          Text(name,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(flatno+" "+address+" "+locality,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(city,
                                                style: const TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const Padding(padding: EdgeInsets.only(left: 5)),
                                              Text(state,
                                                style: const TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(pincode,
                                            style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const Padding(padding: EdgeInsets.all(22)),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [

                                              ElevatedButton(
                                                  onPressed: (){
                                                    Navigator.pushReplacement(
                                                        context, MaterialPageRoute(builder: (context) =>  AddressForm(addressid)));
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      fixedSize: const Size(70, 40),
                                                      primary: Colors.white70

                                                  ),
                                                  child: const Text("Edit",
                                                    style: TextStyle(
                                                        fontSize:13 ,
                                                        color: Colors.black
                                                    ),
                                                  )

                                              ),
                                              const Padding(padding: EdgeInsets.all(8)),

                                              ElevatedButton(
                                                  onPressed: (){
                                                    var doc = FirebaseFirestore.instance.collection('Address')
                                                        .doc(FirebaseAuth.instance.currentUser!.uid).
                                                    collection(FirebaseAuth.instance.currentUser!.uid).doc(addressid);
                                                    doc.delete();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      fixedSize: const Size(85, 40),
                                                      primary: Colors.white70
                                                  ),
                                                  child: const Text("Remove ",
                                                    style: TextStyle(
                                                        fontSize:13 ,
                                                        color: Colors.black
                                                    ),
                                                  )

                                              ),
                                              const Padding(padding: EdgeInsets.all(5)),

                                              Visibility(
                                                visible: primary==trues ?
                                                false:true,
                                                child:ElevatedButton(
                                                    onPressed:() async{
                                                      var collection = FirebaseFirestore.instance
                                                          .collection('Address').doc(FirebaseAuth.instance.currentUser!.uid)
                                                          .collection(FirebaseAuth.instance.currentUser!.uid);
                                                      var querySnapshots = await collection.get();
                                                      for (var doc in querySnapshots.docs) {
                                                        await doc.reference.update({
                                                          'primary': 'false',
                                                        }).whenComplete(() =>
                                                            changeprimary(snapshot.data?.docs[index]["addressid"], context)
                                                        );
                                                      }
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        fixedSize: const Size(119, 40),
                                                        primary: Colors.white70
                                                    ),
                                                    child: const Text("Set as Default",
                                                      style: TextStyle(
                                                          fontSize:13 ,
                                                          color: Colors.black
                                                      ),
                                                    )
                                                ),
                                              ),

                                            ],
                                          )

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                        ),
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              const Footer()
            ],
          ),
        )
    );
  }

   changeprimary(addressid,context){


     var change= FirebaseFirestore.instance.collection('Address').doc(FirebaseAuth.instance.currentUser!.uid)
         .collection(FirebaseAuth.instance.currentUser!.uid);

     if (kDebugMode) {
       print(addressid);
     }
     change.doc(addressid).update({
       "primary":"true"
     }).whenComplete((){

       Navigator.pushReplacement(
           context, MaterialPageRoute(builder: (context) =>  const My_Address()));
     });

   }

}
