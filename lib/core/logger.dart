import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2, // Количество строк stack trace для каждой записи
    errorMethodCount: 8, // Количество строк stack trace для ошибок
    lineLength: 120, // Длина строки вывода
    colors: true, // Вывод в цвете
    printEmojis: true, // Печать эмодзи для каждого лога
    printTime: true, // Печать времени для каждого лога
  ),
);

void logError(Object error, [StackTrace? stackTrace]) {
  logger.e('Error', error: error, stackTrace: stackTrace);
}
