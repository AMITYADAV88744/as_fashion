
import 'package:as_fashion/Screen/LandingPage/LandingPage.dart';
import 'package:as_fashion/Screen/MainScreen/MainScreenMobileView.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/MenuController.dart';

class MainScreenPage extends StatelessWidget {
  const MainScreenPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {

              if (kDebugMode) {
                print("-----MainScreenMobile------");
              }
              return   const DoubleBackToCloseApp(
                  snackBar: SnackBar(content: Text('Tap back again to leave'),),
                  child: MainScreenMobile()
              );
            } else if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
              if (kDebugMode) {
                print("-----MainScreenMobile------");
              }

              return  const MainScreenMobile();
            } else {
              if (kDebugMode) {
                print("-----LandingPage------");
              }

              return   LandingPage("Product");
            }
          },
        )
    );
  }
}




class MainScreenMobile  extends StatelessWidget{
  const MainScreenMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuController(),
        ),
      ],
      child:const MainScreenMobileView()
    );

  }

}
