import 'package:logger/logger.dart';

class LoggerUtil {
  // Sample of abstract logging function
  static void write(String text, {bool isError = false}) {
    Future.microtask(() => print('** $text. isError: [$isError]'));

    logPrint(text);
  }

  static final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      colors: true,
      printTime: true,
    ),
  );

  /// 写log
  static void loggerWithType(
    dynamic message, {
    LoggerType type = LoggerType.debug,
  }) {
    switch (type) {
      case LoggerType.verbose:
        logger.v(message);
        break;
      case LoggerType.debug:
        logger.d(message);
        break;
      case LoggerType.info:
        logger.i(message);
        break;
      case LoggerType.warning:
        logger.w(message);
        break;
      case LoggerType.error:
        logger.e(message);
        break;
      case LoggerType.terrible:
        logger.wtf(message);
        break;
      default:
        logger.d(message);
    }
  }
}

/// logger 类型
enum LoggerType {
  verbose,
  debug,
  info,
  warning,
  error,
  terrible,
}

/// 模仿print，给出一个全局函数，方便调用
void logPrint(
  dynamic message, {
  LoggerType type = LoggerType.info,
}) {
  LoggerUtil.loggerWithType(message, type: type);
}
