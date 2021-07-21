import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/widgets/choice_button.dart';
import 'package:cosecheros/widgets/label_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum UserType { ciudadano, agricultor }

class BeforeStart extends StatefulWidget {
  @override
  _BeforeStartState createState() => _BeforeStartState();
}

class _BeforeStartState extends State<BeforeStart> {
  UserType selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32),
              Text("Antes de empezar,"),
              SizedBox(height: 32),
              Expanded(
                flex: 1,
                child: LabelWidget("¿Qué tipo de cosechero eres?"),
              ),
              Expanded(
                flex: 2,
                child: ChoiceButton(
                  value: selected == UserType.ciudadano,
                  label: "Ciudadano",
                  onTap: () {
                    setState(() {
                      selected = UserType.ciudadano;
                    });
                  },
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                flex: 2,
                child: ChoiceButton(
                  value: selected == UserType.agricultor,
                  label: "Agricultor",
                  onTap: () {
                    setState(() {
                      selected = UserType.agricultor;
                    });
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Text(
                "* Este dato nos ayuda a ofrecerte una mejor experiencia dentro de la app.",
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.8)),
              ),
              SizedBox(height: 32),
              ConstrainedBox(
                constraints: BoxConstraints.expand(height: 56),
                child: ElevatedButton(
                  onPressed: selected == null
                      ? null
                      : () async {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser.uid)
                              .set({"type": selected.toString().split('.').last});
                        },
                  child: Text(
                    "CONFIRMAR",
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
