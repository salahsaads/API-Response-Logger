# API Response Logger 🔍
<<صل عل النبي>>
A Flutter package for logging and analyzing API responses with **deep type inspection** and **structured formatting**.
Perfect for debugging, development, and monitoring API interactions.

---

## ✨ Features

* **Deep Type Analysis**: Recursively detects data types at all levels.
* **Tree Structure View**: Easy-to-read nested data visualization.
* **Smart JSON Detection**: Parses JSON strings automatically.
* **Type Summary**: Count of all detected data types.
* **Error Logging**: With stack trace support.
* **Endpoint Tracking**: Logs which API endpoint generated the response.
* **Performance Metrics**: Optional timestamps & processing time.
* **Arabic & RTL Support** ✅
* **Large Data Handling**: Intelligent truncation & previews.
* **Custom Object Analysis**: Attempts to analyze Dart objects.

---

## 🚀 Getting Started

### Installation

```yaml
dependencies:
log_type: ^0.0.4
```

Run:

```bash
flutter pub get
```

### Import

```dart
import 'package:api_response_logger/api_response_logger.dart';
```

---

## 📌 Usage

### Basic

```dart
ApiResponseLogger.log(response);
```

### With Endpoint & Status

```dart
ApiResponseLogger.logResponse(
  response,
  endpoint: '/api/users',
  statusCode: 200,
);
```

### With Type Summary

```dart
ApiResponseLogger.logResponseWithSummary(
  response,
  endpoint: '/api/users',
  statusCode: 200,
);
```

### Error Logging

```dart
try {
  final response = await apiCall();
  ApiResponseLogger.logResponse(response);
} catch (e, stackTrace) {
  ApiResponseLogger.logError(
    e,
    endpoint: '/api/users',
    stackTrace: stackTrace,
  );
}
```

---

## 🛠 Example

```dart
final complexResponse = {
  'user': {
    'id': 123,
    'profile': {
      'name': 'أحمد محمد',
      'preferences': {
        'language': 'ar',
        'notifications': {'email': true, 'sms': false, 'push': null}
      }
    }
  },
  'metadata': '{"server": "api-01", "version": "2.1.0"}'
};

ApiResponseLogger.logResponseWithSummary(
  complexResponse,
  endpoint: '/api/user/complete',
  statusCode: 200,
);
```

---

## 📊 Type Summary (Programmatic)

```dart
final summary = ApiResponseLogger.getTypeSummary(response);
print('Strings: ${summary['String']}');
print('Maps: ${summary['Map']}');
print('Lists: ${summary['List']}');
```

---

## 📚 API Reference

* `logResponse` → Logs response with basic analysis.
* `logResponseWithSummary` → Deep analysis + type summary.
* `logError` → Logs errors + optional stack trace.
* `getTypeSummary` → Returns type counts.
* `log` → Quick simple logger.

---

## ⚡ Best Practices

* Use mainly during **development/testing**.
* Avoid logging **sensitive data**.
* Large responses are truncated automatically.
* Can be disabled in **production** with `kDebugMode`.

---

## 📖 Extra

* Full examples in `/example`.
* Licensed under **MIT**.

👨‍💻 Author: Salah Saad
📧 Email: [kassabksab@gmail.com](mailto:kassabksab@gmail.com)

