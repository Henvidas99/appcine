import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/authentication.service.dart'; 
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_data_base/provider/account_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isButtonEnabled = false; 
  bool _isLoading = false; 

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  void initState() {
    super.initState();

    _usernameController.addListener(_checkButtonState);
    _passwordController.addListener(_checkButtonState);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, 
    ]);
  }

  void _checkButtonState() {
    setState(() {
      _isButtonEnabled = _usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  void _login(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await AuthenticationService().login(username, password);
      // ignore: use_build_context_synchronously
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);
           accountProvider.addAccount(data);


      // ignore: use_build_context_synchronously
      context.go('/');
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      if (error.toString().contains('Invalid username and/or password')) {
        final snackBar2 = SnackBar(
          margin: const EdgeInsets.all(90.0,),
          backgroundColor: Colors.blueGrey,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Text(
              'La cuenta no existe',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      } else {
        final snackBar = SnackBar(
          content: Text(error.toString()),
          duration: const Duration(seconds: 2),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.85,
              child: Image.asset(
                'assets/fondo2.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [   
                Image.asset(
                  'assets/palomitasLentesLogo.png',  
                  width: 250,
                  height: 250,

                ),
                const SizedBox(height: 36.0),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(),
                  ),
                  child: TextFormField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.5),
                      prefixIcon: const Icon(Icons.person, color: Color.fromARGB(255, 211, 205, 205)),
                      labelText: 'Digite su nombre de usuario',
                      labelStyle: const TextStyle(color: Color.fromARGB(255, 211, 205, 205)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 6,horizontal: 16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.5),
                      prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 211, 205, 205)),
                      labelText: 'Digite su contraseña',
                      labelStyle: const TextStyle(color: Color.fromARGB(255, 211, 205, 205)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 6,horizontal: 16.0),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: const Color.fromARGB(255, 211, 205, 205),
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    obscureText: _obscurePassword, 
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE50914),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 42),
                      disabledBackgroundColor: const Color.fromARGB(255, 234, 115, 115),
                    ),
                    onPressed: _isButtonEnabled ? () => _login(context) : null, 
                    child: _isLoading
                        ? const SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Iniciar sesión', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
