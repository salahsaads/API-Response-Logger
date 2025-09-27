API Response Logger
صل علي النبي ❤️

A comprehensive Flutter package for logging and analyzing API responses with deep type inspection and detailed formatting. Perfect for debugging, development, and monitoring API interactions in your Flutter applications.

Features
Deep Type Analysis: Recursively analyzes every element in your API response and identifies its data type
Visual Tree Structure: Displays nested data structures in an easy-to-read tree format with emojis
Smart JSON Detection: Automatically detects and parses JSON strings within responses
Type Summary: Provides a complete summary of all data types found in the response
Error Logging: Dedicated error logging with stack trace support
Endpoint Tracking: Track which API endpoint generated each response
Performance Metrics: Optional timestamp and processing time logging
Arabic Support: Full support for Arabic text and RTL content
Large Data Handling: Intelligent truncation and preview for large datasets
Custom Object Analysis: Attempts to analyze custom Dart objects and their properties
Screenshots
Basic Response Logging
[API Response] [2025-09-27T15:30:00.000Z]
[API Response] Endpoint: /api/users
[API Response] Status Code: 200
[API Response] ==========================================
[API Response] DEEP TYPE ANALYSIS:
[API Response] ==========================================
[API Response] 📁 root -> Type: Map<String, dynamic> (3 keys)
[API Response]   📝 status -> Type: String (Plain Text, 7 chars)
[API Response]   📁 user -> Type: Map<String, dynamic> (3 keys)
[API Response]     🔢 user.id -> Type: Integer, Value: 123
[API Response]     📝 user.name -> Type: String (Plain Text, 10 chars)
[API Response] ==========================================
Type Summary
[API Response] TYPE SUMMARY:
[API Response]   Map: 4 occurrence(s)
[API Response]   String: 8 occurrence(s)
[API Response]   int: 12 occurrence(s)
[API Response]   bool: 3 occurrence(s)
[API Response]   double: 2 occurrence(s)
[API Response]   null: 1 occurrence(s)
[API Response] ==========================================
Getting started
Installation
Add this to your package's pubspec.yaml file:

yaml
dependencies:
  api_response_logger: ^1.0.0
Then run:

bash
flutter pub get
Import
dart
import 'package:api_response_logger/api_response_logger.dart';
Usage
Basic Usage
dart
// Simple logging
ApiResponseLogger.log(response);

// With endpoint information
ApiResponseLogger.logResponse(
  response,
  endpoint: '/api/users',
  statusCode: 200
);

// With type summary
ApiResponseLogger.logResponseWithSummary(
  response,
  endpoint: '/api/users',
  statusCode: 200
);
Error Logging
dart
try {
  final response = await apiCall();
  ApiResponseLogger.logResponse(response);
} catch (e, stackTrace) {
  ApiResponseLogger.logError(
    e,
    endpoint: '/api/users',
    stackTrace: stackTrace
  );
}
Real-World Example
dart
class ApiService {
  static Future<Map<String, dynamic>> fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.example.com/users/123'),
        headers: {'Authorization': 'Bearer $token'}
      );
      
      final jsonData = jsonDecode(response.body);
      
      // Log the complete response with deep analysis
      ApiResponseLogger.logResponseWithSummary(
        jsonData,
        endpoint: '/api/users/123',
        statusCode: response.statusCode
      );
      
      return jsonData;
    } catch (e, stackTrace) {
      ApiResponseLogger.logError(
        e,
        endpoint: '/api/users/123',
        stackTrace: stackTrace
      );
      rethrow;
    }
  }
}
Complex Nested Data Example
dart
final complexResponse = {
  'user': {
    'id': 123,
    'profile': {
      'name': 'أحمد محمد',
      'preferences': {
        'language': 'ar',
        'notifications': {
          'email': true,
          'sms': false,
          'push': null
        }
      }
    },
    'activities': [
      {'type': 'login', 'timestamp': 1234567890},
      {'type': 'purchase', 'amount': 99.99}
    ]
  },
  'metadata': '{"server": "api-01", "version": "2.1.0"}'
};

// This will analyze every nested level and data type
ApiResponseLogger.logResponseWithSummary(
  complexResponse,
  endpoint: '/api/user/complete',
  statusCode: 200
);
Getting Type Summary Programmatically
dart
final response = await apiCall();
final typeSummary = ApiResponseLogger.getTypeSummary(response);

print('Found ${typeSummary['String']} strings');
print('Found ${typeSummary['Map']} objects');
print('Found ${typeSummary['List']} arrays');
API Reference
Methods
logResponse(dynamic response, {String? endpoint, int? statusCode})
Logs any API response with basic analysis and formatting.

logResponseWithSummary(dynamic response, {String? endpoint, int? statusCode})
Logs API response with deep analysis plus a type summary at the end.

logError(dynamic error, {String? endpoint, StackTrace? stackTrace})
Logs errors with detailed information and optional stack trace.

getTypeSummary(dynamic response) → Map<String, int>
Returns a map containing the count of each data type found in the response.

log(dynamic response)
Quick logging method for simple cases.

Supported Data Types
The logger can identify and analyze:

Null values 🔸
Maps/Objects 📁
Lists/Arrays 📋
Strings 📝 (with JSON detection)
Integers 🔢
Doubles 🔢
Booleans ✅
DateTime objects 📅
Custom objects 🔷
Configuration
Debug Mode Only
To use this logger only in debug mode:

dart
void logApiResponse(dynamic response) {
  if (kDebugMode) {
    ApiResponseLogger.logResponseWithSummary(response);
  }
}
Custom Log Levels
You can create wrapper functions for different log levels:

dart
class CustomApiLogger {
  static void logInfo(dynamic response, String endpoint) {
    print('[INFO] API Call to $endpoint');
    ApiResponseLogger.logResponse(response, endpoint: endpoint);
  }
  
  static void logWarning(dynamic response, String endpoint) {
    print('[WARNING] API Response might have issues');
    ApiResponseLogger.logResponseWithSummary(response, endpoint: endpoint);
  }
}
Best Practices
Use in Development: This logger is best used during development and testing
Performance: For production apps, consider disabling or limiting the logging
Large Responses: The logger handles large responses intelligently, but be mindful of console output
Error Handling: Always combine with proper error handling in your API calls
Sensitive Data: Be careful not to log sensitive information like passwords or tokens
Performance Considerations
The logger is optimized for development use
Large nested structures are handled with intelligent truncation
Type analysis is performed efficiently with minimal performance impact
Consider disabling in production builds
Examples
Check out the /example folder for complete working examples including:

Basic API response logging
Error handling scenarios
Complex nested data structures
Real-world API integration patterns
Additional Information
Contributing
We welcome contributions! Please see our Contributing Guide for details.

Issues
If you encounter any issues or have feature requests, please file them on our GitHub Issues page.

Changelog
See CHANGELOG.md for a detailed history of changes.

License
This project is licensed under the MIT License - see the LICENSE file for details.

Author
Salah Saad ❤️

Support
📧 Email: kassabksab@gmail.com
💬 Discord: Join our server
📖 Documentation: Full API docs
🐛 Bug Reports: GitHub Issues
Made with Flutter 💙

