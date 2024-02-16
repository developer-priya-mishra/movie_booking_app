import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../components/loading_dialog.dart';
import '../services/auth_services.dart';
import 'home.dart';
import 'phone_signin.dart';
import 'signin.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;
  bool isLoading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                "Sign Up",
                style: TextStyle(fontSize: 25.0),
              ),
              const SizedBox(height: 15.0),
              // email field
              TextFormField(
                validator: (value) {
                  RegExp emailRegExp = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  );

                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  } else if (!value.contains(emailRegExp)) {
                    return 'Enter valid email address';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
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
                    return 'This field is required';
                  } else if (value.trim().length < 8) {
                    return 'Password should be minimum 8 characters';
                  }
                  return null;
                },
                keyboardType: TextInputType.visiblePassword,
                obscureText: isPasswordObscured,
                controller: passwordController,
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
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              // confirm password field
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  } else if (passwordController.text.trim() !=
                      confirmPasswordController.text.trim()) {
                    return 'Confirm Password should be same as Password';
                  }
                  return null;
                },
                keyboardType: TextInputType.visiblePassword,
                obscureText: isConfirmPasswordObscured,
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Confirm Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordObscured = !isConfirmPasswordObscured;
                      });
                    },
                    icon: Icon(
                      isConfirmPasswordObscured
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
              // signup btn
              const SizedBox(height: 10.0),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      LoadingDialog(context);

                      try {
                        await AuthServices.signUp(
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
                  child: const Text("Sign Up"),
                ),
              ),
              const SizedBox(height: 20.0),
              const Divider(),
              const SizedBox(height: 20.0),
              // email signin btn
              InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Already have account? Sign In"),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignIn(),
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
