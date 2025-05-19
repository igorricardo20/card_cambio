import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BankTile extends StatelessWidget {
  final String name;
  final double finalValue;
  final double ptaxRate;
  final double bankSpread;
  final double iof;
  final Color color;
  final bool isDark;
  final bool isBest; // NEW

  const BankTile({
    required this.name,
    required this.finalValue,
    required this.ptaxRate,
    required this.bankSpread,
    required this.iof,
    required this.color,
    required this.isDark,
    this.isBest = false, // NEW
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.cardColor,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0), // Tighter margin for mobile
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Slightly smaller radius for mobile
        side: BorderSide(color: theme.dividerColor.withOpacity(0.7), width: 1),
      ),
      shadowColor: theme.shadowColor.withOpacity(0.04),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12), // Less padding for mobile
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: theme.textTheme.bodyMedium?.color,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ),
                                TweenAnimationBuilder<double>(
                                  tween: Tween<double>(begin: finalValue, end: finalValue),
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, value, child) {
                                    final bool isAnimationDone = value == finalValue;
                                    final bool isZero = value == 0.0;
                                    final Color targetColor = isBest && isAnimationDone && !isZero
                                        ? const Color(0xFF2EAD5B)
                                        : const Color(0xFF5C4715);
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: AnimatedDefaultTextStyle(
                                        duration: const Duration(milliseconds: 350),
                                        curve: Curves.easeOutCubic,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: targetColor,
                                          letterSpacing: 0.1,
                                        ),
                                        child: Text(
                                          NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                _InfoChip(label: 'PTAX', value: ptaxRate.toStringAsFixed(4), color: color, theme: theme),
                                _InfoChip(label: 'Spread', value: '${bankSpread.toStringAsFixed(2)}%', color: color, theme: theme),
                                _InfoChip(label: 'IOF', value: '${iof.toStringAsFixed(2)}%', color: color, theme: theme),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final ThemeData theme;
  const _InfoChip({required this.label, required this.value, required this.color, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Slightly smaller for mobile
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? color.withOpacity(0.10)
            : color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8), // Slightly smaller for mobile
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 10.5, // Smaller font size for mobile
          color: color,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
