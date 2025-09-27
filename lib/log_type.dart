import 'dart:convert';

/// Enhanced Logger for printing all types of API responses with deep type analysis
class ApiResponseLogger {
  static const String _logPrefix = '[API Response]';

  /// Logs any API response with its type, size, and formatted value
  static void logResponse(
    dynamic response, {
    String? endpoint,
    int? statusCode,
  }) {
    final timestamp = DateTime.now().toIso8601String();

    print('$_logPrefix [$timestamp]');

    if (endpoint != null) {
      print('$_logPrefix Endpoint: $endpoint');
    }

    if (statusCode != null) {
      print('$_logPrefix Status Code: $statusCode');
    }

    print('$_logPrefix ==========================================');
    print('$_logPrefix DEEP TYPE ANALYSIS:');
    print('$_logPrefix ==========================================');

    _analyzeTypeRecursively(response, '', 0);

    print('$_logPrefix ==========================================');
    print('$_logPrefix FORMATTED OUTPUT:');
    print('$_logPrefix ==========================================');

    _logFormattedResponse(response);

    print('$_logPrefix ==========================================');
  }

  /// Recursively analyzes each element in the response and prints its type
  static void _analyzeTypeRecursively(dynamic item, String path, int depth) {
    final indent = '  ' * depth;
    final currentPath = path.isEmpty ? 'root' : path;

    if (item == null) {
      print('$_logPrefix $indent🔸 $currentPath -> Type: NULL, Value: null');
    } else if (item is Map) {
      print(
        '$_logPrefix $indent📁 $currentPath -> Type: Map<${item.keys.isNotEmpty ? item.keys.first.runtimeType : 'dynamic'}, dynamic> (${item.length} keys)',
      );

      item.forEach((key, value) {
        final newPath = path.isEmpty ? '$key' : '$path.$key';
        _analyzeTypeRecursively(value, newPath, depth + 1);
      });
    } else if (item is List) {
      print(
        '$_logPrefix $indent📋 $currentPath -> Type: List<${item.isNotEmpty ? item.first.runtimeType : 'dynamic'}> (${item.length} items)',
      );

      for (int i = 0; i < item.length; i++) {
        final newPath = '$path[$i]';
        _analyzeTypeRecursively(item[i], newPath, depth + 1);

        // Limit output for large lists
        if (i >= 4 && item.length > 5) {
          final remaining = item.length - 5;
          print(
            '$_logPrefix ${'  ' * (depth + 1)}⋮ ... and $remaining more items of similar structure',
          );
          break;
        }
      }
    } else if (item is String) {
      // Check if string contains JSON
      try {
        final decoded = jsonDecode(item);
        print(
          '$_logPrefix $indent📝 $currentPath -> Type: String (JSON Format, ${item.length} chars)',
        );
        _analyzeTypeRecursively(decoded, '$path[parsed]', depth + 1);
      } catch (e) {
        print(
          '$_logPrefix $indent📝 $currentPath -> Type: String (Plain Text, ${item.length} chars)',
        );
        if (item.length > 50) {
          print(
            '$_logPrefix $indent    Preview: "${item.substring(0, 50)}..."',
          );
        } else {
          print('$_logPrefix $indent    Value: "$item"');
        }
      }
    } else if (item is int) {
      print(
        '$_logPrefix $indent🔢 $currentPath -> Type: Integer, Value: $item',
      );
    } else if (item is double) {
      print('$_logPrefix $indent🔢 $currentPath -> Type: Double, Value: $item');
    } else if (item is bool) {
      print('$_logPrefix $indent✅ $currentPath -> Type: Boolean, Value: $item');
    } else if (item is DateTime) {
      print(
        '$_logPrefix $indent📅 $currentPath -> Type: DateTime, Value: ${item.toIso8601String()}',
      );
    } else {
      print(
        '$_logPrefix $indent🔷 $currentPath -> Type: ${item.runtimeType}, Value: $item',
      );

      // Try to analyze custom objects if they have properties
      _analyzeCustomObject(item, path, depth);
    }
  }

