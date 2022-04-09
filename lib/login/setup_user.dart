import 'package:cosecheros/data/current_user.dart';
import 'package:cosecheros/widgets/choice_button.dart';
import 'package:cosecheros/widgets/label_widget.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Antes de empezar,",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LabelWidget("¿Qué tipo de cosechero eres?"),
                    Tooltip(
                      message:
                          "Este dato nos ayuda a ofrecerte una mejor experiencia.",
                      triggerMode: TooltipTriggerMode.tap,
                      child: Icon(
                        Icons.help_outline_rounded,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 6,
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
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 6,
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
              ConstrainedBox(
                constraints: BoxConstraints.expand(height: 56),
                child: ElevatedButton(
                  onPressed: selected == null
                      ? null
                      : () {
                          CurrentUser.instance.saveType(selected);
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
