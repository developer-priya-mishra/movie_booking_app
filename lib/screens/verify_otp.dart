import 'package:flutter/material.dart';
import 'package:movie_booking_app/services/auth_services.dart';

import '../components/loading_dialog.dart';
import 'home.dart';

class VerifyOtp extends StatefulWidget {
  final String verificationId;
  const VerifyOtp(this.verificationId, {super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // label
              const Text(
                "Verify OTP",
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              const SizedBox(height: 15.0),
              // otp field
              TextFormField(
                controller: otpController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter the otp";
                  } else if (value.trim().length < 6) {
                    return "Enter valid otp";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Enter otp",
                  border: OutlineInputBorder(),
                  counterText: "",
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
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
                        await AuthServices.verifyOtp(
                          widget.verificationId,
                          otpController.text.trim(),
                        );
                        if (context.mounted) {
                          Navigator.pop(context); // For dialog
                          Navigator.pop(context); // For verify otp screen
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
                  child: const Text("Verify"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
