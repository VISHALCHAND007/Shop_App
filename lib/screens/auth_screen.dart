import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/provider/auth_provider_firebase.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatelessWidget {
  static const routeName = "/auth";

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(253, 53, 27, 0.5019607843137255),
                  Color.fromRGBO(66, 92, 189, 0.9019607843137255),
                ],
                begin: AlignmentGeometry.topLeft,
                end: AlignmentGeometry.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                children: [
                  //top banner
                  Transform.rotate(
                    angle: -8 * pi / 180,
                    child: Transform.translate(
                      offset: const Offset(0.0, 0.0),
                      child: Container(
                        width: deviceSize.width * 1.2,
                        margin: const EdgeInsets.only(bottom: 60),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          // horizontal: 94,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white70,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            "Shopify",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme
                                  .of(
                                context,
                              )
                                  .textTheme
                                  .titleLarge
                                  ?.color,
                              fontSize: 30,
                              fontFamily: "Anton",
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          leading: Icon(Icons.shopping_cart_rounded, size: 40),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {"email": "", "password": ""};
  var isLoading = false;
  final _passwordController = TextEditingController();
  bool _passVisibility = true;
  bool _confirmPassVisibility = true;

  //animations
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _slideAnimation = Tween(begin: Offset(0, -1.5), end: Offset(0, 0)).animate(
        CurvedAnimation(parent: _controller, curve: Curves.linear));
    // heightAnimation.addListener(() => setState(() {})); // not required if we use Animation Builder
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showErrorDialog(String? message) {
    showDialog(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            title: Text("Error occurred"),
            content: Text(
              message != null && message.isNotEmpty
                  ? message
                  : "Something went wrong.",
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text("Okay"),
              ),
            ],
          ),
    );
  }

  void _submit(AuthProviderFirebase authProvider) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        // login process
        await authProvider.signIn(
          _authData["email"]!,
          _passwordController.text,
        );
      } else {
        //sign up process
        await authProvider.signUp(_authData["email"]!, _authData["password"]!);
      }
    } on FirebaseAuthException catch (error) {
      _showErrorDialog(error.message);
    } catch (error) {
      _showErrorDialog("Something went wrong.");
    }

    setState(() {
      isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery
        .of(context)
        .size;
    final authProvider = Provider.of<AuthProviderFirebase>(
      context,
      listen: false,
    );

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.signup ? 320 : 260,
        // height: heightAnimation.value.height,
        width: deviceSize.width * .75,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    suffixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains("@")) {
                      return "Invalid email";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) _authData["email"] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _passVisibility = !_passVisibility;
                        });
                      },
                      icon: _passVisibility
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                  ),
                  obscureText: _passVisibility,

                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 5) {
                      return "Enter a valid password";
                    }
                    return null;
                  },
                ),
                // if (_authMode == AuthMode.signup)
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.signup ? 60 : 0,
                    maxHeight: _authMode == AuthMode.signup ? 120 : 0,
                  ),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.signup,
                        obscureText: _confirmPassVisibility,
                        decoration: InputDecoration(
                          labelText: "Confirm password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _confirmPassVisibility =
                                !_confirmPassVisibility;
                              });
                            },
                            icon: _confirmPassVisibility
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                          ),
                        ),
                        validator: _authMode == AuthMode.signup
                            ? (value) {
                          if (value == null ||
                              value != _passwordController.text) {
                            return "Passwords didn't match";
                          }
                          return null;
                        }
                            : null,
                        onSaved: (value) {
                          if (value != null) _authData["password"] = value;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (isLoading)
                  CircularProgressIndicator(
                    color: Colors.grey,
                    padding: const EdgeInsets.all(2),
                  ),
                ElevatedButton(
                  onPressed: () => _submit(authProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme
                        .of(context)
                        .primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                  ),
                  child: Text(
                    _authMode == AuthMode.login ? "LOGIN" : "SIGN UP",
                  ),
                ),
                TextButton(
                  onPressed: _switchAuthMode,
                  style: TextButton.styleFrom(
                    foregroundColor: Theme
                        .of(
                      context,
                    )
                        .textTheme
                        .titleMedium
                        ?.color,
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 30,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    _authMode == AuthMode.login ? "SIGN UP" : "LOGIN",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
