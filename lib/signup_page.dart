import 'package:flutter/material.dart';
import 'api_service.dart';
import 'home_page.dart';
import 'custom_snackbar.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  final ApiService apiService = ApiService();
  late AnimationController _controller;
  late Animation<double> _logoSizeAnimation;
  late Animation<double> _backgroundOpacityAnimation;
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _logoSizeAnimation = Tween<double>(begin: 200, end: 260).animate(_controller);
    _backgroundOpacityAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _backgroundOpacityAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(_backgroundOpacityAnimation.value), // Animated opacity
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: _logoSizeAnimation,
                      builder: (context, child) {
                        return SizedBox(
                          height: _logoSizeAnimation.value,
                          child: Image.asset(
                            'assets/logo10e.png', // Path to your logo
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Begin Your Journey',
                      style: TextStyle(
                        fontFamily: 'CustomFont2',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(153, 0, 76, 1),
                      ),
                    ),
                    SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _username = value!;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureTextPassword ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureTextPassword = !_obscureTextPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            obscureText: _obscureTextPassword,
                            onSaved: (value) {
                              _password = value!;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureTextConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            obscureText: _obscureTextConfirmPassword,
                          ),
                          SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                try {
                                  await apiService.registerUser(_username, _password);
                                  Navigator.of(context).pushReplacementNamed(
                                    '/complete_profile',
                                    arguments: _username,
                                  );
                                  CustomSnackbar.showSuccess(context, 'Register Successful');
                                } catch (e) {
                                  CustomSnackbar.showError(context, 'Username Already Exists');
                                }
                              }
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'CustomFont2',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(153, 0, 76, 1),
                              padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width * 0.2,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Divider(color: Colors.pink, thickness: 1, indent: 50, endIndent: 50),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login_page');
                            },
                            child: Text(
                              'Already have an account? Log In',
                              style: TextStyle(
                                color: Color.fromRGBO(153, 0, 76, 1),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
