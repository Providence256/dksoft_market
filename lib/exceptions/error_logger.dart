import 'dart:developer';

import 'package:dksoft_market/exceptions/app_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'error_logger.g.dart';

class ErrorLogger {
  void logError(Object error, StackTrace? stackTrace) {
    log('$error, $stackTrace');
  }

  void logAppException(AppException exception) {
    log('$exception');
  }
}

@riverpod
ErrorLogger errorLogger(Ref ref) {
  return ErrorLogger();
}
