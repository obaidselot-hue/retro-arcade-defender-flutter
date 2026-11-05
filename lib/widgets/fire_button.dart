import 'package:flutter/material.dart';

class FireButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const FireButton({super.key, this.onPressed});

  @override
  _FireButtonState createState() => _FireButtonState();
}

class _FireButtonState extends State<FireButton> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _glowAnimation = Tween<double>(begin: 10.0, end: 25.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final diameter = size.shortestSide * 0.18; // Responsive size
    final upwardShift = size.height * 0.05;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -upwardShift),
            child: Transform.scale(
              scale: _isPressed ? 0.9 : 1.0,
              child: Container(
                width: diameter,
                height: diameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.red.shade900,
                      Colors.red.shade700,
                      Colors.red.shade400,
                    ],
                    stops: [0.0, 0.7, 1.0],
                    center: Alignment.center,
                    radius: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.8),
                      blurRadius: _glowAnimation.value,
                      spreadRadius: _glowAnimation.value / 2,
                    ),
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.7),
                      blurRadius: _glowAnimation.value * 0.8,
                      spreadRadius: _glowAnimation.value / 3,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'FIRE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: diameter * 0.4,
                      color: Colors.orangeAccent,
                      shadows: [
                        Shadow(
                          blurRadius: _glowAnimation.value,
                          color: Colors.orangeAccent,
                          offset: Offset(0, 0),
                        ),
                        Shadow(
                          blurRadius: _glowAnimation.value / 2,
                          color: Colors.redAccent,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
