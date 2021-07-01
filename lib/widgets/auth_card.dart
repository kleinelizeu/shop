import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/providers/auth.dart';

enum AuthMode {
  Login,
  SingUp,
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Ocorreu um Erro!"),
        content: Text(msg),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Fechar"),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState.save();

    Auth auth = Provider.of(context, listen: false);
    try {
      if (_authMode == AuthMode.Login) {
        await auth.login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        await auth.signUp(
          _authData['email'],
          _authData['password'],
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog("Houve um erro inesperado!");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SingUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8,
      child: Container(
        padding: EdgeInsets.all(16),
        height: _authMode == AuthMode.Login ? 290 : 371,
        width: sizeScreen.width * 0.75,
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "E-mail",
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains("@")) {
                    return "Infome um e-mail válido";
                  }

                  return null;
                },
                onSaved: (value) => _authData['email'] = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Senha",
                ),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return "Infome uma senha válida";
                  }

                  return null;
                },
                onSaved: (value) => _authData['password'] = value,
              ),
              if (_authMode == AuthMode.SingUp)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Corfirmar a senha",
                  ),
                  obscureText: true,
                  validator: _authMode == AuthMode.SingUp
                      ? (value) {
                          if (value != _passwordController.text) {
                            return "Senhas diferentes";
                          }
                          return null;
                        }
                      : null,
                ),
              SizedBox(height: 20),
              if (_isLoading == true)
                CircularProgressIndicator()
              else
                RaisedButton(
                  textColor: Theme.of(context).primaryTextTheme.button.color,
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 30.0,
                  ),
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR-SE',
                  ),
                  onPressed: _submit,
                ),
              FlatButton(
                onPressed: _switchAuthMode,
                child: Text(
                  _authMode == AuthMode.Login ? "REGISTRAR" : "LOGIN",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
