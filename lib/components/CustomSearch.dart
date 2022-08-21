
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../Screen/ProductDetail/product_details.dart';
import '../model/product_model.dart';


var textColor = const Color(0xff727272);

class CustomSearchDelegate extends SearchDelegate {
var suggestion = [];
List<ProductModel> searchResult = [];
final List<ProductModel> _productModel = [];
//List<ProductModel> get productModel => _productModel;


@override
List<Widget> buildActions(BuildContext context) {
  return [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        query=' ';
      },
    ),
  ];
}

@override
Widget buildLeading(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      close(context, null);
    },
  );
}

@override
Widget buildResults(BuildContext context) {
  searchResult.clear();
  print("Ater clear${searchResult.length}");

  DatabaseReference ref=FirebaseDatabase.instance.reference().child("Products").reference();
//  ref.get();
  ref.get().then((DataSnapshot snapshot) {
    _productModel.clear();
    final map = snapshot.value as Map<dynamic, dynamic>;
    map.forEach((key, value) {
       _productModel.add(ProductModel.fromJson(value));
    });
  });
  //print(_productModel[1].pname);
  //searchResult=_productModel.contains(query).toString() as List<ProductModel>;
  searchResult=_productModel.where((element) => element.pname.toLowerCase().startsWith(query.toLowerCase())).toList();
  print("Ater add${searchResult.length}");

  if(suggestion.contains(query)){

    print(0);
  }else{
    print(1);
    suggestion.add(query);
  }
  if(searchResult.isEmpty){
    return Center(child: Text("Item not found"),);
  }else{
    return AlignedGridView.count(
        controller: ScrollController(),
        //scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        itemCount:searchResult.length,
        itemBuilder: (context, index) {
          var pri=searchResult[index].l_price-(searchResult[index].discount*searchResult[index].l_price)~/100;

          return GestureDetector(
            onTap: () {
              var pid=searchResult[index].pid;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  ProductDetails(pid,"Product Detail")));
            },
            child: Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: Column(
                  children: [
                    ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height/4,
                          width: MediaQuery.of(context).size.width/2.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:Image.network(
                            searchResult[index].image[0],
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(2),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:  [
                                        Text(searchResult[index].brand,
                                          textAlign:TextAlign.left,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const Padding(padding: EdgeInsets.zero),
                                        Text(searchResult[index].pname,
                                          textAlign:TextAlign.left,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Row(
                                          children:  [
                                            Text(pri.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const Padding(padding: EdgeInsets.all(1),),
                                            Text(searchResult[index].l_price.toString(),
                                              style: const TextStyle(
                                                decoration: TextDecoration.lineThrough,
                                                color: Colors.grey,
                                                fontSize: 10,
                                              ),
                                            ),
                                            const Padding(padding: EdgeInsets.all(1),),
                                            Text('${searchResult[index].discount}% OFF',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.green,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.zero),
                                ],
                              ),
                              Positioned(
                                //bottom: 5,
                                right: 0,
                                child: Column(
                                  children: [
                                    IconButton(
                                      onPressed:() {
                                        // _wishList(index);
                                      },
                                      icon: const Icon(
                                        Icons.favorite_border_sharp,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}

@override
Widget buildSuggestions(BuildContext context) {
  // This method is called everytime the search term changes.
  final suggestionList = query.isEmpty
      ? suggestion
      : suggestion;
  return ListView.builder(
    itemBuilder: (context, index) => ListTile(
      onTap: () {
        if(query.isEmpty) {
          query = suggestion[index];
        }
      },
      leading: Icon(query.isEmpty ? Icons.history : Icons.search),
      title:
      RichText(
          text: TextSpan(
              text: suggestionList[index],
              style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
           )),
    ),
    itemCount: suggestionList.length,
  );
}
}