  /// Analyzes custom objects to extract their properties if possible
  static void _analyzeCustomObject(dynamic item, String path, int depth) {
    try {
      // Try to convert to map if possible (works with some objects)
      if (item.toString().contains('{') && item.toString().contains('}')) {
        print(
          '$_logPrefix ${'  ' * (depth + 1)}📦 Custom Object Structure: ${item.toString()}',
        );
      }

      // Try to get runtime information
      final runtimeType = item.runtimeType.toString();
      if (runtimeType.contains('<') || runtimeType.contains('_')) {
        print(
          '$_logPrefix ${'  ' * (depth + 1)}🏷️  Detailed Type: $runtimeType',
        );
      }
    } catch (e) {
      // If we can't analyze the custom object, just note it
      print(
        '$_logPrefix ${'  ' * (depth + 1)}⚠️  Complex custom object - unable to analyze structure',
      );
    }
  }

  /// Logs the formatted response (original functionality)
  static void _logFormattedResponse(dynamic response) {
    if (response == null) {
      print('$_logPrefix Value: null');
    } else if (response is Map) {
      _logMap(response);
    } else if (response is List) {
      _logList(response);
    } else if (response is String) {
      _logString(response);
    } else if (response is int) {
      print('$_logPrefix Type: Integer');
      print('$_logPrefix Value: $response');
    } else if (response is double) {
      print('$_logPrefix Type: Double');
      print('$_logPrefix Value: $response');
    } else if (response is bool) {
      print('$_logPrefix Type: Boolean');
      print('$_logPrefix Value: $response');
    } else {
      _logCustomType(response);
    }
  }

  /// Gets a summary of all types found in the response
  static Map<String, int> getTypeSummary(dynamic response) {
    final typeCounts = <String, int>{};
    _countTypes(response, typeCounts);
    return typeCounts;
  }

  /// Recursively counts all types in the response
  static void _countTypes(dynamic item, Map<String, int> typeCounts) {
    if (item == null) {
      typeCounts['null'] = (typeCounts['null'] ?? 0) + 1;
    } else if (item is Map) {
      typeCounts['Map'] = (typeCounts['Map'] ?? 0) + 1;
      item.values.forEach((value) => _countTypes(value, typeCounts));
    } else if (item is List) {
      typeCounts['List'] = (typeCounts['List'] ?? 0) + 1;
      for (var element in item) {
        _countTypes(element, typeCounts);
      }
    } else {
      final typeName = item.runtimeType.toString();
      typeCounts[typeName] = (typeCounts[typeName] ?? 0) + 1;
    }
  }

  /// Logs response with type summary
  static void logResponseWithSummary(
    dynamic response, {
    String? endpoint,
    int? statusCode,
  }) {
    logResponse(response, endpoint: endpoint, statusCode: statusCode);

    final summary = getTypeSummary(response);
    print('$_logPrefix TYPE SUMMARY:');
    summary.forEach((type, count) {
      print('$_logPrefix   $type: $count occurrence(s)');
    });
    print('$_logPrefix ==========================================');
  }

  /// Original helper methods
  static void _logMap(Map response) {
    print(
      '$_logPrefix Type: Map<${response.keys.isNotEmpty ? response.keys.first.runtimeType : 'dynamic'}, dynamic>',
    );
    print('$_logPrefix Size: ${response.length} key(s)');
    print('$_logPrefix Keys: ${response.keys.toList()}');

    try {
      final prettyJson = const JsonEncoder.withIndent('  ').convert(response);
      print('$_logPrefix Value (Pretty JSON):');
      print(prettyJson);
    } catch (e) {
      print('$_logPrefix Value: $response');
    }
  }

  static void _logList(List response) {
    print(
      '$_logPrefix Type: List<${response.isNotEmpty ? response.first.runtimeType : 'dynamic'}>',
    );
    print('$_logPrefix Length: ${response.length} item(s)');

    if (response.isNotEmpty) {
      print('$_logPrefix First Item Type: ${response.first.runtimeType}');

      final preview = response.take(3).toList();
      try {
        final prettyJson = const JsonEncoder.withIndent('  ').convert(preview);
        print('$_logPrefix Preview (First 3 items):');
        print(prettyJson);
        if (response.length > 3) {
          print('$_logPrefix ... and ${response.length - 3} more items');
        }
      } catch (e) {
        print('$_logPrefix Preview: $preview');
      }
    } else {
      print('$_logPrefix Value: []');
    }
  }

