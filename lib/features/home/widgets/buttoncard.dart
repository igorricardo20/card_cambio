import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonCard extends StatelessWidget {
  final String text;
  final String assetPath;
  final Widget page;

  const ButtonCard({
    super.key,
    required this.text,
    required this.assetPath,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Card(
          clipBehavior: Clip.hardEdge,
          elevation: 0,
          child: Stack(
            children: [
              ClipRRect(
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: 20,
                left: 15,
                child: Text(
                  text,
                  style: GoogleFonts.archivoBlack(
                    textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      backgroundColor: null, // Remove background
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

class FadeIn extends StatefulWidget {
  final Widget child;

  const FadeIn({required this.child});

  @override
  // ignore: library_private_types_in_public_api
  _FadeInState createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}