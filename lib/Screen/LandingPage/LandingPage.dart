
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/MenuController.dart';
import 'LandingDesktopScreen.dart';
import 'LandingMobileScreen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context ) {
    return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return  const LandingMobile();
            } else if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
              return  const LandingDesktop();
            } else {
              return  const LandingDesktop();
            }
          },
        )
    );
  }
}

class LandingMobile  extends StatelessWidget{
  const LandingMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuController(),
        ),
      ],
      child:  const LandingMobileScreen(),
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
