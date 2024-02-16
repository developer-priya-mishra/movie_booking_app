import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/loading_dialog.dart';
import '../services/firestore_services.dart';

class Booking extends StatefulWidget {
  final String title;
  const Booking({super.key, required this.title});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController(
    text: FirebaseAuth.instance.currentUser!.email,
  );
  final TextEditingController phoneNumberController = TextEditingController();

  DateTime bookingDateTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    10,
  );
  int bookingTicket = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Movie"),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(15.0),
          children: [
            // Movie Title
            Row(
              children: [
                const Icon(Icons.movie),
                const SizedBox(width: 5.0),
                const Text("Movie:"),
                const SizedBox(width: 15.0),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            // Customer ID
            Row(
              children: [
                const Icon(Icons.badge),
                const SizedBox(width: 5.0),
                const Text("Customer ID:"),
                const SizedBox(width: 15.0),
                Expanded(
                  child: Text(
                    FirebaseAuth.instance.currentUser!.uid,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            // Name
            Row(
              children: [
                const Icon(Icons.person),
                const SizedBox(width: 5.0),
                const Text("Name:"),
                const SizedBox(width: 15.0),
                Expanded(
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter full name';
                      }
                      return null;
                    },
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Peter",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            // Email
            Row(
              children: [
                const Icon(Icons.email),
                const SizedBox(width: 5.0),
                const Text("Email:"),
                const SizedBox(width: 15.0),
                Expanded(
                  child: TextFormField(
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
                      hintText: "peter@gmail.com",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            // Contact no
            Row(
              children: [
                const Icon(Icons.phone),
                const SizedBox(width: 5.0),
                const Text("Contact:"),
                const SizedBox(width: 15.0),
                Expanded(
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter phone number';
                      }
                      return null;
                    },
                    maxLength: 10,
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "+91 9876543210",
                      counterText: "",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            // choose date
            Row(
              children: [
                const Icon(Icons.calendar_month),
                const SizedBox(width: 5.0),
                const Text("Choose Date:"),
                const SizedBox(width: 15.0),
                SizedBox(
                  height: 50.0,
                  child: TextButton(
                    onPressed: () async {
                      DateTime? choosedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 7)),
                        //It show in the dialog box
                        currentDate: bookingDateTime,
                      );

                      if (choosedDate != null) {
                        setState(() {
                          bookingDateTime = DateTime(
                            choosedDate.year,
                            choosedDate.month,
                            choosedDate.day,
                            bookingDateTime.hour,
                            bookingDateTime.minute,
                          );
                        });
                      }
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 18.0),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                          side: BorderSide(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    child: Text(
                      "${bookingDateTime.day}-${bookingDateTime.month}-${bookingDateTime.year}",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            // choose time
            Row(
              children: [
                const Icon(Icons.watch_later_outlined),
                const SizedBox(width: 5.0),
                const Text("Choose Time:"),
                const SizedBox(width: 15.0),
                SizedBox(
                  height: 50.0,
                  child: TextButton(
                    onPressed: () async {
                      TimeOfDay? choosedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: bookingDateTime.hour,
                          minute: bookingDateTime.minute,
                        ),
                      );

                      if (choosedTime != null &&
                          choosedTime.hour >= 10 &&
                          choosedTime.hour <= 21) {
                        setState(() {
                          bookingDateTime = DateTime(
                            bookingDateTime.year,
                            bookingDateTime.month,
                            bookingDateTime.day,
                            choosedTime.hour,
                            choosedTime.minute,
                          );
                        });
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Choose valid booking time",
                              ),
                            ),
                          );
                        }
                      }
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 18.0),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                          side: BorderSide(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    child: Text(
                      TimeOfDay(
                        hour: bookingDateTime.hour,
                        minute: bookingDateTime.minute,
                      ).format(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            // no of tickets
            Row(
              children: [
                const Icon(Icons.local_activity),
                const SizedBox(width: 5.0),
                const Text("No of tickets:"),
                const SizedBox(width: 15.0),
                Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    border: Border.all(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            bookingTicket == 1 ? 1 : bookingTicket--;
                          });
                        },
                        icon: Icon(
                          Icons.remove,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        '$bookingTicket',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            bookingTicket == 10 ? 10 : bookingTicket++;
                          });
                        },
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 15.0),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        margin: const EdgeInsets.all(15.0),
        width: MediaQuery.of(context).size.width,
        child: TextButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              LoadingDialog(context);

              final List bookingInfos = [
                {
                  "movie": widget.title,
                  "customer id": FirebaseAuth.instance.currentUser!.uid,
                  "name": nameController.text.trim(),
                  "email": emailController.text.trim(),
                  "contact": phoneNumberController.text.trim(),
                  "datetime": bookingDateTime,
                  "ticket": bookingTicket,
                },
              ];

              bool isAlreadyBooked = false;

              Map<String, dynamic>? fields =
                  await FirestoreServices.getCurrentUserData();

              if (fields != null && fields["booking"] != null) {
                List bookedInfoList = fields["booking"];

                for (var bookedInfo in bookedInfoList) {
                  if (bookingInfos[0]["movie"] != bookedInfo["movie"] &&
                      bookingInfos[0]["datetime"] ==
                          bookedInfo["datetime"].toDate()) {
                    isAlreadyBooked = true;
                  }
                }

                bookingInfos.addAll(bookedInfoList);
              }

              bool? confirmBooking = true;

              if (isAlreadyBooked && context.mounted) {
                confirmBooking = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Booking Failed"),
                      content: const Text(
                        "Another movie of same time is already booked.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text(
                            "Cancel",
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          child: const Text(
                            "Okay",
                          ),
                        ),
                      ],
                    );
                  },
                );
              }

              if (confirmBooking == true) {
                await FirestoreServices.setCurrentUserData(
                  {"booking": bookingInfos},
                );

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Movie booked successfully"),
                    ),
                  );
                }
              } else {
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: const Text("Confirm Booking"),
        ),
      ),
    );
  }
}
