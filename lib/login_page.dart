import 'package:flutter/material.dart';
import 'home_page.dart';
import 'custom_snackbar.dart';
import 'api_service.dart'; // Assuming this service handles API calls

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  final ApiService apiService = ApiService();
  late AnimationController _controller;
  late Animation<double> _logoSizeAnimation;
  late Animation<double> _backgroundOpacityAnimation;
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _logoSizeAnimation = Tween<double>(begin: 200, end: 260).animate(_controller);
    _backgroundOpacityAnimation = Tween<double>(begin: 0.9, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Login function with error handling and loading state
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      try {
        // Call the backend login API
        bool loginSuccessful = await apiService.loginUser(_username, _password);

        if (loginSuccessful) {
          // Navigate to HomePage if login successful
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(username: _username),
            ),
          );
          CustomSnackbar.showSuccess(context, 'Login Succesfull');
        } else {

          CustomSnackbar.showError(context, 'Login Failed! Please check your credentials');
        }
      } catch (e) {
        CustomSnackbar.showError(context, 'An error occurred. Please try again.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _logoSizeAnimation,
                      builder: (context, child) {
                        return SizedBox(
                          height: _logoSizeAnimation.value,
                          child: Image.asset(
                            'assets/logo10e.png', // App logo
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Welcome to',
                      style: TextStyle(
                        fontFamily: 'CustomFont2',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(153, 0, 76, 1),
                      ),
                    ),

                    Text(
                      'Biwah BandhaN',
                      style: TextStyle(
                        fontFamily: 'CustomFont3',
                        fontSize: 50,
                        fontWeight: FontWeight.normal,
                        color: Color.fromRGBO(153, 0, 76, 1),
                      ),
                    ),
                    SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Username Field
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
                          // Password Field
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
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
                            onSaved: (value) {
                              _password = value!;
                            },
                            obscureText: _obscureText,
                          ),
                          SizedBox(height: 20),
                          // Login Button
                          ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                              'Login',
                              style: TextStyle(fontFamily:'CustomFont2',fontSize: 20, color: Colors.white),
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
                          SizedBox(height: 10),
                          Divider(color: Colors.pink, thickness: 1, indent: 50, endIndent: 50),
                          // Sign Up Button
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/sign_up');
                            },
                            child: Text(
                              'Don\'t have an account? Sign Up',
                              style: TextStyle(color: Color.fromRGBO(153, 0, 76, 1), fontSize: 16),
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
