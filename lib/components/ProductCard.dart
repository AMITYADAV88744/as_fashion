
import 'package:flutter/material.dart';
class ProductCard extends StatefulWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}


class _ProductCardState extends State<ProductCard>{
  late final int index;
  bool isPressed=true;

  @override
  void initState() {
    super.initState();
    isPressed;
  }

  @override
  void dispose() {
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      //child: Padding(
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height/3,
                  width: MediaQuery.of(context).size.width/2,
                  child:  Image.asset('assets/download.png',
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  //color: Colors.white,
                  //padding: const EdgeInsets.all(2),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("A.S Fashion",
                                  textAlign:TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.zero),
                                Text('Mens Grey Cotton Shirt',
                                  textAlign:TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                                Text('Rs. 999',
                                  textAlign:TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
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
                                  if(isPressed==true){
                                    setState(() {
                                      isPressed= false;
                                    });
                                  }
                                  else{
                                    setState(() {
                                      isPressed= true;
                                    });
                                  }},

                              icon: (isPressed)? const Icon(
                                Icons.favorite_border_sharp,
                                size: 20,
                                color: Colors.black,
                              ):const Icon(
                                  Icons.favorite_outlined,
                                  size: 20,
                                color: Colors.redAccent,
                              )

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
      //),
    );
  }

}