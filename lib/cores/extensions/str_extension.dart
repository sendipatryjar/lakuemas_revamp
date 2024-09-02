extension StrExtension on String? {
  String? emptyStringToNull() {
    if ((this ?? '').isEmpty) return null;
    return this;
  }
}
