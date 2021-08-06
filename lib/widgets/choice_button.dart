import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChoiceButton extends StatelessWidget {
  final bool value;
  final String label;
  final String subtitle;
  final Widget icon;
  final VoidCallback onTap;

  const ChoiceButton({
    Key key,
    @required this.value,
    @required this.subtitle,
    @required this.icon,
    @required this.label,
    @required this.onTap,
  }) : super(key: key);

  BoxDecoration getDecorationBox(context) {
    return value
        ? BoxDecoration(
            color: Theme.of(context).colorScheme.primaryVariant.withAlpha(12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 2,
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
          )
        : BoxDecoration(
            color: Colors.black.withOpacity(.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 2,
              color: Colors.transparent,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getDecorationBox(context),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: icon,
            )),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    // Bug en GoogleFonts que hace que no ande las fuentes bien gruesas
                    style: GoogleFonts.montserrat(
                      textStyle: Theme.of(context).textTheme.subtitle1,
                      // fontSize: 48,
                      fontWeight: FontWeight.w800,
                      // fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 4),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        subtitle,
                        // Bug en GoogleFonts que hace que no ande las fuentes bien gruesas
                        style: GoogleFonts.montserrat(
                            textStyle: Theme.of(context).textTheme.subtitle1,
                            // fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .color
                                .withOpacity(0.9)
                            // fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
