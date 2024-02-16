import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../components/loading_dialog.dart';
import '../services/auth_services.dart';
import 'home.dart';
import 'phone_signin.dart';
import 'reset_password.dart';
import 'signup.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPasswordObscured = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // label
              const Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              const SizedBox(height: 15.0),
              // email field
              TextFormField(
                validator: (value) {
                  RegExp emailRegExp = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  );

                  if (value == null || value.trim().isEmpty) {
                    return 'Enter email address';
                  } else if (!value.contains(emailRegExp)) {
                    return 'Enter valid email address';
                  }
                  return null;
                },
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email",
                ),
              ),
              const SizedBox(height: 10.0),
              // password field
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter password';
                  } else if (value.trim().length < 8) {
                    return "Password should be minimum 8 characters";
                  }
                  return null;
                },
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: isPasswordObscured,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordObscured = !isPasswordObscured;
                      });
                    },
                    icon: Icon(
                      isPasswordObscured
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              // submit btn
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      LoadingDialog(context);

                      try {
                        await AuthServices.signIn(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Home(),
                            ),
                          );
                        }
                      } catch (error) {
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error.toString()),
                            ),
                          );
                        }
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: const Text("Sign In"),
                ),
              ),
              const SizedBox(height: 20.0),
              // forgot password btn
              InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Forget your password?"),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResetPassword(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              const Divider(),
              const SizedBox(height: 20.0),
              // email signup btn
              InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Don't have an account? Sign Up"),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUp(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              // phone signin btn
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PhoneSignIn(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  icon: const Icon(
                    Icons.phone,
                    size: 18.0,
                  ),
                  label: const Text("Sign In with Phone Number"),
                ),
              ),
              const SizedBox(height: 20.0),
              // google signin btn
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: TextButton.icon(
                  onPressed: () async {
                    LoadingDialog(context);

                    try {
                      await AuthServices.signInWithGoogle();
                      if (context.mounted) {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home(),
                          ),
                        );
                      }
                    } catch (error) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              error.toString(),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  icon: Icon(
                    MdiIcons.google,
                    size: 18.0,
                  ),
                  label: const Text(
                    "Sign In with Google",
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
