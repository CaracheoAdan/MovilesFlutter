import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChallengefigmaScreen extends StatefulWidget {
  const ChallengefigmaScreen({super.key});

  @override
  State<ChallengefigmaScreen> createState() => _ChallengefigmaScreenState();
}

class _ChallengefigmaScreenState extends State<ChallengefigmaScreen> {
  final TextEditingController conUser = TextEditingController();
  final TextEditingController conPwd = TextEditingController();

  bool isValidating = false;

  Color get _brandYellow => const Color(0xFFFFB000); 
  Color get _cardGray => const Color(0xFFE8E8E8); 

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    InputDecoration _fieldDeco(String hint) => InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: Colors.black54),
          filled: true,
          fillColor: _cardGray,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: _cardGray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: Colors.black87, width: 1),
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                FaIcon(icon, size: 24, color: iconColor ?? Colors.black87),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(label,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      )),
                ),
                const Icon(Icons.arrow_right_alt, size: 22),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 140,
            color: _brandYellow,
            padding: const EdgeInsets.only(top: 40, left: 12, right: 12),
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

          // Contenido
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 140 - 16),
                Text(
                  'Sign In',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w800,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(height: 22),
                TextField(
                  controller: conUser,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _fieldDeco('Username'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: conPwd,
                  obscureText: true,
                  decoration: _fieldDeco('Password'),
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

                // Botón negro Sign Up
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
                    onPressed: () {
                      setState(() => isValidating = true);
                      Future.delayed(const Duration(milliseconds: 1200), () {
                        if (!mounted) return;
                        setState(() => isValidating = false);
                        Navigator.pushNamed(context, '/Mealfigma');
                      });
                    },
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Botones sociales
                _socialButton(
                  icon: FontAwesomeIcons.google,
                  label: 'Sign in with Google',
                  iconColor: Colors.redAccent,
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _socialButton(
                  icon: FontAwesomeIcons.facebook,
                  label: 'Sign in with Facebook',
                  iconColor: const Color(0xFF1877F2),
                  onTap: () {},
                ),

                SizedBox(height: size.height * 0.12),
              ],
            ),
          ),

          // Footer amarillo con versión
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
                style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ),
          ),

          // Mini loader al presionar Sign Up (opcional)
          if (isValidating)
            Container(
              color: Colors.black.withOpacity(0.08),
              child: const Center(
                child: SizedBox(
                  height: 48,
                  width: 48,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
