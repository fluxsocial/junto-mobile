import 'dart:async';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/widgets/buttons/call_to_action.dart';
import 'package:junto_beta_mobile/widgets/dialogs/user_feedback.dart';

class ResendVerificationCodeButton extends StatefulWidget {
  const ResendVerificationCodeButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  _ResendVerificationCodeButtonState createState() =>
      _ResendVerificationCodeButtonState();
}

class _ResendVerificationCodeButtonState
    extends State<ResendVerificationCodeButton> {
  Timer _resendTimer;
  int _waitingTime;

  void _startTimer() {
    final limit = 30;
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _waitingTime = limit - timer.tick;
      if (timer.tick > limit) {
        _waitingTime = null;
        _resendTimer.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CallToActionButton(
      callToAction: () {
        if (_waitingTime == null) {
          _startTimer();
          widget.onPressed();
        } else {
          showFeedback(context,
              message: 'Please try again in $_waitingTime seconds');
        }
      },
      title: _waitingTime != null
          ? 'PLEASE WAIT $_waitingTime'
          : S.of(context).resend_verification_code.toUpperCase(),
      transparent: true,
    );
  }
}
