import 'dart:async';

import 'package:as_fashion/Screen/MainScreen/MainScreenPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../CustomButton.dart';
import 'Login_Screen.dart';


class Verify_OTP extends StatefulWidget {
  late String phoneNumber,verificationId;
  FirebaseAuth auth = FirebaseAuth.instance;

  late String otp;


  Verify_OTP( {Key? key, required this.phoneNumber, required  this.verificationId,}) : super(key: key);


  @override
  State<Verify_OTP> createState(){

    return _Verify_OTPMobileState(this.phoneNumber,this.verificationId);
  }
}

class _Verify_OTPMobileState extends State<Verify_OTP> {

  late String phoneNumber,verificationId;

  _Verify_OTPMobileState(this.phoneNumber,this.verificationId); ///intent value

  TextEditingController textEditingController = TextEditingController();

  StreamController<ErrorAnimationType>? errorController;
  final formKey = GlobalKey<FormState>();

  String currentText = "";
  bool hasError = false;
  late Timer _timer;
  int _start = 5;
  bool isLoading = false;

  verify(phone,context) async {

    PhoneVerificationCompleted verificationCompleted = (
        PhoneAuthCredential phoneAuthCredential) async {
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
    };

    PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException) {};
    PhoneCodeSent codeSent = (String verificationId,
        [int? forceResendingToken]) async {

    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            isLoading = false;
          });
          verify(phoneNumber, context);
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();

    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    errorController!.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        title: const Text("Verify OTP"),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Code has been sent to",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const SizedBox(height: 30),
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
              Form(
                key: formKey,
                child: PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      fieldHeight: 40,
                      fieldWidth: 40,
                      activeFillColor: Colors.white.withOpacity(0.5),
                      disabledColor: Colors.black.withOpacity(0.5),
                      inactiveColor: Colors.black.withOpacity(0.5),
                      inactiveFillColor: Colors.white,
                      selectedColor: Colors.black.withOpacity(0.5),
                      activeColor: Colors.black.withOpacity(0.5),
                      selectedFillColor: Colors.amber,
                      errorBorderColor: Colors.redAccent),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  controller: textEditingController,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  textStyle: const TextStyle(color: Colors.black),
                  onCompleted: (v) {},
                  onChanged: (value) {
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                  appContext: context,
                ),
              ),
              const SizedBox(height: 30),
              _start != 0
                  ? Row(
                children: [
                  Text(
                    "Resend Code in",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _start.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Don't receive code?",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _start = 5;
                        isLoading = true;
                        startTimer();
                      });
                    },
                    child: Text(
                      "Request again",
                      style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : TextButton(

                  style: TextButton.styleFrom(
                    backgroundColor: Colors.amber,
                    textStyle: const TextStyle(color: Colors.white),
                  ),
                  child:const Text('CONTINUE ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.white
                    ),
                  ),onPressed: () {
                formKey.currentState!.validate();

                if (currentText.length != 6) {
                  errorController!.add(ErrorAnimationType
                      .shake); // Triggering error shake animation
                  setState(() => hasError = true);
                } else {

                  sign_in(context);

                  setState(
                        () {},
                  );
                }
              },
              ),

            ],
          ),
        ),
      ),
    );
  }

  void sign_in(context) async{

    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: currentText,
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

/*
class Verify_OTP extends StatelessWidget {

  late String phoneNumber,verificationId;
  FirebaseAuth auth = FirebaseAuth.instance;

  late String otp;


  Verify_OTP( {Key? key, required this.phoneNumber, required  this.verificationId,}) : super(key: key);

  verify(phone,context) async {

    PhoneVerificationCompleted verificationCompleted = (
        PhoneAuthCredential phoneAuthCredential) async {
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
    };

    PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException) {};
    PhoneCodeSent codeSent = (String verificationId,
        [int? forceResendingToken]) async {

    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      //  backgroundColor: Colors.white,
        leading:  IconButton(
          onPressed:(){

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const LoginScreen()
            ));},
          icon:  const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
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

                 ListTile(
                  trailing: InkWell(
                    onTap: (){
                      verify(phoneNumber, context);
                    },
                    child:const Text('Resend',
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    ),
                  ),
                ),

               const Padding(padding: EdgeInsets.all(20)),
                Container(
                  width: 380,
                  height: 50,
                  decoration:BoxDecoration(
                      border: Border.all(color: Colors.amber),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child:TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.amber,
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


 */