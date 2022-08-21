import 'package:as_fashion/Screen/MainScreen/MainScreenPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import 'Login_Screen.dart';

class Verify_OTP extends StatelessWidget {

  late String phoneNumber,verificationId;
  FirebaseAuth auth = FirebaseAuth.instance;

  late String otp;


  Verify_OTP( {Key? key, required this.phoneNumber, required  this.verificationId,}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading:  IconButton(
          onPressed:(){

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const LoginScreen()
            ));},
          icon:  const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.grey,
          ),
        ),
        title: const Text('A.S Fashion',
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.only(top: 50),
          child:Container(

            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 450,
            child: ListView(
              padding: const EdgeInsets.all(25),
              shrinkWrap: true,
              children:   [
                const Text(
                  'Verify with OTP',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 22
                  ),
                ),
                const Padding(padding: EdgeInsets.all(15)),
                TextField(
                  enabled: false,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.cyan
                      ),
                    ),
                    labelText: "Send to",
                  ),
                  controller: TextEditingController(
                    text: phoneNumber,
                  ),
                  style: const TextStyle(
                    color:Colors.grey,
                    fontWeight:FontWeight.bold,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(15)),
                const Text('     Enter OTP',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                  ),
                ),
                OTPTextField(
                  length: 6,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 35,
                  style: const TextStyle(
                      fontSize: 15
                  ),
                  textFieldAlignment: MainAxisAlignment.spaceAround,

                  fieldStyle: FieldStyle.underline,
                  onCompleted: (pin) {
                    otp=pin;
                    //print("Completed: " + pin);

                  },
                ),
                /*
                 ListTile(
                  trailing: InkWell(
                    onTap: (){
                    },
                    child:const Text('Resend',
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    ),
                  ),
                ),

                 */
               const Padding(padding: EdgeInsets.all(20)),
                Container(
                  width: 380,
                  height: 50,
                  decoration:BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child:TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                      child:const Text('CONTINUE ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: Colors.white
                        ),
                      ),
                      onPressed: () {
                        sign_in(context);
                      }
                  ),
                ),

              ],
            ),
          )
      ),
    );
  }







  void sign_in(context) async{

    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final User? user = (await FirebaseAuth.instance.signInWithCredential(credential).whenComplete((){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreenPage()));

      })).user;

      if (kDebugMode) {
        print(user!.phoneNumber);
      }


    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
