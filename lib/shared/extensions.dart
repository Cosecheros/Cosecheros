extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
  String human() {
    return this.replaceAll('_', ' ').capitalize() + ".";
  }
}