  static void _logString(String response) {
    print('$_logPrefix Type: String');
    print('$_logPrefix Length: ${response.length} character(s)');

    try {
      final decoded = jsonDecode(response);
      print('$_logPrefix Format: JSON String');
      final prettyJson = const JsonEncoder.withIndent('  ').convert(decoded);
      print('$_logPrefix Parsed JSON:');
      print(prettyJson);
    } catch (e) {
      print('$_logPrefix Format: Plain String');
      if (response.length > 100) {
        print(
          '$_logPrefix Value (First 100 chars): ${response.substring(0, 100)}...',
        );
        print('$_logPrefix Full Value: $response');
      } else {
        print('$_logPrefix Value: $response');
      }
    }
  }

  static void _logCustomType(dynamic response) {
    print('$_logPrefix Type: ${response.runtimeType}');
    print('$_logPrefix Value: $response');

    try {
      if (response.toString() != response.runtimeType.toString()) {
        print('$_logPrefix String Representation: ${response.toString()}');
      }
    } catch (e) {
      print('$_logPrefix Note: Could not get string representation');
    }
  }

  /// Logs error responses
  static void logError(
    dynamic error, {
    String? endpoint,
    StackTrace? stackTrace,
  }) {
    final timestamp = DateTime.now().toIso8601String();

    print('$_logPrefix ERROR [$timestamp]');

    if (endpoint != null) {
      print('$_logPrefix Endpoint: $endpoint');
    }

    print('$_logPrefix Error Type: ${error.runtimeType}');
    print('$_logPrefix Error Message: $error');

    if (stackTrace != null) {
      print('$_logPrefix Stack Trace:');
      print(stackTrace.toString());
    }

    print('$_logPrefix ==========================================');
  }

  /// Quick log method for simple cases
  static void log(dynamic response) {
    logResponse(response);
  }
}

// Example usage class with complex nested data
class ApiService {
  static Future<Map<String, dynamic>> fetchComplexUserData() async {
    try {
      // Simulate API call with very complex nested structure
      await Future.delayed(const Duration(seconds: 1));
      final response = {
        'status': 'success',
        'user': {
          'id': 123,
          'name': 'أحمد محمد',
          'email': 'ahmed@example.com',
          'age': 25,
          'active': true,
          'balance': 999.99,
          'profile': {
            'bio': 'مطور تطبيقات موبايل',
            'avatar_url': 'https://example.com/avatar.jpg',
            'preferences': {
              'language': 'ar',
              'theme': 'dark',
              'notifications': {'email': true, 'push': false, 'sms': null},
            },
            'social_links': [
              {'platform': 'twitter', 'url': 'https://twitter.com/ahmed'},
              {'platform': 'linkedin', 'url': 'https://linkedin.com/in/ahmed'},
            ],
          },
          'skills': ['Flutter', 'Dart', 'Firebase', 'API Design'],
          'projects': [
            {
              'id': 1,
              'name': 'تطبيق التسوق',
              'technologies': ['Flutter', 'Firebase'],
              'status': 'completed',
              'team_members': [
                {'name': 'سارة', 'role': 'UI/UX'},
                {'name': 'محمد', 'role': 'Backend'},
              ],
            },
          ],
        },
        'metadata': {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'version': '2.1.0',
          'server_info': {
            'region': 'me-central-1',
            'instance': 'api-server-01',
          },
        },
        'raw_json': '{"nested": {"data": [1, 2, {"deep": true}]}}',
      };

      // Log with deep analysis
      ApiResponseLogger.logResponseWithSummary(
        response,
        endpoint: '/api/users/complex',
        statusCode: 200,
      );

      return response;
    } catch (e, stackTrace) {
      ApiResponseLogger.logError(
        e,
        endpoint: '/api/users/complex',
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
