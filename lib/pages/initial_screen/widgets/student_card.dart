import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback? onPressed;

  const StudentCard({
    super.key,
    required this.name,
    required this.icon,
    this.onTap,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 200,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'edit') {
                        // handle edit
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edit clicked'),
                          ),
                        );
                      } else if (value == 'delete') {
                        onPressed?.call();
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),

                CircleAvatar(
                  radius: 32,
                  child: Icon(
                    icon,
                    size: 36,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  name,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
