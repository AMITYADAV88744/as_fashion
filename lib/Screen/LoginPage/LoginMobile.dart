
import 'package:as_fashion/Screen/MainScreen/MainScreenPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Verify_OTP.dart';
class LoginMobile extends StatefulWidget {
  const LoginMobile({Key? key}) : super(key: key);

  @override
  State<LoginMobile> createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> {
  late String _phone;
  late  bool _loading = false;


  verify(phone,context) async {
    setState(() {
      _loading=true;
    });

    PhoneVerificationCompleted verificationCompleted = (
        PhoneAuthCredential phoneAuthCredential) async {
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
    };

    PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException) {};
    PhoneCodeSent codeSent = (String verificationId, [int? forceResendingToken]) async {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Verify_OTP(
                phoneNumber: phone,
                verificationId: verificationId,
              )
          )
      );
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$_phone',
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},

    );
  }

  @override
  Widget build(BuildContext context) {

    var body = Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: SizedBox(
              width: 300,
              child:  Column(
                children:  [
                  const Text("Log in / Sign Up",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 35,
                        color: Colors.black
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(15)),
                  const Text("for Latest trends, exciting offers and many more",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.grey
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(30)),
                  SizedBox(
                    width: 400,
                    child:TextFormField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Enter Mobile Number",
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20
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
                          var phone='+91$_phone';
                          verify(phone,context);

                          //var phone=_phone;
                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  Verify_OTP(phone)));
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
                 /* const Padding(padding: EdgeInsets.all(10)),

                  Container(
                    width: 380,
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(50, 0, 10, 0),
                    decoration:BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child:Row(
                      children: const [
                        Icon(Icons.email,color: Colors.grey,),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text("Continue with Email",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontSize: 20
                          ),
                        ),
                      ],
                    ),
                  ),

                 */
                  const Padding(padding: EdgeInsets.all(15)),
                  const SizedBox(
                    width: 380,
                    child: Text("By creating an account or logging in, you agree with AS Fashion's Terms and Conditions and Privacy Policy",
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    var bodyProgress = Container(
      child: Stack(
        children: <Widget>[
          body,
          Container(
            alignment: AlignmentDirectional.center,
            decoration: const BoxDecoration(
              color: Colors.white70,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(10.0)
              ),
              width: 150.0,
              height: 100.0,
              alignment: AlignmentDirectional.center,
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Center(
                    child:  SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child:  CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child:  const Center(
                      child:  Text(
                        "loading.. wait...",
                        style:  TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading:IconButton(
            onPressed:(){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const MainScreenPage()
              ));},
            icon:const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.grey,
            ),
          ),
          title: const Text('A.S Fashion',style: TextStyle(color: Colors.black),),
        ),
        body:_loading ? bodyProgress : body
    );

  }

}
