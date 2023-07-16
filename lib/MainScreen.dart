import 'package:flutter/material.dart';
import 'package:shoppingbusiness/ProductForm.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets\\background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 500,
              decoration: BoxDecoration(
                color: const Color.fromARGB(86, 96, 125, 139),
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromARGB(86, 96, 125, 139),
                      offset: Offset(0, 5),
                      blurRadius: 9,
                      spreadRadius: 10)
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Shopping Dev",
                    style: TextStyle(
                      fontSize: 75,
                      color: Theme.of(context).colorScheme.background,
                      shadows: [
                        Shadow(
                          color: Theme.of(context).colorScheme.scrim,
                          blurRadius: 5,
                          offset: const Offset(1, 9),
                        ),
                        const Shadow(
                          color: Color.fromARGB(255, 0, 102, 255),
                          blurRadius: 5,
                          offset: Offset(1, 9),
                        ),
                        const Shadow(
                          color: Color.fromARGB(255, 0, 34, 51),
                          blurRadius: 5,
                          offset: Offset(1, 15),
                        ),
                      ],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const ProductForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
