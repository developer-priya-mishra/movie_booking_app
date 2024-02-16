import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../components/loading_dialog.dart';
import '../services/auth_services.dart';
import 'home.dart';
import 'signin.dart';

class PhoneSignIn extends StatefulWidget {
  const PhoneSignIn({super.key});

  @override
  State<PhoneSignIn> createState() => _PhoneSignInState();
}

class _PhoneSignInState extends State<PhoneSignIn> {
  final TextEditingController phoneNumberController = TextEditingController();
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
                "Sign In",
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              const SizedBox(height: 15.0),
              // phone field
              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter phone number";
                  } else if (value.trim().length < 10) {
                    return "Enter valid phone number";
                  }
                  return null;
                },
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  prefixText: "+91   ",
                  hintText: "Enter phone number",
                  border: OutlineInputBorder(),
                  counterText: "",
                ),
                keyboardType: TextInputType.number,
                maxLength: 10,
              ),
              const SizedBox(height: 10.0),
              // verify btn
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      LoadingDialog(context);

                      try {
                        await AuthServices.phoneSignIn(
                          context: context,
                          phoneNumber: phoneNumberController.text.toString(),
                        );
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
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: const Text("Next"),
                ),
              ),
              const SizedBox(height: 20.0),
              const Divider(),
              const SizedBox(height: 20.0),
              // signin using email btn
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignIn(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  icon: const Icon(
                    Icons.email,
                    size: 18.0,
                  ),
                  label: const Text("Sign In with Email"),
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
