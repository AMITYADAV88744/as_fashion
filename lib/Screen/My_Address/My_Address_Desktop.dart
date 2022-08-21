
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
                stream:addRef.collection(FirebaseAuth.instance.currentUser!.uid).snapshots() ,
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
                                      .circular(1)
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
                                padding: EdgeInsets.fromLTRB(70,30,30,30),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 250,
                                      padding: const EdgeInsets.all(20),
                                      width: 350,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey
                                          ),
                                          borderRadius: BorderRadius
                                              .circular(1)
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
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
                                          primary==trues
                                              ? const Text("Primary Address",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey
                                            ),
                                          ):TextButton(
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
                                              child:const Text("Set as primary address",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              )
                                          )

                                        ],
                                      ),
                                    ),
                                    Container(
                                        height: 50,
                                        width: 350,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey
                                            ),
                                            borderRadius: BorderRadius
                                                .circular(1)
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                              child: const Text(
                                                "Edit",
                                                style: TextStyle(
                                                    fontSize: 20
                                                ),
                                              ),
                                              onPressed:(){
                                                Navigator.pushReplacement(
                                                    context, MaterialPageRoute(builder: (context) =>  AddressForm_D()));
                                              },
                                            ),
                                            const VerticalDivider(width: 5,thickness: 3,),
                                            TextButton(
                                              child: const Text(
                                                "Remove",
                                                style: TextStyle(
                                                    fontSize: 20
                                                ),
                                              ),
                                              onPressed:(){
                                                var doc = FirebaseFirestore.instance.collection('Address')
                                                    .doc(FirebaseAuth.instance.currentUser!.uid).
                                                collection(FirebaseAuth.instance.currentUser!.uid).doc(addressid);
                                                doc.delete();

                                              },

                                            ),
                                          ],
                                        )
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
              )
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
