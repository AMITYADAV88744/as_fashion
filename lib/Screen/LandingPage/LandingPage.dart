
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/MenuController.dart';
import 'LandingDesktopScreen.dart';
import 'LandingMobileScreen.dart';

class LandingPage extends StatelessWidget {
  String title;
   LandingPage(this.title, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context ) {
    return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {

            if (constraints.maxWidth < 600) {
              return   LandingMobile(title);
            } else if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
              return   LandingMobile(title);
            } else {
              return  const LandingDesktop();
            }
          },
        )
    );
  }
}

class LandingMobile  extends StatelessWidget{
  String title;
   LandingMobile( this.title, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var titles=title;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuController(),
        ),
      ],
      child:   LandingMobileScreen(titles),
    );

  }

}

class LandingDesktop  extends StatelessWidget{
const LandingDesktop({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => MenuController(),
      ),
    ],
    child:   const LandingDesktopScreen(),
  );

}

}
