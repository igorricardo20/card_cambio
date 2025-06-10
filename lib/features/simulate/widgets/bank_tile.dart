import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BankTile extends StatelessWidget {
  final String name;
  final double finalValue;
  final double ptaxRate;
  final double bankSpread;
  final double iof;
  final Color? color; // Now used for background tint
  final bool isDark;
  final bool isBest; // NEW
  final Border? tileBorder; // NEW

  const BankTile({
    required this.name,
    required this.finalValue,
    required this.ptaxRate,
    required this.bankSpread,
    required this.iof,
    this.color,
    required this.isDark,
    this.isBest = false, // NEW
    this.tileBorder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[50], // Use original grey background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          width: 1.2,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Ensure vertical alignment
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 18,
                    height: 5,
                    decoration: BoxDecoration(
                      color: (color ?? Theme.of(context).colorScheme.primary).withOpacity(1.0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: finalValue, end: finalValue),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                final bool isAnimationDone = value == finalValue;
                final bool isZero = value == 0.0;
                final Color valueColor = isBest && isAnimationDone && !isZero
                    ? (isDark ? const Color(0xFF4BE07B) : const Color(0xFF2EAD5B))
                    : (isDark ? const Color(0xFFD1B97A) : const Color(0xFF5C4715));
                return AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: valueColor,
                    letterSpacing: 0.1,
                  ),
                  child: Text(
                    NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value),
                  ),
                );
              },
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Row(
            children: [
              InfoChip(
                label: 'Spread',
                value: '${bankSpread.toStringAsFixed(2)}%**',
                isDark: isDark,
                dense: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool dense;

  const InfoChip({
    required this.label,
    required this.value,
    required this.isDark,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: dense
          ? const EdgeInsets.symmetric(horizontal: 7, vertical: 2)
          : const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: dense ? 10 : 11,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: dense ? 10 : 11,
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
