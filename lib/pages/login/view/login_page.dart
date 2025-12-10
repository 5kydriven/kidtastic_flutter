import 'package:flutter/material.dart';
import 'package:kidtastic_flutter/constants/assets.dart';
import 'package:kidtastic_flutter/widgets/labeled_text_form_field.dart';

import '../../../widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  static const route = '/login';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      constraintsBox: 550,
      imageAssets: Assets.login,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          children: [
            Image.asset(
              Assets.logo,
              height: 200,
              width: 200,
            ),
            Text(
              'KIDTASTIC',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            LabeledTextFormField(
              label: 'Email',
              isRequired: true,
            ),
            LabeledTextFormField(
              label: 'Password',
              isRequired: true,
              obscure: true,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
