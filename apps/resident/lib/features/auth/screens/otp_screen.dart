import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import 'package:society_core/constants/app_constants.dart';
import 'package:society_core/theme/app_theme.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phone});

  final String phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  int _resendSeconds = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _resendSeconds = 30;
      _canResend = false;
    });
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _resendSeconds--);
      if (_resendSeconds <= 0) {
        setState(() => _canResend = true);
        return false;
      }
      return true;
    });
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) return;
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const _OtpIcon(),
                      const SizedBox(height: 28),
                      const Text(
                        'Verify OTP',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _Subtitle(phone: widget.phone),
                      const SizedBox(height: 4),
                      TextButton.icon(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.edit_outlined, size: 15),
                        label: const Text('Change number'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          textStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      _OtpInput(
                        controller: _otpController,
                        onCompleted: (_) => _verifyOtp(),
                      ),
                      const SizedBox(height: 36),
                      SizedBox(
                        height: 54,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _verifyOtp,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text('Verify OTP'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _ResendRow(
                        canResend: _canResend,
                        seconds: _resendSeconds,
                        onResend: _startTimer,
                      ),
                      const SizedBox(height: 28),
                      const _SecureNote(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OtpIcon extends StatelessWidget {
  const _OtpIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.sms_outlined, color: AppColors.primary, size: 32),
        ),
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({required this.phone});

  final String phone;

  @override
  Widget build(BuildContext context) {
    final target = phone.isEmpty ? 'your mobile number' : '+91 $phone';
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        children: [
          const TextSpan(text: 'Enter the 6-digit code sent to\n'),
          TextSpan(
            text: target,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _OtpInput extends StatelessWidget {
  const _OtpInput({required this.controller, required this.onCompleted});

  final TextEditingController controller;
  final ValueChanged<String> onCompleted;

  @override
  Widget build(BuildContext context) {
    final defaultPin = PinTheme(
      width: 48,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider, width: 1.5),
      ),
    );

    return Pinput(
      controller: controller,
      length: 6,
      autofocus: true,
      defaultPinTheme: defaultPin,
      separatorBuilder: (_) => const SizedBox(width: 8),
      focusedPinTheme: defaultPin.copyDecorationWith(
        color: AppColors.surface,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      submittedPinTheme: defaultPin.copyDecorationWith(
        color: AppColors.primary.withValues(alpha: 0.06),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      onCompleted: onCompleted,
    );
  }
}

class _ResendRow extends StatelessWidget {
  const _ResendRow({
    required this.canResend,
    required this.seconds,
    required this.onResend,
  });

  final bool canResend;
  final int seconds;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    if (canResend) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Didn't get the code? ",
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          GestureDetector(
            onTap: onResend,
            child: const Text(
              'Resend OTP',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      );
    }
    return Text(
      'Resend OTP in 0:${seconds.toString().padLeft(2, '0')}',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
    );
  }
}

class _SecureNote extends StatelessWidget {
  const _SecureNote();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.lock_outline, size: 14, color: AppColors.textSecondary),
        SizedBox(width: 6),
        Text(
          'Your code is valid for 10 minutes',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
