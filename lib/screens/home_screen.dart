// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:fluffy/screens/loging_screen.dart';
import 'package:fluffy/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _imagePicker = ImagePicker();
  File? _image;
  PickedFile? _pickedFile;

  @override
  void initState() {
    // TODO: implement initState
    _emailController.text = 'omar@faggot.com';
    _passwordController.text = '123456789';
    super.initState();
    readToken();
  }

  void readToken() async {
    String token = await storage.read(key: 'token') as String;
    Provider.of<Auth>(context, listen: false).tryToken(token: token);
    print(token);
  }

  Future _pickImage(ImageSource source) async {
    _pickedFile = await _imagePicker.getImage(
        source: source, imageQuality: 50, maxHeight: 500, maxWidth: 500);
    if (_pickedFile != null) {
      setState(() {
        _image = File(_pickedFile!.path);
      });
    }
  }

  Future getImage() async {
    File _image;
    final picker = ImagePicker();

    var _pickedFile = await picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50, // <- Reduce Image quality
        maxHeight: 500, // <- reduce the image size
        maxWidth: 500);

    _image = File(_pickedFile!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'enter the email: ',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'enter the password: ',
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                  width: 280,
                  child: FlatButton(
                    minWidth: double.infinity,
                    color: Colors.blue,
                    child: const Text('Login',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print(_emailController.text);
                        print(_passwordController.text);
                        Provider.of<Auth>(context, listen: false).signup({
                          'email': _emailController.text,
                          'password': _passwordController.text,
                          'name': "fatima",
                        }, _image!);
                      } else {
                        print('not good');
                      }
                    },
                  )),
              SizedBox(
                child: IconButton(
                  icon: const Icon(Icons.camera),
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 150,
                height: 200,
                child: _image == null
                    ? const Text('No image selected.')
                    : Image.file(_image!),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Consumer<Auth>(
          builder: ((context, auth, child) {
            if (!auth.authenticated) {
              return ListView(
                children: [
                  ListTile(
                    title: const Text('Login'),
                    leading: const Icon(Icons.login),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LogingScreen()));
                    },
                  ),
                ],
              );
            } else {
              return ListView(children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(auth.user.name,
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 10),
                      Text(auth.user.email,
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text('Logout'),
                  leading: const Icon(Icons.logout),
                  onTap: () {
                    Provider.of<Auth>(context, listen: false).logout();
                  },
                )
              ]);
            }
          }),
        ),
      ),
    );
  }
}
