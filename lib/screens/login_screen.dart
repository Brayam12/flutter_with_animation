import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
//3.1 importar libreria par Timer
import 'dart:async';

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

  //2.1 Variable para recorrido de la mirada
  SMINumber? numLook; //hacia donde mira


  //1.1  FocusNode 
  final emailFocus=FocusNode();
  final passFocus=FocusNode();

  //3.2 Timer para detener la mirada al dejar de teclear
  Timer? _typingDebounce;

  //2.1 Listeners (oyentes/chismoso)

  @override
  void initState() {
    super.initState();
    emailFocus.addListener((){
    if (emailFocus.hasFocus){
      //Manos abajo en email
      isHandsUp?.change(false);
      //2.2 Mirada neutral al enfocar email
      numLook?.value=50.0;
      isHandsUp?.change(false);
    }
    });
    passFocus.addListener((){
      //Manos arriba en password
      isHandsUp?.change(passFocus.hasFocus);
    });
  }

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
                    trigFail = controller!.findSMI('trigFail');
                    
                    //2.3 Enlazar variable con la animación
                    numLook=controller!.findSMI('numLook');

                    
                  }
                  ),
              ),
              const SizedBox(height: 10),
              // campo de texto del email
              TextField(
                //Asignas el focusNode al TextField
                //Llamas a tu familia chismosa
                focusNode: emailFocus,
                onChanged: (value){
                  if (isHandsUp != null) {
                    //2.4 Implementando numLook
                    //"Estor escribiendo"
                    isChecking!.change(true);

                    //Ajuste de limites de 0 a 100
                    //80 es una medida de calibración
                    final look = (value.length / 80.0 * 100.0).clamp(0.0, 100.0);
                    numLook?.value=look;

                    //3.3 Debounce: Si vuelve a teclear, reinicia el contador
                    _typingDebounce?.cancel(); //Cancela cualquier timer existente
                    _typingDebounce= Timer(const Duration(seconds:2),(){
                      if (!mounted){
                        return; //si la pantalla cierra
                      }
                      //Mirada neutra
                      isChecking?.change(false);
                    });
                    
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
                //Asignas el focusNode al TextField
                //Llamas a tu familia chismosa
                focusNode: passFocus,
                onChanged: (value){
                  if (isChecking != null) {
                    //No tapar los ojos al escribir email
                    //isChecking!.change(false);
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
  //1.4 Liberación de recursos/Limpieza de focos
  @override
  void dispose(){
    emailFocus.dispose();
    passFocus.dispose();
    _typingDebounce?.cancel();
    super.dispose();
  }
}
