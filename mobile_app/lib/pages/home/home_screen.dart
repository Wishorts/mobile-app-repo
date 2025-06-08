import 'package:flutter/material.dart';
import 'package:mobile_app/getX/auth/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text("Home Screen is here!"),
              IconButton(
                onPressed: () async {
                  await AuthController().logout();
                },
                icon: Icon(Icons.logout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
