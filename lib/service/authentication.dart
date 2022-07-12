import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/cupertino_style.dart';

enum ApplicationLoginState {
  loggedOut,
  emailAddress,
  register,
  password,
  loggedIn,
}

class Authentication extends StatelessWidget {
  const Authentication({
    required this.loginState,
    required this.email,
    required this.startLoginFlow,
    required this.verifyEmail,
    required this.signInWithEmailAndPassword,
    required this.cancelRegistration,
    required this.registerAccount,
    required this.signOut,
    Key? key,
  }) : super(key: key);

  final ApplicationLoginState loginState;
  final String? email;
  final void Function() startLoginFlow;
  final void Function(
    String email,
    void Function(Exception e) error,
  ) verifyEmail;
  final void Function(
    String email,
    String password,
    void Function(Exception e) error,
  ) signInWithEmailAndPassword;
  final void Function() cancelRegistration;
  final void Function(
    String email,
    String displayName,
    String password,
    void Function(Exception e) error,
  ) registerAccount;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    switch (loginState) {
      case ApplicationLoginState.loggedOut:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CupertinoButton(
                color: Styles.accent1,
                onPressed: () {
                  startLoginFlow();
                },
                child: const Text('Mit Email Anmelden',
                    style: TextStyle(color: CupertinoColors.white)),
              ),
            ),
          ],
        );
      case ApplicationLoginState.emailAddress:
        return EmailForm(
            callback: (email) => verifyEmail(
                email, (e) => _showErrorDialog(context, 'Ungültige', e)));
      case ApplicationLoginState.password:
        return PasswordForm(
          email: email!,
          login: (email, password) {
            signInWithEmailAndPassword(
                email,
                password,
                (e) =>
                    _showErrorDialog(context, 'Anmeldung fehlgeschlagen', e));
          },
        );
      case ApplicationLoginState.register:
        return RegisterForm(
          email: email!,
          cancel: () {
            cancelRegistration();
          },
          registerAccount: (
            email,
            displayName,
            password,
          ) {
            registerAccount(
                email,
                displayName,
                password,
                (e) => _showErrorDialog(
                    context, 'Account konnte nicht erstellt werden', e));
          },
        );
      case ApplicationLoginState.loggedIn:
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: CupertinoButton(
                color: Styles.accent1,
                onPressed: () {
                  signOut();
                },
                child: const Text('Abmelden',
                    style: TextStyle(color: CupertinoColors.white)),
              ),
            ),
          ],
        );
      default:
        return Row(
          children: const [
            Text("Interner Fehler."),
          ],
        );
    }
  }

  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoButton(
              color: Styles.accent1,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: CupertinoColors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

class EmailForm extends StatefulWidget {
  const EmailForm({Key? key, required this.callback}) : super(key: key);

  final void Function(String email) callback;

  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_EmailFormState');

  //final _controller = TextEditingController();
  String? _email;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CupertinoFormRow(
                  prefix: const Icon(CupertinoIcons.mail,
                      color: Styles.standardColor),
                  child: CupertinoTextFormFieldRow(
                    padding: const EdgeInsets.all(8),
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: BoxDecoration(
                      color: Styles.searchBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    placeholder: "Email",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Gib eine gültige Email Adresse ein';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _email = value;
                    },
                    // onSaved: (value) {
                    //   _email = value!;
                    //   print("FUCKIN FETT");
                    //   print(_email);
                    // },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 30),
                      child: CupertinoButton(
                        color: Styles.accent1,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            widget.callback(_email!);
                          }
                        },
                        child: const Text('Weiter',
                            style: TextStyle(color: CupertinoColors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key? key,
    required this.registerAccount,
    required this.cancel,
    required this.email,
  }) : super(key: key);

  final String email;
  final void Function(String email, String displayName, String password)
      registerAccount;
  final void Function() cancel;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_RegisterFormState');
  String? _email;
  String? _name;
  String? _password;

  @override
  void initState() {
    super.initState();
    _email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Account erstellen', style: Styles.standardText),
        Form(
          key: _formKey,
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 24),
              CupertinoFormRow(
                prefix: const Icon(CupertinoIcons.mail,
                    color: Styles.standardColor),
                child: CupertinoTextFormFieldRow(
                  textInputAction: TextInputAction.next,
                  initialValue: _email,
                  placeholder: "Email",
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: BoxDecoration(
                    color: Styles.searchBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains("@")) {
                      return 'Gib eine gültige Email Adresse ein';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _email = value;
                  },
                ),
              ),
              CupertinoFormRow(
                prefix: const Icon(CupertinoIcons.person_crop_circle_fill,
                    color: Styles.standardColor),
                child: CupertinoTextFormFieldRow(
                  textInputAction: TextInputAction.next,
                  placeholder: "Vollständiger Name",
                  keyboardType: TextInputType.text,
                  decoration: BoxDecoration(
                    color: Styles.searchBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Gib deinen Vor und Nachnamen ein';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _name = value;
                  },
                ),
              ),
              CupertinoFormRow(
                prefix: const Icon(CupertinoIcons.staroflife,
                    color: Styles.standardColor),
                child: CupertinoTextFormFieldRow(
                  placeholder: "Passwort",
                  keyboardType: TextInputType.text,
                  decoration: BoxDecoration(
                    color: Styles.searchBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Gib ein Passwort ein';
                    } else if (value.length < 6) {
                      return "Min. 6 Stellen";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _password = value;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      color: Styles.accent1,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.registerAccount(
                            _email!,
                            _name!,
                            _password!,
                          );
                        }
                      },
                      child: const Text('Speichern',
                          style: TextStyle(color: CupertinoColors.white)),
                    ),
                    const SizedBox(width: 16),
                    CupertinoButton(
                      onPressed: widget.cancel,
                      child: const Text('Abbrechen',
                          style: TextStyle(color: Styles.accent1)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PasswordForm extends StatefulWidget {
  const PasswordForm({
    Key? key,
    required this.login,
    required this.email,
  }) : super(key: key);

  final String email;
  final void Function(String email, String password) login;

  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_PasswordFormState');

  //final _emailController = TextEditingController();
  //final _passwordController = TextEditingController();

  String? _email;
  String? _password;

  @override
  void initState() {
    super.initState();
    _email = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Anmelden', style: Styles.h2),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CupertinoFormRow(
                  prefix: const Icon(CupertinoIcons.mail,
                      color: Styles.standardColor),
                  child: CupertinoTextFormFieldRow(
                    textInputAction: TextInputAction.next,
                    placeholder: "Email",
                    initialValue: _email,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: BoxDecoration(
                      color: Styles.searchBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Gib eine Email ein';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _email = value;
                    },
                  ),
                ),
                CupertinoFormRow(
                  prefix: const Icon(CupertinoIcons.staroflife,
                      color: Styles.standardColor),
                  child: CupertinoTextFormFieldRow(
                    placeholder: "Passwort",
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: BoxDecoration(
                      color: Styles.searchBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Gib ein Passwort ein';
                      } else if (value.length < 6) {
                        return "Min. 6 Stellen";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _password = value;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 16),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: CupertinoButton(
                        color: Styles.accent1,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.login(
                              _email!,
                              _password!,
                            );
                          }
                        },
                        child: const Text('Anmelden',
                            style: TextStyle(color: CupertinoColors.white)),
                      ),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
