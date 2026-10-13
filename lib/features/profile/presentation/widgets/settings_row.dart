import 'package:flutter/material.dart';

class SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final String? valueText;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.valueText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (valueText != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  valueText!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              const Icon(Icons.chevron_right, color: Colors.white54, size: 20),
          ],
        ),
      ),
    );
  }
}
