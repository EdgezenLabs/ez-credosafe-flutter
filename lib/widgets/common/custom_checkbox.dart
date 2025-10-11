import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final void Function(bool?)? onChanged;
  final Widget? title;
  final Color activeColor;
  final Color checkColor;
  final Color borderColor;
  final double size;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment alignment;

  const CustomCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.title,
    this.activeColor = Colors.black87,
    this.checkColor = Colors.white,
    this.borderColor = Colors.grey,
    this.size = 24.0,
    this.padding,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    Widget checkbox = SizedBox(
      width: size,
      height: size,
      child: Checkbox(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
        checkColor: checkColor,
        side: BorderSide(
          color: borderColor.withValues(alpha: 0.4),
          width: 1,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    if (title == null) {
      return checkbox;
    }

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: alignment,
        children: [
          checkbox,
          const SizedBox(width: 8),
          Expanded(child: title!),
        ],
      ),
    );
  }
}
