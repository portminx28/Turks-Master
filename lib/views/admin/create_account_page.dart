import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turks/services/cloud_function/add_user.dart';
import 'package:turks/views/admin/admin_home_page.dart';
import 'package:turks/widgets/appbar_widget.dart';
import 'package:turks/widgets/button_widget.dart';
import 'package:turks/widgets/text_widget.dart';
import 'package:get_storage/get_storage.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  late String name;

  late String username;

  late String password;

  late String confirmPassword;

  late String answer;

  final box = GetStorage();
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
      appBar: AppbarWidget(box.read('createAccount')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/profile.png',
                height: 150,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                child: TextFormField(
                  onChanged: (_input) {
                    name = _input;
                  },
                  decoration: InputDecoration(
                    label: TextRegular(
                        text: 'Name:', fontSize: 18, color: Colors.black),
                  ),
                ),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                child: TextFormField(
                  obscureText: true,
                  onChanged: (_input) {
                    confirmPassword = _input;
                  },
                  decoration: InputDecoration(
                    label: TextRegular(
                        text: 'Confirm Password:',
                        fontSize: 18,
                        color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              ButtonWidget(
                  onPressed: () {
                    if (password == confirmPassword) {
                      if (password.length > 6) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                actions: [
                                  MaterialButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => AlertDialog(
                                                content: const Text(
                                                  'Account Created Succesfully!',
                                                  style: TextStyle(
                                                      fontFamily: 'QRegular'),
                                                ),
                                                actions: <Widget>[
                                                  MaterialButton(
                                                    onPressed: () async {
                                                      if (box.read(
                                                              'createAccount') ==
                                                          'Crew') {
                                                        try {
                                                          await FirebaseAuth
                                                              .instance
                                                              .createUserWithEmailAndPassword(
                                                                  email: username
                                                                          .trim() +
                                                                      '@Crew.com',
                                                                  password:
                                                                      password
                                                                          .trim());
                                                        } catch (e) {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                        content:
                                                                            Text(
                                                                          e.toString(),
                                                                          style:
                                                                              const TextStyle(fontFamily: 'QRegular'),
                                                                        ),
                                                                        actions: <
                                                                            Widget>[
                                                                          MaterialButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                const Text(
                                                                              'Close',
                                                                              style: TextStyle(fontFamily: 'QRegular', fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ));
                                                        }
                                                      } else {
                                                        await FirebaseAuth
                                                            .instance
                                                            .createUserWithEmailAndPassword(
                                                                email: username
                                                                        .trim() +
                                                                    '@Admin.com',
                                                                password:
                                                                    password
                                                                        .trim());
                                                      }
                                                      addUser(
                                                          name,
                                                          username,
                                                          box.read(
                                                              'createAccount'),
                                                          password,
                                                          answer,
                                                          selectedQuestion);
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const AdminHomePage()));
                                                    },
                                                    child: const Text(
                                                      'Continue',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'QRegular',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ));
                                    },
                                    child: const Text(
                                      'Continue',
                                      style: TextStyle(
                                          fontFamily: 'QRegular',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                                title: TextRegular(
                                    text: "Enter $name security question",
                                    fontSize: 14,
                                    color: Colors.black),
                                content: StatefulBuilder(
                                    builder: (context, setState) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DropdownButton<String>(
                                        underline: const SizedBox(),
                                        value: selectedQuestion,
                                        hint: const Text('Select a question'),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedQuestion =
                                                newValue.toString();
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
                                      TextFormField(
                                        onChanged: (_input) {
                                          answer = _input;
                                        },
                                      ),
                                    ],
                                  );
                                }),
                              );
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: const Text(
                                    'Password too short',
                                    style: TextStyle(fontFamily: 'QRegular'),
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
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: const Text(
                                  'Password do not match',
                                  style: TextStyle(fontFamily: 'QRegular'),
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
                  text: 'Register'),
            ],
          ),
        ),
      ),
    );
  }
}
