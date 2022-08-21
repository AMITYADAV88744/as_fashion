import 'package:flutter/material.dart';

class SizeSlector extends StatefulWidget {

  var selected;

   SizeSlector({Key? key}) : super(key: key);
  @override
  State<SizeSlector> createState() => _SizeSlectorState();
}

class _SizeSlectorState extends State<SizeSlector> {
  String func="";
  late List<String> sizes = ["S", "M", "L", "XL"];
  late String selectedSize="M";


  @override
  Widget build(BuildContext context) {
    return  StatefulBuilder(builder: (context, StateSetter setstate){
      return Row(
        children: List.generate(
            sizes.length,
                (index) =>
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Material(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(3),
                      onTap: (){
                        setState(() {
                          selectedSize=sizes[index];

                          //print(selectedSize);
                        });

                      },
                      child: Ink(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: selectedSize == sizes[index]
                                ? Color(0xFF667EEA)
                                : Color(0xFFF3F3F3),
                            borderRadius: BorderRadius.circular(3)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            sizes[index],
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                color: selectedSize == sizes[index]
                                    ? Colors.white
                                    : Colors.black87),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
      );

    }
    );
  }
}
