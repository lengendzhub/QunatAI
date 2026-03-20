// lib/features/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/widgets/ambient_background.dart';
import '../../shared/widgets/liquid_glass_card.dart';
import '../../shared/widgets/spring_button.dart';
import 'auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AmbientBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: LiquidGlassCard(
                borderRadius: 22,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('QuantAI', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    const Text('Connect your Deriv API token to start trading.'),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _controller,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Deriv API token'),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => launchUrl(Uri.parse('https://deriv.com/account/api-token')),
                      child: const Text(
                        'Get your token at deriv.com/account/api-token',
                        style: TextStyle(color: Color(0xFF80BFFF), fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SpringButton(
                      hapticHeavy: true,
                      onTap: auth.isLoading
                          ? null
                          : () => ref.read(authProvider.notifier).connect(_controller.text.trim()),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00D4AA).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF00D4AA).withValues(alpha: 0.35)),
                        ),
                        child: Center(
                          child: auth.isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Connect', style: TextStyle(color: Color(0xFF00D4AA), fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (auth.hasError)
                      Text(
                        '${auth.error}',
                        style: const TextStyle(color: Color(0xFFFF4757), fontSize: 12),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
