import 'package:intl/intl.dart';

/// Currency stored as integer minor units to avoid binary floating point.
class Money {
  const Money(this.minor, {this.currency = 'USD'});

  final int minor;
  final String currency;

  double get major => minor / 100;

  Money operator +(Money other) {
    _assertSame(other);
    return Money(minor + other.minor, currency: currency);
  }

  Money operator -(Money other) {
    _assertSame(other);
    return Money(minor - other.minor, currency: currency);
  }

  bool operator >(Money other) {
    _assertSame(other);
    return minor > other.minor;
  }

  bool operator >=(Money other) {
    _assertSame(other);
    return minor >= other.minor;
  }

  void _assertSame(Money other) {
    if (other.currency != currency) {
      throw ArgumentError('Currency mismatch');
    }
  }

  String format() {
    final formatter = NumberFormat.simpleCurrency(name: currency);
    return formatter.format(major);
  }

  @override
  bool operator ==(Object other) =>
      other is Money && other.minor == minor && other.currency == currency;

  @override
  int get hashCode => Object.hash(minor, currency);
}
