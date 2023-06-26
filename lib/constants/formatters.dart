import 'package:flutter/services.dart';

final onlyEnglishLetters =
    // FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]'));
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9!@#\$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]+'));

final only15Numbers = LengthLimitingTextInputFormatter(15);

final onlyNumbers =  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
>>>>>>> lib/constants/formatters.dart
