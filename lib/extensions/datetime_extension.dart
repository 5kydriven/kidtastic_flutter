extension DateTimeExtension on DateTime? {
  String toLastPlayedString() {
    if (this == null) return 'Never played';

    final now = DateTime.now();
    final difference = now.difference(this ?? DateTime.now());

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
