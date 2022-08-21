
import 'package:as_fashion/Screen/ProductDetail/ProductDetailDesktop.dart';
import 'package:as_fashion/components/ProductGridView.dart';
import 'package:as_fashion/components/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../components/ProductCard.dart';

class LandingDesktopScreen extends StatelessWidget {
  const LandingDesktopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SingleChildScrollView(
          child: Column(
            children: [
              Header(),
              const Padding(padding: EdgeInsets.zero),
              Container(
                padding: const EdgeInsets.fromLTRB(50, 10, 10, 0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:  [
                    Expanded( //<-- Expanded widget
                        child:SizedBox(
                            width: MediaQuery.of(context).size.width/3,
                            child: ListView(
                              children: const [
                                Text(''),
                                Text(''),

                              ],

                            )

                        )
                    ),
                    const Expanded( //<-- Expanded widget
                      child:ProductGridView()
                    ),
                  ],
                ),
              )

            ],
          ),
        )
    );
  }
}
