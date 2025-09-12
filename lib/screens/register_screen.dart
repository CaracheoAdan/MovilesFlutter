import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers
  final conUser = TextEditingController();
  final conPwd = TextEditingController();
  final conNombre = TextEditingController();

  // Image picker y avatar deben ser campos del State
  final ImagePicker _picker = ImagePicker();
  XFile? _avatar;

  bool isValidating = false;

  @override 
  void dispose() { //El dipose liberar recursos de el textEditingController pero mantiene los listeners, si no los liveramos puede tener figas de memoria y causar errores.
    conUser.dispose();
    conPwd.dispose();
    conNombre.dispose();
    super.dispose();
  }
 Future<void> _pick(ImageSource source) async {
    final XFile? file = await _picker.pickImage(
      source: source, //eliges si es camara o galeria
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (file == null) return;
    setState(() => _avatar = file);
  }
   ImageProvider? _avatarProvider() {
    if (_avatar == null) return null; //Si el usuario aún no eligió foto, devolvemos null para que el CircleAvatar muestre el child (tu ícono de persona).
    return kIsWeb
        ? NetworkImage(_avatar!.path)                    // En Web, image_picker entrega un blob URL (no un archivo). Se muestra con NetworkImage.
        : FileImage(File(_avatar!.path)) as ImageProvider; // En Android/iOS, te da una ruta de archivo. Se muestra con FileImage(File(...)).
  }

  void _showSource() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Elegir de galería'),
              onTap: () { Navigator.pop(context); _pick(ImageSource.gallery); },
            ),
            if (_picker.supportsImageSource(ImageSource.camera))
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Tomar foto'),
                onTap: () { Navigator.pop(context); _pick(ImageSource.camera); },
              ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final txtNombre = TextField(
      controller: conNombre,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(hintText: 'Nombre completo'),
    );
    final txtUser = TextField(
      controller: conUser,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(hintText: 'Correo electrónico'),
    );
    final txtPwd = TextField(
      controller: conPwd,
      obscureText: true,
      decoration: const InputDecoration(hintText: 'Contraseña'),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondo1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const Positioned(
              top: 200,
              child: Text(
                'Register',
                style: TextStyle(
                  color: Color(0xFFE5E2E2),
                  fontSize: 35,
                  fontFamily: 'Cholo',
                ),
              ),
            ),
            // Avatar
            Positioned(
              top: 240,
              child: GestureDetector(
                onTap: _showSource,
                child: CircleAvatar(
                  radius: 56,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _avatarProvider(),
                  child: _avatar == null
                      ? const Icon(Icons.person, size: 48, color: Colors.white70)
                      : null,
                ),
              ),
            ),
            // Card con formulario
            Positioned(
              bottom: 80,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView(
                  children: [
                    txtNombre,
                    txtUser,
                    txtPwd,
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        isValidating = true;
                        setState(() {});
                        Future.delayed(const Duration(milliseconds: 3000)).then((_) {
                          // Aquí procesa tu registro; _avatar?.path contiene la ruta/URL
                          if (!mounted) return;
                          Navigator.pushNamed(context, '/login');
                        });
                      },
                      child: const Text("Register", style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ),
            ),
            // Loader Lottie
            Positioned(
              top: 300,
              child: isValidating
                  ? Lottie.asset("assets/loading2.json", height: 200)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
