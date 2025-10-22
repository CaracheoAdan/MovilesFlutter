import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movilesejmplo1/firebase/fire_auth.dart';

class ChallengefigmaScreen extends StatefulWidget {
  const ChallengefigmaScreen({super.key});

  @override
  State<ChallengefigmaScreen> createState() => _ChallengefigmaScreenState();
}

class _ChallengefigmaScreenState extends State<ChallengefigmaScreen> {
  final _formKey = GlobalKey<FormState>();
  final conUser = TextEditingController();
  final conPwd = TextEditingController();

  late final FireAuth _fireAuth;
  bool isValidating = false;

  Color get _brandYellow => const Color(0xFFFFB000);
  Color get _cardGray => const Color(0xFFE8E8E8);

  @override
  void initState() {
    super.initState();
    _fireAuth = FireAuth();
  }

  @override
  void dispose() {
    conUser.dispose();
    conPwd.dispose();
    super.dispose();
  }

  InputDecoration _fieldDeco(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: Colors.black54),
        filled: true,
        fillColor: _cardGray,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: _cardGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.black87, width: 1),
        ),
      );

  Widget _socialButton({
    required IconData icon,
    required String label,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              FaIcon(icon, size: 24, color: iconColor ?? Colors.black87),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const Icon(Icons.arrow_right_alt, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    if (isValidating) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => isValidating = true);
    try {
      final user = await _fireAuth.signInWithEmailAndPassword(
        conUser.text.trim(),
        conPwd.text.trim(),
      );

      if (!mounted) return;
      if (user != null) {
        Navigator.pushNamed(context, '/Mealfigma');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo iniciar sesión')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de autenticación: $e')),
      );
    } finally {
      if (mounted) setState(() => isValidating = false);
    }
  }

  String? _emailValidator(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return 'El correo es obligatorio';
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(s);
    return ok ? null : 'Correo no válido';
  }

  String? _pwdValidator(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return 'La contraseña es obligatoria';
    if (s.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Header amarillo
          Container(
            height: 140,
            color: _brandYellow,
            padding:
                const EdgeInsets.only(top: 40, left: 12, right: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  splashRadius: 22,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 12, right: 6),
                  child: Text(
                    'Register',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Cuerpo
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 124),
                Text(
                  'Sign In',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w800,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(height: 22),

                // ---------- FORM ----------
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: conUser,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _fieldDeco('Email'),
                        validator: _emailValidator,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: conPwd,
                        obscureText: true,
                        decoration: _fieldDeco('Password'),
                        validator: _pwdValidator,
                        onFieldSubmitted: (_) => _signIn(),
                        style: const TextStyle(color: Colors.black),
                        cursorColor: Colors.black,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Botón principal
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: isValidating ? null : _signIn,
                    child: isValidating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Sign In',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 18),

                // Botones sociales (placeholder)
                _socialButton(
                  icon: FontAwesomeIcons.google,
                  label: 'Sign in with Google',
                  iconColor: Colors.redAccent,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Google Sign-In no implementado')),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _socialButton(
                  icon: FontAwesomeIcons.facebook,
                  label: 'Sign in with Facebook',
                  iconColor: const Color(0xFF1877F2),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Facebook Sign-In no implementado')),
                    );
                  },
                ),

                SizedBox(height: size.height * 0.12),
              ],
            ),
          ),

          // Footer
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 28,
              width: double.infinity,
              color: _brandYellow,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                'v 1.0.0',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          // Overlay de validación
          if (isValidating)
            IgnorePointer(
              ignoring: true,
              child: Container(color: Colors.transparent),
            ),
        ],
      ),
    );
  }
}
