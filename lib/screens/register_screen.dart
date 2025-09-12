import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
 TextEditingController conUser = TextEditingController();
  TextEditingController conPwd = TextEditingController();
    bool isValidating = false;


  @override
  Widget build(BuildContext context) {


    final txtUser=TextField(
      keyboardType: TextInputType.emailAddress,
      controller: conUser,
      decoration: InputDecoration(
        hintText: 'Correo Electronico homie'
      ),
    );

    final txtPwd=TextField(
      obscureText: true,
      controller: conPwd,
      decoration: InputDecoration(
        hintText: 'Contraseña'
      ),
    );

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/fondo1.png")
          )
        ),  
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 200,
              child: Text('Caracheo App',style:  TextStyle(color: const Color.fromARGB(255, 229, 226, 226), fontSize: 35, fontFamily: 'Cholo'),
              ),
            ),
            Positioned( 
              bottom: 80,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width:  MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .35,
                  decoration: BoxDecoration(
                     color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: ListView(
                    children: [
                      txtUser,
                      txtPwd,
                     IconButton(
                      onPressed: () {
                        isValidating = true;
                        setState(() {});
                        Future.delayed(const Duration(milliseconds: 3000)).then((value) {
                          Navigator.pushNamed(context, '/home');                          // De esta manera navegas hacia la siguiente pantalla
                      });
                      },
                       icon: Icon(
                         Icons.login,
                         size: 40,
                       ),
                      ),
                      IconButton(
                        onPressed: (){
                          isValidating = true;
                          setState(() {});
                          Future.delayed(const Duration(milliseconds: 3000)).then((value){
                            Navigator.pushNamed(context, '/register');
                          });
                        },
                         icon: Icon(
                          Icons.book,
                         size: 40,
                         ))
                    ],
                  ),
                )
            ),
           Positioned(
              top: 300,
              child: isValidating
                  ? Lottie.asset("assets/loading2.json", height: 200)
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
