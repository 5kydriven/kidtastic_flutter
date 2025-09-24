import 'package:flutter/material.dart';

class HomeGames extends StatelessWidget {
  const HomeGames({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text('Card ${index + 1}'),
                    ),
                  );
                },
                childCount: 50,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 columns
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1, // square cards
              ),
            ),
          ),
        ],
      ),
    );
  }
}
