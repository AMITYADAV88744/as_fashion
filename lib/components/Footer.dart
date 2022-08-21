
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
   const Footer({Key? key}) : super(key: key);

   final double defaulttext=12;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Padding(
            padding: const EdgeInsets.all(30),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Customer Serives",
                      style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: defaulttext

                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text(
                      "Contact Us",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: defaulttext
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text(
                      "Track Order",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: defaulttext
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text(
                      "Return Order",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: defaulttext
                      ),
                    ),

                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Company Serives",
                      style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: defaulttext

                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text(
                      "About Us",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: defaulttext
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text(
                      "Terms & Conditions",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: defaulttext
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text(
                      "Privacy Policy",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: defaulttext
                      ),
                    ),
                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Connect with us",
                      style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: defaulttext

                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text(
                      "Instagram",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: defaulttext
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Text(
                      "Facebook",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: defaulttext
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                  ],
                ),
              ],
            )
        )
    );
  }
}
