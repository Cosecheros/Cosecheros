import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              LinearProgressIndicator(
                value: _loading ? null : 0,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              Image.asset(
                "assets/icon-fore.png",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Text(
                "Nuestra tierra es una granja de eventos metereológicos extremos.\n\n¡Alguien tiene que cosecharlos!",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              Expanded(child: Container()),
              ElevatedButton(
                child: Text("Iniciar con google".toUpperCase()),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.secondary,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shadowColor:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.16),
                ),
                onPressed: signInWithGoogle,
              ),
              TextButton(
                child: Text(
                  "Saltar paso".toUpperCase(),
                  style: Theme.of(context).textTheme.button.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.onBackground,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: signInAnon,
              ),
              SizedBox(height: 16),
              Text(
                "* Si eres sentinela, debes iniciar si o si con tu cuenta de Google.",
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void signInAnon() async {
    setState(() {
      _loading = true;
    });

    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    print(">>> UserCredential:");
    print(userCredential);
    print("<<<");

    setState(() {
      _loading = false;
    });
  }

  void signInWithGoogle() async {
    setState(() {
      _loading = true;
    });

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print(">>> UserCredential:");
      print(userCredential);
      print("<<<");
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
