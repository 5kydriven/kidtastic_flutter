import 'package:flutter/material.dart';

class ShapeGameBody extends StatelessWidget {
  const ShapeGameBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          child: Text('Shape'),
        ),
        ListBody(
          children: [
            ListTile(
              title: Text('sample'),
            ),
          ],
        ),
      ],
    );
  }
}
