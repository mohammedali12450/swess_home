import 'package:flutter/services.dart';

final onlyEnglishLetters =
    FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]'));
