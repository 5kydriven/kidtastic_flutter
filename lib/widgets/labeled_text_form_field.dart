import 'package:flutter/material.dart';

class LabeledTextFormField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final bool obscure;
  final String? errorMessage;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final String? initialValue;

  const LabeledTextFormField({
    super.key,
    required this.label,
    this.isRequired = false,
    this.obscure = false,
    this.errorMessage,
    this.onChanged,
    this.suffixIcon,
    this.textInputAction,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
          ),
          child: RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              children: isRequired
                  ? [
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]
                  : [],
            ),
          ),
        ),
        const SizedBox(
          height: 6,
        ),

        TextFormField(
          obscureText: obscure,
          onChanged: onChanged,
          initialValue: initialValue,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            errorText: errorMessage,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
