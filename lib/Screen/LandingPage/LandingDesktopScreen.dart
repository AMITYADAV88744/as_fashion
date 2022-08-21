
import 'package:as_fashion/components/Footer.dart';
import 'package:as_fashion/components/ProductGridView.dart';
import 'package:as_fashion/components/header.dart';
import 'package:flutter/material.dart';

class LandingDesktopScreen extends StatelessWidget {
  const LandingDesktopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int s=0;
    double defaulttext=12;

    return Scaffold(
        body:SingleChildScrollView(
          child: Column(
            children: [
              Header(),
              const Padding(padding: EdgeInsets.zero),
              Container(
                padding: const EdgeInsets.fromLTRB(200, 10, 120, 0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/1.2,
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:  [

                    Expanded( //<-- Expanded widget
                      flex: 3,
                        child:SizedBox(
                            child: ListView(
                              children:  const [
                                ExpansionTile(

                                  title: Text('Category'),
                                  children: <Widget>[
                                    InkWell(
                                      child:ListTile(title: Text('T-shirt')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Gym Vest')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Oversized')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('ETC')),
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text('Sizes'),
                                  children: <Widget>[
                                    InkWell(
                                      child:ListTile(title: Text('S')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('M')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('L')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('XL')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('XXL')),
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text('Color'),
                                  children: <Widget>[
                                    InkWell(
                                      child:ListTile(title: Text('S')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('M')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('S')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('M')),
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text('Design'),
                                  children: <Widget>[
                                    InkWell(
                                      child:ListTile(title: Text('Printed')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Solid')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Plain')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Color Block')),
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text('Fit'),
                                  children: <Widget>[
                                    InkWell(
                                      child:ListTile(title: Text('Regular Fit')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Oversized')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Slim Fit')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Relaxed Fit')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Super Loose')),
                                    ),
                                  ],
                                ),ExpansionTile(
                                  title: Text('Sleeve'),
                                  children: <Widget>[
                                    InkWell(
                                      child:ListTile(title: Text('Half Sleeve')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Full Sleeve')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Sleeveless')),
                                    ),

                                  ],
                                ),ExpansionTile(
                                  title: Text('Neck'),
                                  children: <Widget>[
                                    InkWell(
                                      child:ListTile(title: Text('Round Neck')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Hood')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Polo')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Shirt Collar')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text(' Collar')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Crew Neck')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('V-Neck')),
                                    ),
                                  ],
                                ),ExpansionTile(
                                  title: Text('Type'),
                                  children: <Widget>[
                                    InkWell(
                                      child:ListTile(title: Text('T-Shirt')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Vest')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Sweatshirt')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Hoodies')),
                                    ),
                                  ],
                                ),ExpansionTile(
                                  title: Text('Discount'),
                                  children: <Widget>[
                                    InkWell(
                                      child:ListTile(title: Text('10 % Or More')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('20 % Or More')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('30 % Or More')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('40 % Or More')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('50 % Or More')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('60 % Or More')),
                                    ),

                                  ],
                                ),ExpansionTile(
                                  title: Text('Sort By'),
                                  children: <Widget>[
                                    InkWell(
                                      child:ListTile(title: Text('Popular')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Newest')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Price:High to Low')),
                                    ),
                                    InkWell(
                                      child:ListTile(title: Text('Price: Low to High')),
                                    ),
                                  ],
                                ),
                              ],
                            )
                        )
                    ),
                     Expanded( //<-- Expanded widget
                       flex: 7,
                      child:ProductGridView(s)
                    ),
                  ],
                ),
              ),
              const Footer()
            ],
          ),
        )
    );
  }
}
