import 'package:flutter/material.dart';

class APIError implements Exception {
  final String message;

  APIError(this.message);

  @override
  String toString() {
    return 'APIError: $message';
  }
}
