// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/auth_service.dart';
import 'signup_page.dart';
import 'home_page.dart';
import 'motepasse-oblie_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  static const Color _primaryGreen = Color(0xFF2E7D32);
  static const Color _lightBackground = Color(0xFFF0F4F0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Future<void> _checkAutoLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final rememberMe = prefs.getBool('remember_me') ?? false;

  //   if (rememberMe) {
  //     final isLoggedIn = await _authService.isLoggedIn();
  //     if (isLoggedIn && mounted) {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (_) => const HomePage()),
  //       );
  //     }
  //   }
  // }

  Future<void> _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (result['success']) {
        if (_rememberMe) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', _usernameController.text);
          await prefs.setBool('remember_me', true);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Connexion réussie !'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const HomePage(),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['error'] ?? 'Échec de la connexion'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connexion avec $provider en développement'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleForgotPassword() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: _GecimmoLogo()),
              const SizedBox(height: 32),

              _SocialButton(
                icon: FontAwesomeIcons.facebook,
                iconColor: const Color(0xFF1877F2),
                label: 'Se Connecter Avec Facebook',
                onPressed: () => _handleSocialLogin('facebook'),
              ),
              const SizedBox(height: 12),
              _SocialButton(
                icon: FontAwesomeIcons.twitter,
                iconColor: const Color(0xFF1DA1F2),
                label: 'Se Connecter Avec Twitter',
                onPressed: () => _handleSocialLogin('twitter'),
              ),
              const SizedBox(height: 12),
              _SocialButton(
                icon: FontAwesomeIcons.google,
                iconColor: const Color(0xFFEA4335),
                label: 'Se Connecter Avec Google',
                onPressed: () => _handleSocialLogin('google'),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: Row(
                  children: [
                    Expanded(child: Divider(color: Color(0xFFCCCCCC))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'ou',
                        style: TextStyle(
                            color: Color(0xFF888888), fontSize: 14),
                      ),
                    ),
                    Expanded(child: Divider(color: Color(0xFFCCCCCC))),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Connexion',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupPage()),
                    ),
                    child: const Text(
                      'Créer un compte',
                      style: TextStyle(
                        color: _primaryGreen,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                "Nom d'utilisateur",
                style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
              ),
              const SizedBox(height: 8),
              _InputField(
                controller: _usernameController,
                hintText: "Entrez votre nom d'utilisateur",
              ),
              const SizedBox(height: 20),

              const Text(
                'Mot de passe',
                style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
              ),
              const SizedBox(height: 8),
              _InputField(
                controller: _passwordController,
                hintText: 'Entrez votre mot de passe',
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF888888),
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (v) =>
                              setState(() => _rememberMe = v ?? false),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: const BorderSide(color: Color(0xFFAAAAAA)),
                          activeColor: _primaryGreen,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Se souvenir\nde moi',
                        style:
                            TextStyle(fontSize: 13, color: Color(0xFF444444)),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _handleForgotPassword,
                    child: const Text(
                      'Mot de passe\noublié ?',
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontSize: 13, color: Color(0xFF444444)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Se Connecter',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFFDDDDDD)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;

  const _InputField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      obscuringCharacter: '•',
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2E7D32)),
        ),
      ),
    );
  }
}

class _GecimmoLogo extends StatelessWidget {
  const _GecimmoLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
    children: [
  Container(
    width: 200,
    height: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      image: const DecorationImage(
        image: AssetImage('assets/image/logo.png'),
       
      ),
    ),
  ),
  const SizedBox(height: 15),
],
    );
  }
}