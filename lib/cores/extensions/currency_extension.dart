import 'package:intl/intl.dart';

extension NumCurrencyExtension on num {
  String? toIdr({bool isShorten = false}) {
    String val =
        NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0)
            .format(this);
    if (isShorten == true) {
      var valueSplited = val.split('.');
      if (valueSplited.length > 2) {
        valueSplited.removeLast();
        val = '${valueSplited.join('.')} k';
      }
    }
    return val;
  }

  String toGold4Dec() {
    String? valueStr = toStringAsFixed(8);
    String valueStrFront = valueStr.split('.')[0];
    String valueStrDecimal = valueStr.split('.')[1];
    if (valueStrDecimal.length > 4) {
      valueStrDecimal = valueStrDecimal.substring(0, 4);
      valueStr = '$valueStrFront.$valueStrDecimal';
    }
    return valueStr;
  }

  String toGold4DecCeil() {
    String? valueStr = toStringAsFixed(8);
    String valueStrFront = valueStr.split('.')[0];
    String valueStrDecimal = valueStr.split('.')[1];
    if (valueStrDecimal.length > 4) {
      valueStrDecimal = valueStrDecimal.substring(0, 4);
      valueStr = '$valueStrFront.$valueStrDecimal';
      double valueDbl = double.parse(valueStr);
      if (this != 0) {
        valueDbl = valueDbl + 0.0001;
      }
      valueStr = valueDbl.toStringAsFixed(4);
    }
    return valueStr;
  }

  String toGold6Dec() {
    String? valueStr = toStringAsFixed(8);
    String valueStrFront = valueStr.split('.')[0];
    String valueStrDecimal = valueStr.split('.')[1];
    if (valueStrDecimal.length > 6) {
      valueStrDecimal = valueStrDecimal.substring(0, 6);
      valueStr = '$valueStrFront.$valueStrDecimal';
    }
    return valueStr;
  }
}

extension StringCurrencyExtension on String? {
  String toIdr() {
    var parsed = double.tryParse(this ?? '');
    if (parsed == null) {
      return this ?? '';
    }
    return NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0)
        .format(parsed);
  }

  String toGold4Dec() {
    String? valueStr = this ?? '';
    String valueStrFront = valueStr.split('.')[0];
    String valueStrDecimal =
        valueStr.contains('.') ? valueStr.split('.')[1] : '';
    if (valueStrDecimal.length > 4) {
      valueStrDecimal = valueStrDecimal.substring(0, 4);
      valueStr = '$valueStrFront.$valueStrDecimal';
    }
    return valueStr;
  }
}
