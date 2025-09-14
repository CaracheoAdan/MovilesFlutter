import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Soporte de cámara en móvil (no Web) - lo dejamos como estaba
  final canUseCamera = !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  // ✅ Form key para validaciones
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final conUser = TextEditingController();
  final conPwd = TextEditingController();
  final conNombre = TextEditingController();

  // Image picker y avatar
  final ImagePicker _picker = ImagePicker();
  XFile? _avatar;

  bool isValidating = false;

  @override
  void dispose() {
    // El dispose libera recursos del TextEditingController; si no lo liberamos puede haber fugas de memoria y causar errores.
    conUser.dispose();
    conPwd.dispose();
    conNombre.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    final XFile? file = await _picker.pickImage(
      source: source, // eliges si es camara o galeria
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (file == null) return;
    setState(() => _avatar = file);
  }

  ImageProvider? _avatarProvider() {
    if (_avatar == null) return null;
    return FileImage(File(_avatar!.path)); // solo Android/iOS
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
              onTap: () {
                Navigator.pop(context);
                _pick(ImageSource.gallery);
              },
            ),
            // Lo dejamos como estaba: usando supportsImageSource
            if (_picker.supportsImageSource(ImageSource.camera))
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Tomar foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pick(ImageSource.camera);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Campos con validación (solo cambiamos esto)
    final txtNombre = TextFormField(
      controller: conNombre,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(hintText: 'Nombre completo'),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'El nombre es obligatorio';
        return null;
      },
    );

    final txtUser = TextFormField(
      controller: conUser,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(hintText: 'Correo electrónico'),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
      validator: (v) {
        final value = (v ?? '').trim();
        if (value.isEmpty) return 'El correo es obligatorio';
        if (!EmailValidator.validate(value)) return 'Formato de correo inválido';
        return null;
      },
    );

    final txtPwd = TextFormField(
      controller: conPwd,
      obscureText: true,
      decoration: const InputDecoration(hintText: 'Contraseña'),
      validator: (v) {
        if (v == null || v.isEmpty) return 'La contraseña es obligatoria';
        if (v.length < 6) return 'Mínimo 6 caracteres';
        return null;
      },
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                // ✅ Form con _formKey y validación en el botón
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: ListView(
                    children: [
                      txtNombre,
                      txtUser,
                      txtPwd,
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isValidating
                              ? null
                              : () {
                                  FocusScope.of(context).unfocus(); // cierra teclado
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => isValidating = true);
                                    Future.delayed(
                                      const Duration(milliseconds: 3000),
                                    ).then((_) {
                                      if (!mounted) return;
                                      setState(() => isValidating = false);
                                      Navigator.pushNamed(context, '/login');
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Corrige los campos marcados'),
                                      ),
                                    );
                                  }
                                },
                          child: const Text(
                            "Register",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
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
