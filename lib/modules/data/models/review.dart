import 'dart:convert';

import 'package:flutter/foundation.dart' show immutable;

@immutable
class Review {
  final int code;
  final bool status;
  final String message;

  const Review({
    required this.code,
    required this.status,
    required this.message,
  });

  Review.fromMap(Map<String, dynamic> map)
      : code = map['code'] ?? -1,
        status = map['status'] ?? false,
        message = map['message'] ?? "";

  factory Review.fromJson(String str) => Review.fromMap(json.decode(str));
}
