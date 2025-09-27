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

    print('══════════════════════════════════════════════');
    print('📡 API RESPONSE');
    if (endpoint != null) print('📍 Endpoint : $endpoint');
    if (statusCode != null) print('📊 Status   : $statusCode');
    print('🕒 Time     : $timestamp');
    print('──────────────────────────────────────────────');

    print('🔎 TYPE ANALYSIS');
    print('──────────────────────────────────────────────');
    _analyzeTypeRecursively(response, '', 0);

    print('──────────────────────────────────────────────');
    print('📑 FORMATTED OUTPUT');
    print('──────────────────────────────────────────────');
    _logFormattedResponse(response);

    print('══════════════════════════════════════════════');
  }

  /// Recursively analyzes each element in the response and prints its type
  static void _analyzeTypeRecursively(dynamic item, String path, int depth) {
    final indent = '  ' * depth;
    final currentPath = path.isEmpty ? 'root' : path;

    if (item == null) {
      print('$indent🔸 $currentPath -> NULL');
    } else if (item is Map) {
      print('$indent📁 $currentPath -> Map (${item.length} keys)');
      item.forEach((key, value) {
        final newPath = path.isEmpty ? '$key' : '$path.$key';
        _analyzeTypeRecursively(value, newPath, depth + 1);
      });
    } else if (item is List) {
      print('$indent📋 $currentPath -> List (${item.length} items)');
      for (int i = 0; i < item.length; i++) {
        final newPath = '$path[$i]';
        _analyzeTypeRecursively(item[i], newPath, depth + 1);

        if (i >= 4 && item.length > 5) {
          final remaining = item.length - 5;
          print('${'  ' * (depth + 1)}⋮ ... and $remaining more items');
          break;
        }
      }
    } else if (item is String) {
      try {
        final decoded = jsonDecode(item);
        print('$indent📝 $currentPath -> String (JSON)');
        _analyzeTypeRecursively(decoded, '$path[parsed]', depth + 1);
      } catch (e) {
        print('$indent📝 $currentPath -> String (${item.length} chars)');
        if (item.length > 50) {
          print('$indent   Preview: "${item.substring(0, 50)}..."');
        } else {
          print('$indent   Value: "$item"');
        }
      }
    } else if (item is int) {
      print('$indent🔢 $currentPath -> Integer : $item');
    } else if (item is double) {
      print('$indent🔢 $currentPath -> Double : $item');
    } else if (item is bool) {
      print('$indent✅ $currentPath -> Boolean : $item');
    } else if (item is DateTime) {
      print('$indent📅 $currentPath -> DateTime : ${item.toIso8601String()}');
    } else {
      print('$indent🔷 $currentPath -> ${item.runtimeType} : $item');
      _analyzeCustomObject(item, path, depth);
    }
  }

  static void _analyzeCustomObject(dynamic item, String path, int depth) {
    try {
      if (item.toString().contains('{') && item.toString().contains('}')) {
        print('${'  ' * (depth + 1)}📦 Custom Object: ${item.toString()}');
      }
      final runtimeType = item.runtimeType.toString();
      if (runtimeType.contains('<') || runtimeType.contains('_')) {
        print('${'  ' * (depth + 1)}🏷️  Detailed Type: $runtimeType');
      }
    } catch (e) {
      print('${'  ' * (depth + 1)}⚠️  Complex custom object');
    }
  }

  /// Logs the formatted response (original functionality)
  static void _logFormattedResponse(dynamic response) {
    if (response == null) {
      print('Value: null');
    } else if (response is Map) {
      _logMap(response);
    } else if (response is List) {
      _logList(response);
    } else if (response is String) {
      _logString(response);
    } else if (response is int || response is double || response is bool) {
      print('Value: $response');
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

  static void logResponseWithSummary(
    dynamic response, {
    String? endpoint,
    int? statusCode,
  }) {
    logResponse(response, endpoint: endpoint, statusCode: statusCode);

    final summary = getTypeSummary(response);
    print('📊 TYPE SUMMARY');
    summary.forEach((type, count) {
      print('  $type : $count');
    });
    print('══════════════════════════════════════════════');
  }

  static void _logMap(Map response) {
    print('Type: Map (${response.length} keys)');
    try {
      final prettyJson = const JsonEncoder.withIndent('  ').convert(response);
      print(prettyJson);
    } catch (e) {
      print('Value: $response');
    }
  }

  static void _logList(List response) {
    print('Type: List (${response.length} items)');
    if (response.isNotEmpty) {
      final preview = response.take(3).toList();
      try {
        final prettyJson = const JsonEncoder.withIndent('  ').convert(preview);
        print('Preview (First 3 items):');
        print(prettyJson);
        if (response.length > 3) {
          print('... and ${response.length - 3} more items');
        }
      } catch (e) {
        print('Preview: $preview');
      }
    } else {
      print('Value: []');
    }
  }

  static void _logString(String response) {
    print('Type: String (${response.length} chars)');
    try {
      final decoded = jsonDecode(response);
      final prettyJson = const JsonEncoder.withIndent('  ').convert(decoded);
      print('Format: JSON String');
      print(prettyJson);
    } catch (e) {
      print('Format: Plain String');
      if (response.length > 100) {
        print('Value (First 100): ${response.substring(0, 100)}...');
      } else {
        print('Value: $response');
      }
    }
  }

  static void _logCustomType(dynamic response) {
    print('Type: ${response.runtimeType}');
    print('Value: $response');
  }

  /// Logs error responses
  static void logError(
    dynamic error, {
    String? endpoint,
    StackTrace? stackTrace,
  }) {
    final timestamp = DateTime.now().toIso8601String();

    print('══════════════════════════════════════════════');
    print('❌ API ERROR');
    if (endpoint != null) print('📍 Endpoint : $endpoint');
    print('🕒 Time     : $timestamp');
    print('──────────────────────────────────────────────');
    print('⚠️ Type    : ${error.runtimeType}');
    print('📝 Message : $error');
    if (stackTrace != null) {
      print('📌 Stack Trace');
      print(stackTrace.toString());
    }
    print('══════════════════════════════════════════════');
  }

  static void log(dynamic response) {
    logResponse(response);
  }
}
