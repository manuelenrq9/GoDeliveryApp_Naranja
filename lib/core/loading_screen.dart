import 'package:flutter/material.dart';

Future<void> showLoadingScreen(BuildContext context,
    {Widget? destination}) async {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoadingScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );

  await Future.delayed(const Duration(seconds: 1));

  if (destination != null) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  } else {
    Navigator.pop(context);
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Repite la animación en reversa

    _progressAnimation = Tween<double>(begin: -0.5, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Color.fromARGB(246, 245, 243, 243),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Imagen de bienvenida
                Image.asset(
                  'images/LogoLetrasGoDely.png',
                  width: 450,
                  height: 150,
                ),

                // Animación del carro sobre la línea
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Línea fija
                    Container(
                      width: 250,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 175, 91, 7).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    // Carro animado desplazándose sobre la línea
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_progressAnimation.value * 250, 0),
                          child: Icon(
                            Icons.local_shipping,
                            color: const Color(0xFFFF7000),
                            size: 60,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
