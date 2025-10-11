import 'package:flutter/material.dart';
import '../../config/app_text_styles.dart';
import '../../config/constants.dart';

class PasswordField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final bool enabled;
  final double borderRadius;
  final bool showLabel; // Added showLabel parameter

  const PasswordField({
    super.key,
    this.label = 'Password',
    this.hintText = 'Password',
    this.controller,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.enabled = true,
    this.borderRadius = 8.0, // Updated to match design
    this.showLabel = true,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel && widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: AppTextStyles.fieldLabel,
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onSaved: widget.onSaved,
          enabled: widget.enabled,
          style: AppTextStyles.bodyText,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTextStyles.fieldHint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: AppColors.borderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: AppColors.borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: AppColors.focusedBorderColor, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: AppColors.errorColor, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: AppColors.errorColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            filled: true,
            fillColor: widget.enabled ? Colors.white : Colors.grey.shade50,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.hintText,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.hintText,
                size: 20,
              ),
              onPressed: _togglePasswordVisibility,
            ),
          ),
        ),
      ],
    );
  }
}
