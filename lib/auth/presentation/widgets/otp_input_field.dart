import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInputField extends StatefulWidget {
  const OtpInputField({super.key});

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(4, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    for (var node in _focusNodes) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (index) {
        final hasValue = _controllers[index].text.isNotEmpty;
        final isFocused = _focusNodes[index].hasFocus;
        final isActive = hasValue || isFocused;

        return SizedBox(
          width: 64,
          height: 64,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 3) {
                _focusNodes[index + 1].requestFocus();
              } else if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
              setState(() {});
            },
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              // الخانة النشطة (فيها رقم أو متفوكس) لونها غامق، والباقي فاتح شوية
              fillColor: isActive
                  ? const Color(0xFF1A1B2E)
                  : const Color(0xFF262838),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: isActive
                      ? const Color(0xFF12CDD9)
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: isActive
                      ? const Color(0xFF12CDD9)
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF12CDD9),
                  width: 1.5,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}