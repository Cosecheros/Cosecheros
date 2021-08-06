import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/login/current_user.dart';
import 'package:cosecheros/widgets/choice_button.dart';
import 'package:cosecheros/widgets/label_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
              SizedBox(height: 16),
              Text(
                "Antes de empezar,",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Center(
                child: LabelWidget("¿Qué tipo de cosechero eres?"),
              ),
              SizedBox(height: 32),
              Expanded(
                flex: 3,
                child: ChoiceButton(
                  value: selected == UserType.ciudadano,
                  label: "Ciudadano",
                  icon: SvgPicture.asset(
                    "assets/app/woman.svg",
                    semanticsLabel: "ciudadana o ciudadano",
                    fit: BoxFit.contain,
                    height: double.infinity,
                  ),
                  subtitle: "Colabora por amor a la ciencia",
                  onTap: () {
                    setState(() {
                      selected = UserType.ciudadano;
                    });
                  },
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                flex: 3,
                child: ChoiceButton(
                  value: selected == UserType.productor,
                  label: "Productor",
                  icon: SvgPicture.asset(
                    "assets/app/farmer.svg",
                    semanticsLabel: "productor o productora",
                    fit: BoxFit.contain,
                    height: double.infinity,
                  ),
                  subtitle: "Reporta eventos para el INTA",
                  onTap: () {
                    setState(() {
                      selected = UserType.productor;
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
                              .set({
                            "type": selected.toString().split('.').last
                          });
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
