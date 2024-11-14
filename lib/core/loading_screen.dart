import 'package:flutter/material.dart';

Future<void> showLoadingScreen(BuildContext context, {Widget? destination}) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoadingScreen()),
  );

  await Future.delayed(const Duration(milliseconds: 1500));

  if (destination != null){
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }else{
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                  'images/LogoGoDely.png',
                  width: 270,
                  height: 270,
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(color: Colors.orange),
          ],
        ),
      ),
    );
  }
}