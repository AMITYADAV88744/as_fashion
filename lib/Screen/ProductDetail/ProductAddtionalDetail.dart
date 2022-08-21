import 'package:color_parser/color_parser.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/extenstion.dart';
import '../../model/product_model.dart';

class ProductAddtionalDetail extends StatelessWidget {
  String pid;
   ProductAddtionalDetail(this.pid, {Key? key}) : super(key: key);


  final DatabaseReference dbRef =
  FirebaseDatabase.instance.reference().child('Products').reference();
  late ProductModel _productModel;
  List<Color> col=[];
  // ColorParser parser;
  List<String> colname=[];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FutureBuilder(
            future: dbRef.child(pid).get(),
            builder: (context,AsyncSnapshot<DataSnapshot> snapshot){
              if(snapshot.hasData){
                _productModel=ProductModel.fromJson(snapshot.data!.value);
                List sizes=_productModel.size;
                colname.clear();
                for(int i=0;i<_productModel.color.length;i++){
                  col.add(HexColor.fromHex(_productModel.color[i]));
                  colname.add(ColorParser.hex(_productModel.color[i]).toName().toString());
                  print(colname);
                }
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 450,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15,15,70,15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Additional  Details",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              ),
                            ),

                          ],
                        ),
                        const Padding(padding: EdgeInsets.all(15)),
                         _productModel.subcategory=="Shirts"?shirt():t_shirt(),
                        const Padding(padding: EdgeInsets.all(10)),

                        const Padding(padding: EdgeInsets.only(top: 20)),
                        const Text("Details",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(_productModel.discrip,
                          maxLines: 4,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.normal
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              }
              return Center(child: CircularProgressIndicator(),);
            }
        )
    );
  }

  Widget shirt() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:   [
            const Text("Sleeve",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(_productModel.sleevtyp,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.all(10)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:   [
            const Text("Fabric",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(_productModel.fabrictyp,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.all(10)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:   [
            const Text("Neck Type",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(_productModel.necktyp,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.all(10)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:   [
            const Text("Pattern ",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(_productModel.pattertyp,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget t_shirt() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:   [
            const Text("Sleeve",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(_productModel.sleevtyp,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.all(10)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:   [
            const Text("Fabric",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(_productModel.fabrictyp,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.all(10)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:   [
            const Text("Collar Type",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(_productModel.necktyp,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.all(10)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:   [
            const Text("Pattern ",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(_productModel.pattertyp,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.all(10)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:   [
            const Text("Color ",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(colname.join(' , ').toString(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ],
    );
  }
}
