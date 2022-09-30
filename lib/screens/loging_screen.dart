import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth.dart';

class LogingScreen extends StatefulWidget {
  @override
  _LogingScreenState createState() => _LogingScreenState();
}

class _LogingScreenState extends State<LogingScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    _emailController.text = 'fireangle5621@gmail.com';
    _passwordController.text = '123456789';
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              FlatButton(
                minWidth: double.infinity,
                color: Colors.blue,
                child: Text('Login', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print(_emailController.text);
                    print(_passwordController.text);
                    Provider.of<Auth>(context, listen: false).login({
                      'email': _emailController.text,
                      'password': _passwordController.text
                    });
                    Navigator.pop(context);
                  } else {
                    print('not good');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
