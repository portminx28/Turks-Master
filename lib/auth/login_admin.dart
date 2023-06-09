import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turks/views/admin/admin_home_page.dart';
import 'package:turks/widgets/button_widget.dart';
import 'package:turks/widgets/text_widget.dart';
import 'package:get_storage/get_storage.dart';

class LoginAdmin extends StatefulWidget {
  const LoginAdmin({Key? key}) : super(key: key);

  @override
  State<LoginAdmin> createState() => _LoginAdminState();
}

class _LoginAdminState extends State<LoginAdmin> {
  late String username;

  late String password;

  late String answer;

  final box = GetStorage();

  late String forgotPassword = '';

  late String myPassword = '';

  bool hasLoaded = false;

  getData() async {
    // Use provider
    var collection = FirebaseFirestore.instance
        .collection('Users')
        .where('username', isEqualTo: forgotPassword + '@Admin.com')
        .where('question', isEqualTo: selectedQuestion)
        .where('answer', isEqualTo: answer);

    var querySnapshot = await collection.get();
    if (mounted) {
      setState(() {
        for (var queryDocumentSnapshot in querySnapshot.docs) {
          Map<String, dynamic> data = queryDocumentSnapshot.data();
          myPassword = data['password'];
          hasLoaded = true;
        }
      });
    }
  }

  String selectedQuestion = "What is your grandfather's last name?";

  List<String> questions = [
    "What is your grandfather's last name?",
    "What year did you graduate in elementary?",
    "What is your mother's middle name?",
    "What is your favorite color?",
    "What is your elementary ambition?",
    "What is the name of your BSB?",
    "What is your favorite pet?",
    "What is the last name of your grandmother's mother?",
    "What is the name of your grandfather's father?",
    "What is your favorite food?",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/TURKS PNG.png',
                height: 150,
              ),
              const SizedBox(
                height: 20,
              ),
              TextBold(text: 'Login Admin', fontSize: 32, color: Colors.black),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                child: TextFormField(
                  onChanged: (_input) {
                    username = _input;
                  },
                  decoration: InputDecoration(
                    label: TextRegular(
                        text: 'Username:', fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                child: TextFormField(
                  obscureText: true,
                  onChanged: (_input) {
                    password = _input;
                  },
                  decoration: InputDecoration(
                    label: TextRegular(
                        text: 'Password:', fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ButtonWidget(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: username.trim() + '@Admin.com',
                          password: password.trim());
                      box.write('username', username.trim() + '@Admin.com');
                      box.write('password', password);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const AdminHomePage()));
                    } catch (e) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Text(
                                  e.toString(),
                                  style:
                                      const TextStyle(fontFamily: 'QRegular'),
                                ),
                                actions: <Widget>[
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Close',
                                      style: TextStyle(
                                          fontFamily: 'QRegular',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ));
                    }
                  },
                  text: 'Login'),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text(
                              'Recovering Password',
                              style: TextStyle(fontFamily: 'QBold'),
                            ),
                            content:
                                StatefulBuilder(builder: (context, setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    onChanged: (_input) {
                                      forgotPassword = _input;
                                      getData();
                                    },
                                    decoration: InputDecoration(
                                      label: TextRegular(
                                          text: 'Enter your username',
                                          fontSize: 12,
                                          color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  DropdownButton<String>(
                                    underline: const SizedBox(),
                                    value: selectedQuestion,
                                    hint: const Text('Select a question'),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedQuestion = newValue.toString();
                                      });
                                    },
                                    items: questions
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: SizedBox(
                                          width: 200,
                                          child: Text(value),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    onChanged: (_input) {
                                      answer = _input;
                                      getData();
                                    },
                                    decoration: InputDecoration(
                                      label: TextRegular(
                                          text: "Enter answer",
                                          fontSize: 12,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              );
                            }),
                            actions: <Widget>[
                              MaterialButton(
                                onPressed: () {
                                  try {
                                    hasLoaded
                                        ? showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Text(
                                                    'Your Password',
                                                    style: TextStyle(
                                                        fontFamily: 'QBold'),
                                                  ),
                                                  content: Text(
                                                    myPassword,
                                                    style: const TextStyle(
                                                        fontFamily: 'QRegular'),
                                                  ),
                                                  actions: <Widget>[
                                                    MaterialButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const LoginAdmin()));
                                                      },
                                                      child: const Text(
                                                        'Continue',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'QRegular',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                        : const Center(
                                            child: CircularProgressIndicator(
                                                color: Colors.black));
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                },
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(
                                      fontFamily: 'QRegular',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ));
                },
                child: TextBold(
                    text: 'Recover Password?',
                    fontSize: 12,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
