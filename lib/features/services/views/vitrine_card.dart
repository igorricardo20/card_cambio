import 'package:flutter/material.dart';
import 'dart:math' as math;

class VitrineCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final String? badge;
  final bool glowOnce;
  final EdgeInsets glowMargin;

  const VitrineCard({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.badge,
    this.glowOnce = false,
    this.glowMargin = const EdgeInsets.all(6), // Default to previous margin
    super.key,
  });

  @override
  State<VitrineCard> createState() => _VitrineCardState();
}

class _VitrineCardState extends State<VitrineCard> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _glowAnim;
  bool _showGlow = false;
  bool _didGlow = false;

  @override
  void initState() {
    super.initState();
    if (widget.glowOnce) {
      _showGlow = true;
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1200),
      );
      _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller!, curve: Curves.easeInOutCubic),
      );
      _controller!.forward().then((_) async {
        await Future.delayed(const Duration(milliseconds: 250));
        await _controller!.reverse();
        if (mounted) {
          await Future.delayed(const Duration(milliseconds: 80));
          setState(() {
            _showGlow = false;
            _didGlow = true;
          });
          // Start looping the controller for persistent gradient
          _controller!.repeat(period: const Duration(seconds: 2));
        }
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor.withOpacity(0.92);
    final showGlow = widget.glowOnce && (_showGlow || (_glowAnim != null && _controller != null && _controller!.status == AnimationStatus.reverse));
    final showAnimatedGradient = widget.glowOnce && (_showGlow || _didGlow);
    Widget card = Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: widget.onTap,
        child: Container(
          margin: widget.glowMargin, // Use the new property for margin
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: cardColor,
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: showAnimatedGradient && _controller != null && _glowAnim != null
                    ? AnimatedBuilder(
                        animation: _controller!,
                        builder: (context, child) {
                          final animValue = _controller!.value;
                          final angle = 2 * math.pi * animValue;
                          final stops = [0.0, 0.5, 1.0];
                          final colors = [
                            Color.lerp(const Color(0xFF00FFC8), const Color(0xFF00CFFF), animValue)!,
                            Color.lerp(const Color(0xFF00CFFF), const Color(0xFFFF00C8), animValue)!,
                            Color.lerp(const Color(0xFFFF00C8), const Color(0xFFFF2D55), animValue)!,
                          ];
                          return ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                colors: colors,
                                stops: stops,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                transform: GradientRotation(angle),
                              ).createShader(bounds);
                            },
                            child: Icon(widget.icon, size: 28, color: Colors.white),
                          );
                        },
                      )
                    : Icon(
                        widget.icon,
                        size: 28,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : (widget.iconColor ?? Colors.black),
                      ),
              ),
              if (widget.badge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: showAnimatedGradient && _controller != null && _glowAnim != null
                      ? AnimatedBuilder(
                          animation: _controller!,
                          builder: (context, child) {
                            final animValue = _controller!.value;
                            final angle = 2 * math.pi * animValue;
                            final stops = [0.0, 0.5, 1.0];
                            final colors = [
                              Color.lerp(const Color(0xFF00FFC8), const Color(0xFF00CFFF), animValue)!,
                              Color.lerp(const Color(0xFF00CFFF), const Color(0xFFFF00C8), animValue)!,
                              Color.lerp(const Color(0xFFFF00C8), const Color(0xFFFF2D55), animValue)!,
                            ];
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    colors: colors,
                                    stops: stops,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    transform: GradientRotation(angle),
                                  ).createShader(bounds);
                                },
                                blendMode: BlendMode.srcIn,
                                child: Text(
                                  widget.badge!,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.badge!,
                            style: theme.textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 2, right: 8),
                  child: Text(
                    widget.title,
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.normal, fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // Always keep the card size stable by wrapping the glow in a Positioned.fill
    if (showGlow) {
      const double glowPadding = 5.0; // Padding between glow and card content
      return SizedBox(
        height: 140,
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(glowPadding),
              child: AnimatedBuilder(
                animation: _glowAnim!,
                builder: (context, child) {
                  final animValue = _glowAnim!.value;
                  final angle = 2 * math.pi * animValue;
                  final stops = [0.0, 0.5, 1.0];
                  final colors = [
                    Color.lerp(const Color(0xFF00FFC8), const Color(0xFF00CFFF), animValue)!,
                    Color.lerp(const Color(0xFF00CFFF), const Color(0xFFFF00C8), animValue)!,
                    Color.lerp(const Color(0xFFFF00C8), const Color(0xFFFF2D55), animValue)!,
                  ];
                  return Opacity(
                    opacity: animValue,
                    child: CustomPaint(
                      painter: _AnimatedGradientBorderPainter(
                        borderRadius: 20,
                        strokeWidth: 3.2 + 0.8 * animValue,
                        colors: colors,
                        stops: stops,
                        angle: angle,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: card,
            ),
          ],
        ),
      );
    }
    return SizedBox(
      height: 140,
      width: double.infinity,
      child: card,
    );
  }
}

class _AnimatedGradientBorderPainter extends CustomPainter {
  final double borderRadius;
  final double strokeWidth;
  final List<Color> colors;
  final List<double> stops;
  final double angle;

  _AnimatedGradientBorderPainter({
    required this.borderRadius,
    required this.strokeWidth,
    required this.colors,
    required this.stops,
    this.angle = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final paint = Paint()
      ..shader = LinearGradient(
        colors: colors,
        stops: stops,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        transform: GradientRotation(angle),
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_AnimatedGradientBorderPainter oldDelegate) {
    return oldDelegate.colors != colors ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.angle != angle;
  }
}
