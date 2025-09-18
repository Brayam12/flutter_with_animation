import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variable para controlar si se oculta o no la contraseña
  bool _isObscure = true;

  //Cerebro de la logica de as animaciones
  StateMachineController? controller;
  //SMI: State Machine Input
  SMIBool? isChecking; //Se pone a ver lo que escribimos
  SMIBool? isHandsUp; //Se tapa los ojos
  SMITrigger? trigSuccess; //se emociona
  SMITrigger? trigFail; //se entristece


  @override
  Widget build(BuildContext context) {
    // para obtener el tamaño de la pantalla del disp.
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      // evita notch o cámaras frontales
      body: SafeArea(
        // margen interior
        child: SingleChildScrollView( // envuelve todo para evitar overflow
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: 200,
                child: RiveAnimation.asset(
                  'assets/animated_login_character.riv',
                  stateMachines: ['Login Machine'],
                  //Al iniciarse 
                  onInit:(artboard){
                    controller =
                     StateMachineController.fromArtboard(
                      artboard, 'Login Machine',
                      );
                      //Verificar que inicio bien
                    if (controller == null) return;
                    artboard.addController(controller!);
                    isChecking = controller!.findSMI('isChecking');
                    isHandsUp = controller!.findSMI('isHandsUp');
                    trigSuccess = controller!.findSMI('trigSuccess');
                    trigSuccess = controller!.findSMI('trigFail');
                  }
                  ),
              ),
              const SizedBox(height: 10),
              // campo de texto del email
              TextField(
                onChanged: (value){
                  if (isHandsUp != null) {
                    //No tapar los ojos al escribir email
                    isHandsUp!.change(false);
                  }
                  if (isChecking == null) return;
                  //Activar el modo chismoso
                  isChecking!.change(true);
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // campo de texto de la contraseña
              TextField(
                onChanged: (value){
                  if (isChecking != null) {
                    //No tapar los ojos al escribir email
                    isChecking!.change(false);
                  }
                  if (isHandsUp == null) return;
                  //Activar el modo chismoso
                  isHandsUp!.change(true);
                },
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "¿Forgot your password?",
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
             
              const SizedBox(height: 10),
              //Boton estilo Android
              MaterialButton(
                minWidth: size.width,
                height: 50,
                color: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onPressed: (){},
                child: Text("Login", style: TextStyle(color: Colors.white),),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width,
                child: Row(
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: (){},
                      child: const Text("Register",
                      style: TextStyle(color:Colors.black, 
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      ),
                      )
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
