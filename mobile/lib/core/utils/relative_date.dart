String relativeDatePt(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 60) return 'há ${diff.inMinutes} min';
  if (diff.inHours < 24) return 'há ${diff.inHours}h';
  if (diff.inDays == 1) return 'há 1 dia';
  if (diff.inDays < 30) return 'há ${diff.inDays} dias';
  final months = (diff.inDays / 30).floor();
  if (months == 1) return 'há 1 mês';
  return 'há $months meses';
}

String formatDateTimePt(DateTime dt) {
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  final h = dt.hour.toString().padLeft(2, '0');
  final min = dt.minute.toString().padLeft(2, '0');
  return '$d/$m/${dt.year}, $h:$min';
}
