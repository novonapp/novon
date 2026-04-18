import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../widgets/pin_widgets.dart';
import '../../../core/theme/novon_colors.dart';

/// Interface for establishing a secure localized access identifier, providing 
/// an auxiliary security layer for the application.
class PinSetupScreen extends StatefulWidget {
  final bool isChangeMode;

  const PinSetupScreen({super.key, this.isChangeMode = false});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final _storage = const FlutterSecureStorage();
  String _pin1 = '';
  String _pin2 = '';
  bool _confirming = false;
  String _message = 'Create a secure PIN';
  bool _isError = false;

  void _handleDigit(String digit) {
    setState(() {
      _isError = false;
      if (!_confirming) {
        if (_pin1.length < 4) {
          _pin1 += digit;
          if (_pin1.length == 4) {
            _confirming = true;
            _message = 'Confirm your PIN';
          }
        }
      } else {
        if (_pin2.length < 4) {
          _pin2 += digit;
          if (_pin2.length == 4) {
            _verifyAndSave();
          }
        }
      }
    });
  }

  void _handleDelete() {
    setState(() {
      _isError = false;
      if (!_confirming) {
        if (_pin1.isNotEmpty) _pin1 = _pin1.substring(0, _pin1.length - 1);
      } else {
        if (_pin2.isNotEmpty) {
          _pin2 = _pin2.substring(0, _pin2.length - 1);
        } else {
          _confirming = false;
          _message = 'Create a secure PIN';
        }
      }
    });
  }

  /// Validates phase-based PIN equivalence and commits the encrypted 
  /// identifier to secure localized storage.
  Future<void> _verifyAndSave() async {
    if (_pin1 == _pin2) {
      await _storage.write(key: 'app_lock_custom_pin', value: _pin1);
      if (!mounted) return;
      context.pop(true);
    } else {
      setState(() {
        _pin2 = '';
        _message = 'PINs do not match. Try again.';
        _isError = true;
      });
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _pin1 = '';
            _pin2 = '';
            _confirming = false;
            _message = 'Create a secure PIN';
            _isError = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NovonColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(false),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Icon(
              Icons.lock_person_rounded,
              size: 64,
              color: NovonColors.primary,
            ),
            const SizedBox(height: 24),
            Text(
              _message,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: _isError ? NovonColors.error : NovonColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'A custom PIN adds an extra layer of privacy.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: NovonColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 48),
            PinIndicator(
              length: 4,
              currentLength: _confirming ? _pin2.length : _pin1.length,
              isError: _isError,
            ),
            const Spacer(),
            PinPad(
              onDigitPressed: _handleDigit,
              onDeletePressed: _handleDelete,
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
