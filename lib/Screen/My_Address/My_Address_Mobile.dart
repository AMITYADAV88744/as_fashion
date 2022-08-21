
import 'package:as_fashion/api_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../MainScreen/MainScreenPage.dart';
import 'AddressForm.dart';

class MyAddressMobile extends StatelessWidget {

   MyAddressMobile({Key? key}) : super(key: key);

  final addRef=FirebaseFirestore.instance.collection("Address").doc(FirebaseAuth.instance.currentUser?.uid);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("_______________MyAddressMobile______________");
    }
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
          onPressed:(){
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const MainScreenPage()
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
        actions:  [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 30, 5),
            child: InkWell(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  AddressFormAdd()));
              },
              child: const Icon(Icons.add,
                size: 30,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body:StreamBuilder<QuerySnapshot>(
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
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) =>  AddressFormAdd()
                      ));
                    },
                    child: Container(
                      height: 280,
                      width: MediaQuery.of(context).size.width,
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
              return ListView.builder(
                shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context,index){
                  var name=snapshot.data?.docs[index]["name"];
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
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Container(
                            height: 280,
                            padding: const EdgeInsets.fromLTRB(20,20,20,11),
                            width: MediaQuery.of(context).size.width,
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
                                primary==trues ?
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text("Default : ",
                                      style:TextStyle(
                                        fontSize: 15,
                                          color: Colors.grey
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.all(5)),
                                    Divider(
                                      color: Colors.grey,
                                      height: 3,
                                      thickness: 1,
                                      indent: 3,
                                    )
                                  ],
                                ):Visibility(
                                    visible:false  ,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text("Default : ",
                                          style:TextStyle(
                                              color: Colors.grey
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.amber,
                                          height: 3,
                                          thickness: 3,
                                          indent: 3,
                                        )
                                      ],
                                    )
                                ),
                                const Padding(padding: EdgeInsets.all(5)),
                                Text(name,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.all(5)),
                                Text(flatno+" "+address+" "+locality,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(city,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Padding(padding: EdgeInsets.only(left: 5)),
                                    Text(state,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(pincode,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.all(10)),
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
                                            primary: Colors.amber

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
                                                  //changeprimary(snapshot.data?.docs[index]["addressid"], context)
                                             // addressid=snapshot.data?.docs[index]["addressid"]
                                                ApiService().address_as_default(snapshot.data?.docs[index]["addressid"].toString(), context)
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

              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }



}



