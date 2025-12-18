import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/auth_provider.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatelessWidget {
  static const routeName = "/auth";

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

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
                        child: Text(
                          "Shopify",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.titleLarge?.color,
                            fontSize: 30,
                            fontFamily: "Anton",
                            fontWeight: FontWeight.normal,
                          ),
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

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {"email": "", "password": ""};
  var isLoading = false;
  final _passwordController = TextEditingController();

  void _submit(AuthProvider authProvider) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      isLoading = true;
    });
    if (_authMode == AuthMode.login) {
      // login process
    } else {
      //sign up process
      await authProvider.signUp(_authData["email"]!, _authData["password"]!);
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
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8,
      child: Container(
        height: _authMode == AuthMode.signup ? 320 : 260,
        width: deviceSize.width * .75,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Email"),
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
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 5) {
                      return "Enter a valid password";
                    }
                    return null;
                  },
                ),
                if (_authMode == AuthMode.signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.signup,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Confirm password"),
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
                      if(value != null) _authData["password"] = value;
                    },
                  ),
                SizedBox(height: 20),
                if (isLoading) CircularProgressIndicator(),
                ElevatedButton(
                  onPressed: () => _submit(authProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
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
                    foregroundColor: Theme.of(context).textTheme.titleMedium?.color,
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap
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
