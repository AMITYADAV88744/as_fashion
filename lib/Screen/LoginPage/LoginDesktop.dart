
//...

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/header.dart';
import '../LandingPage/LandingPage.dart';

class LoginDesktop extends StatelessWidget {
  late String _phone;

  //...

  LoginDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
             Header(),
            Row(
              children: [
                Expanded( //<-- Expanded widget
                    child: Image.asset(
                      'assets/AS_LOGO.png',
                      height: 570,
                      fit: BoxFit.fill,
                    )),
                Expanded( //<-- Expanded widget
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 80, 20, 50),
                    child: Column(
                      children: [
                        const Text("Log in / Sign Up",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 35,
                              color: Colors.black
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(15)),
                        const Text(
                          "for Latest trends, exciting offers and many more",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.grey
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(30)),
                        SizedBox(
                          width: 380,
                          height: 70,
                          child: TextFormField(
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.fromLTRB(35,15,0,5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "Enter Mobile Number",
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 26
                              ),

                            ),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ], // Only numbers can be entered
                            maxLength: 10,
                            onChanged: (phone){
                              _phone=phone;
                            },
                          ) ,
                        ),
                        const Padding(padding: EdgeInsets.all(15)),
                        Container(
                          width: 380,
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.pinkAccent),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                                textStyle: const TextStyle(color: Colors.white),
                              ),
                              child: const Text('CONTINUE ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                    color: Colors.white
                                ),
                              ),
                              onPressed: () {

                                login(context);
                              }
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(10)),
                        const SizedBox(
                          width: 480,
                          child: Divider(
                            color: Colors.grey,
                            height: 30,
                            thickness: 3,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(10)),

                        Container(
                            width: 380,
                            height: 50,
                            padding: const EdgeInsets.fromLTRB(50, 0, 10, 0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.email, color: Colors.grey,),
                                Padding(padding: EdgeInsets.only(left: 10)),
                                Text("Continue with Email",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 20
                                  ),
                                ),
                              ],
                            )
                        ),
                        const Padding(padding: EdgeInsets.all(15)),
                        const SizedBox(
                            width: 380,
                            child: Text(
                              "By creating an account or logging in, you agree with AS Fashion's Terms and Conditions and Privacy Policy",
                              maxLines: 2,
                            )

                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  login(context) async {

    final confirmationResult =
    await FirebaseAuth.instance.signInWithPhoneNumber("+91$_phone");
    final smsCode = await getSmsCodeFromUser(context);
    if (smsCode != null) {
      await confirmationResult.confirm(smsCode).catchError((e)
          {
            throw e;

          }
      ).whenComplete(() =>{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LandingPage())),
      });

    }

  }

}


Future<String?> getSmsCodeFromUser(BuildContext context) async {
  String? smsCode;

  // Update the UI - wait for the user to enter the SMS code
  await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('SMS code:'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Sign in'),
          ),
          OutlinedButton(
            onPressed: () {
              smsCode = null;
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
        content: Container(
          padding: const EdgeInsets.all(20),
          child: TextField(
            onChanged: (value) {
              smsCode = value;
            },
            textAlign: TextAlign.center,
            autofocus: true,
          ),
        ),
      );
    },
  );

  return smsCode;
}