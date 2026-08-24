String getTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
  } else if (difference.inDays < 30) {
    int weeks = (difference.inDays / 7).floor();
    return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
  } else {
    int months = (difference.inDays / 30).floor();
    return '$months ${months == 1 ? 'month' : 'months'} ago';
  }
}