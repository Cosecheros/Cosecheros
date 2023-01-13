import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosecheros/data/current_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ButtonProfile extends StatelessWidget {
  const ButtonProfile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      mini: true,
      backgroundColor: Colors.white,
      child: Icon(
        Icons.face_rounded,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      onPressed: () {
        showProfile(context);
      },
    );
  }

  showProfile(context) async {
    String name = CurrentUser.instance.data.name?.trim() ?? "";
    String photoURL = CurrentUser.instance.data.photo;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  foregroundImage:
                  photoURL == null ? null : NetworkImage(photoURL),
                  child: Text(name.isEmpty ? 'A' : getInitials(name)),
                ),
                SizedBox(height: 16),
                Text(
                  name.isEmpty ? "Anónimo" : name,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Cosechero aprendiz",
                  style: Theme.of(context).textTheme.caption,
                ),
                SizedBox(height: 16),
                TextButton(
                  child: Text(
                    "cambiar tipo de usuario".toUpperCase(),
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .set({"type": null});
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    "cerrar sesión".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.red[600]),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  String getInitials(String input) =>
      input.split(' ').map((e) => e[0]).take(2).join();

}
