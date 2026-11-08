import 'package:flutter/material.dart';
import '../config.dart';

class CreditFooter extends StatelessWidget {
  const CreditFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          AppConfig.creditLine,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

void showAbout(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationName: AppConfig.appName,
    applicationVersion: '1.0.0',
    children: const [Text(AppConfig.creditLine)],
  );
}
