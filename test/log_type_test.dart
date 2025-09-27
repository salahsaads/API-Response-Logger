import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

import 'package:log_type/log_type.dart';

// Import your Enhanced ApiResponseLogger here
// import 'package:your_app/api_response_logger.dart';

void main() {
  group('Enhanced ApiResponseLogger Tests - Deep Type Analysis', () {
    
    test('logs null response with deep analysis', () {
      print('\n=== Testing NULL Response with Deep Analysis ===');
      ApiResponseLogger.logResponseWithSummary(
        null,
        endpoint: '/api/test',
        statusCode: 204
      );
    });

    test('logs Map response with nested structure - Deep Analysis', () {
      print('\n=== Testing MAP Response with Deep Analysis ===');
      final mapResponse = {
        'status': 'success',
        'data': {
          'user': {
            'id': 123,
            'name': 'محمد أحمد',
            'email': 'mohamed@test.com',
            'age': 28,
            'balance': 1250.75,
            'active': true,
            'last_login': null,
            'preferences': {
              'language': 'ar',
              'theme': 'dark',
              'notifications': {
                'email': true,
                'sms': false,
                'push': null
              },
              'privacy_settings': [
                {'key': 'profile_visible', 'value': true},
                {'key': 'contact_info_visible', 'value': false}
              ]
            }
          },
          'permissions': ['read', 'write', 'delete', 'admin'],
          'roles': [
            {
              'id': 1,
              'name': 'user',
              'capabilities': ['view_profile', 'edit_profile']
            },
            {
              'id': 2, 
              'name': 'moderator',
              'capabilities': ['moderate_content', 'ban_users']
            }
          ]
        },
        'meta': {
          'timestamp': '2025-09-27T10:30:00Z',
          'version': '2.1.0',
          'server_info': {
            'region': 'me-central-1',
            'load': 0.65,
            'healthy': true
          }
        },
        'debug_info': '{"request_id": "req_123", "processing_time": 45}'
      };
      
      ApiResponseLogger.logResponseWithSummary(
        mapResponse,
        endpoint: '/api/user/profile',
        statusCode: 200
      );
    });

    test('logs List response with mixed types - Deep Analysis', () {
      print('\n=== Testing LIST Response with Deep Analysis ===');
      final listResponse = [
        {'id': 1, 'name': 'أول', 'active': true, 'score': 95.5, 'tags': ['vip', 'premium']},
        {'id': 2, 'name': 'ثاني', 'active': false, 'score': 87.2, 'tags': ['basic']},
        {'id': 3, 'name': 'ثالث', 'active': true, 'score': null, 'tags': []},
        {'id': 4, 'name': 'رابع', 'active': true, 'score': 92.8, 'tags': ['premium', 'gold']},
        {'id': 5, 'name': 'خامس', 'active': false, 'score': 78.1, 'tags': ['basic', 'trial']},
        {'id': 6, 'name': 'سادس', 'active': true, 'score': 88.9, 'tags': ['vip']},
        {'id': 7, 'name': 'سابع', 'active': false, 'score': 82.3, 'tags': ['premium']}
      ];
      
      ApiResponseLogger.logResponseWithSummary(
        listResponse,
        endpoint: '/api/users',
        statusCode: 200
      );
    });

    test('logs String response (Plain text) - Deep Analysis', () {
      print('\n=== Testing STRING Response (Plain) with Deep Analysis ===');
      ApiResponseLogger.logResponse(
        'تم حفظ البيانات بنجاح. العملية اكتملت في الساعة 10:30 صباحاً والنتيجة تم إرسالها إلى البريد الإلكتروني المسجل.',
        endpoint: '/api/save',
        statusCode: 201
      );
    });

    test('logs String response (JSON format) - Deep Analysis', () {
      print('\n=== Testing STRING Response (JSON) with Deep Analysis ===');
      final complexJsonString = jsonEncode({
        'message': 'تم الإنشاء بنجاح',
        'id': 'usr_123456',
        'created_at': '2025-09-27T10:30:00Z',
        'details': {
          'type': 'premium_user',
          'features': ['dashboard', 'analytics', 'api_access'],
          'limits': {
            'api_calls': 10000,
            'storage_gb': 100,
            'users': null
          }
        },
        'metadata': [
          {'key': 'source', 'value': 'mobile_app'},
          {'key': 'version', 'value': '2.1.0'}
        ]
      });
      
      ApiResponseLogger.logResponseWithSummary(
        complexJsonString,
        endpoint: '/api/create',
        statusCode: 201
      );
    });

    test('logs Integer response - Deep Analysis', () {
      print('\n=== Testing INTEGER Response with Deep Analysis ===');
      ApiResponseLogger.logResponse(
        42,
        endpoint: '/api/count',
        statusCode: 200
      );
    });

    test('logs Double response - Deep Analysis', () {
      print('\n=== Testing DOUBLE Response with Deep Analysis ===');
      ApiResponseLogger.logResponse(
        99.99,
        endpoint: '/api/price',
        statusCode: 200
      );
    });

    test('logs Boolean response - Deep Analysis', () {
      print('\n=== Testing BOOLEAN Response with Deep Analysis ===');
      ApiResponseLogger.logResponse(
        true,
        endpoint: '/api/verify',
        statusCode: 200
      );
    });

    test('logs DateTime response (Custom type) - Deep Analysis', () {
      print('\n=== Testing DATETIME Response with Deep Analysis ===');
      ApiResponseLogger.logResponse(
        DateTime(2025, 9, 27, 10, 30, 0),
        endpoint: '/api/timestamp',
        statusCode: 200
      );
    });

    test('logs empty List response - Deep Analysis', () {
      print('\n=== Testing EMPTY LIST Response with Deep Analysis ===');
      ApiResponseLogger.logResponse(
        [],
        endpoint: '/api/empty',
        statusCode: 200
      );
    });

    test('logs empty Map response - Deep Analysis', () {
      print('\n=== Testing EMPTY MAP Response with Deep Analysis ===');
      ApiResponseLogger.logResponse(
        {},
        endpoint: '/api/empty-map',
        statusCode: 200
      );
    });

    test('logs very long String response - Deep Analysis', () {
      print('\n=== Testing LONG STRING Response with Deep Analysis ===');
      final longString = 'هذا نص طويل جداً يحتوي على معلومات مهمة ومفيدة للتطبيق ' * 20;
      
      ApiResponseLogger.logResponse(
        longString,
        endpoint: '/api/long-text',
        statusCode: 200
      );
    });

    test('logs error response with deep analysis', () {
      print('\n=== Testing ERROR Response with Deep Analysis ===');
      try {
        throw Exception('فشل في الاتصال بالخادم - انقطع الاتصال بالإنترنت');
      } catch (e, stackTrace) {
        ApiResponseLogger.logError(
          e,
          endpoint: '/api/failed',
          stackTrace: stackTrace
        );
      }
    });

    test('test complete API flow with deep analysis', () async {
      print('\n=== Testing COMPLETE API FLOW with DEEP ANALYSIS ===');
      
      // Simulate successful API call
      try {
        final response = await _simulateComplexApiCall();
        ApiResponseLogger.logResponseWithSummary(
          response,
          endpoint: '/api/complex-flow',
          statusCode: 200
        );
      } catch (e, stackTrace) {
        ApiResponseLogger.logError(
          e,
          endpoint: '/api/complex-flow',
          stackTrace: stackTrace
        );
      }
    });

    test('test deeply nested structure', () {
      print('\n=== Testing DEEPLY NESTED STRUCTURE ===');
      
      final complexResponse = {
        'level1': {
          'level2': {
            'level3': {
              'level4': {
                'level5': [
                  {
                    'deep_array': [1, 2.5, true, null, 'نص عربي'],
                    'mixed_data': {
                      'numbers': [1, 2, 3],
                      'strings': ['a', 'b', 'c'],
                      'booleans': [true, false],
                      'objects': [
                        {'id': 1, 'active': true},
                        {'id': 2, 'active': false}
                      ]
                    }
                  }
                ]
              }
            }
          }
        },
        'json_string': '{"embedded": {"json": [{"test": true}, {"test": false}]}}',
        'large_array': List.generate(10, (index) => {
          'item_$index': {
            'value': index * 2,
            'active': index % 2 == 0,
            'tags': ['tag${index}a', 'tag${index}b']
          }
        })
      };
      
      ApiResponseLogger.logResponseWithSummary(
        complexResponse,
        endpoint: '/api/deep-nested',
        statusCode: 200
      );
    });

    test('test mixed data types response', () {
      print('\n=== Testing MIXED DATA TYPES ===');
      
      final mixedResponse = {
        'null_value': null,
        'integer': 42,
        'double': 3.14159,
        'boolean_true': true,
        'boolean_false': false,
        'string_plain': 'مرحباً بالعالم',
        'string_json': '{"message": "Hello World", "count": 5}',
        'empty_list': [],
        'empty_map': {},
        'datetime': DateTime(2025, 9, 27, 15, 30, 0),
        'list_mixed': [1, 'string', true, null, {'nested': 'object'}],
        'list_of_maps': [
          {'type': 'A', 'value': 100},
          {'type': 'B', 'value': 200},
          {'type': 'C', 'value': 300}
        ],
        'map_with_lists': {
          'numbers': [1, 2, 3, 4, 5],
          'words': ['واحد', 'اثنان', 'ثلاثة'],
          'mixed': [1, 'two', 3.0, true]
        }
      };
      
      ApiResponseLogger.logResponseWithSummary(
        mixedResponse,
        endpoint: '/api/mixed-types',
        statusCode: 200
      );
    });

    test('test type summary functionality', () {
      print('\n=== Testing TYPE SUMMARY ===');
      
      final testData = {
        'users': [
          {'id': 1, 'active': true, 'score': 95.5},
          {'id': 2, 'active': false, 'score': 87.2},
          {'id': 3, 'active': true, 'score': 92.8}
        ],
        'settings': {
          'theme': 'dark',
          'language': 'ar',
          'notifications': true
        },
        'metadata': null
      };
      
      final summary = ApiResponseLogger.getTypeSummary(testData);
      print('Type Summary Result: $summary');
      
      ApiResponseLogger.logResponseWithSummary(
        testData,
        endpoint: '/api/type-summary',
        statusCode: 200
      );
    });

    test('test real-world API response simulation', () {
      print('\n=== Testing REAL-WORLD API Response ===');
      
      final realWorldResponse = {
        'success': true,
        'status_code': 200,
        'message': 'Data retrieved successfully',
        'data': {
          'user_profile': {
            'user_id': 'usr_789012',
            'username': 'ahmed_dev',
            'display_name': 'أحمد المطور',
            'email': 'ahmed@company.com',
            'phone': '+201234567890',
            'verified_email': true,
            'verified_phone': false,
            'avatar_url': 'https://cdn.example.com/avatars/usr_789012.jpg',
            'cover_url': null,
            'bio': 'مطور تطبيقات موبايل متخصص في Flutter',
            'location': {
              'country': 'Egypt',
              'city': 'Cairo',
              'coordinates': {
                'lat': 30.0444,
                'lng': 31.2357
              }
            },
            'social_links': [
              {'platform': 'twitter', 'url': 'https://twitter.com/ahmed_dev', 'verified': true},
              {'platform': 'github', 'url': 'https://github.com/ahmed-dev', 'verified': true},
              {'platform': 'linkedin', 'url': 'https://linkedin.com/in/ahmed-dev', 'verified': false}
            ],
            'stats': {
              'followers_count': 1250,
              'following_count': 320,
              'posts_count': 89,
              'likes_received': 5420,
              'profile_views': 12890
            },
            'preferences': {
              'language': 'ar-EG',
              'timezone': 'Africa/Cairo',
              'date_format': 'DD/MM/YYYY',
              'time_format': '24h',
              'theme': 'auto',
              'notifications': {
                'email_notifications': true,
                'push_notifications': true,
                'sms_notifications': false,
                'marketing_emails': false,
                'newsletter': true
              },
              'privacy': {
                'profile_visibility': 'public',
                'email_visibility': 'contacts',
                'phone_visibility': 'private',
                'location_sharing': false,
                'activity_status': true
              }
            },
            'subscription': {
              'plan': 'premium',
              'status': 'active',
              'expires_at': '2025-12-31T23:59:59Z',
              'auto_renew': true,
              'features': [
                'unlimited_uploads',
                'priority_support',
                'advanced_analytics',
                'custom_themes',
                'api_access'
              ],
              'usage': {
                'storage_used_gb': 45.7,
                'storage_limit_gb': 100.0,
                'api_calls_this_month': 8750,
                'api_calls_limit': 50000
              }
            }
          },
          'recent_activity': [
            {
              'id': 'act_001',
              'type': 'login',
              'timestamp': '2025-09-27T14:30:15Z',
              'device': {
                'type': 'mobile',
                'os': 'iOS',
                'version': '17.1',
                'app_version': '2.1.0'
              },
              'location': {
                'ip': '192.168.1.100',
                'country': 'EG',
                'city': 'Cairo'
              }
            },
            {
              'id': 'act_002',
              'type': 'purchase',
              'timestamp': '2025-09-27T12:15:30Z',
              'details': {
                'amount': 49.99,
                'currency': 'USD',
                'items': [
                  {
                    'id': 'item_premium_upgrade',
                    'name': 'Premium Subscription - 1 Year',
                    'price': 49.99,
                    'quantity': 1
                  }
                ],
                'payment_method': 'credit_card',
                'transaction_id': 'txn_abc123xyz'
              }
            }
          ]
        },
        'pagination': {
          'current_page': 1,
          'per_page': 20,
          'total_pages': 1,
          'total_items': 1,
          'has_next': false,
          'has_previous': false
        },
        'meta': {
          'request_id': 'req_987654321',
          'timestamp': '2025-09-27T15:45:22Z',
          'processing_time_ms': 142,
          'api_version': 'v2.1',
          'rate_limit': {
            'remaining': 4950,
            'limit': 5000,
            'reset_at': '2025-09-27T16:00:00Z'
          }
        }
      };
      
      ApiResponseLogger.logResponseWithSummary(
        realWorldResponse,
        endpoint: '/api/v2/user/profile/complete',
        statusCode: 200
      );
    });
  });
}

// Helper function to simulate API calls
Future<Map<String, dynamic>> _simulateApiCall() async {
  await Future.delayed(const Duration(milliseconds: 100));
  
  return {
    'success': true,
    'message': 'تمت العملية بنجاح',
    'data': {
      'items': [
        {'id': 1, 'title': 'العنصر الأول'},
        {'id': 2, 'title': 'العنصر الثاني'},
        {'id': 3, 'title': 'العنصر الثالث'}
      ],
      'total': 3,
      'page': 1,
      'has_more': false
    },
    'timestamp': DateTime.now().millisecondsSinceEpoch
  };
}

// Helper function to simulate complex API calls
Future<Map<String, dynamic>> _simulateComplexApiCall() async {
  await Future.delayed(const Duration(milliseconds: 100));
  
  return {
    'status': 'success',
    'data': {
      'user': {
        'id': 12345,
        'profile': {
          'name': 'أحمد محمد',
          'email': 'ahmed@example.com',
          'verified': true,
          'score': 95.7,
          'preferences': {
            'language': 'ar',
            'timezone': 'Africa/Cairo',
            'notifications': {
              'email': true,
              'sms': false,
              'push': null
            }
          }
        },
        'activity': [
          {
            'type': 'login',
            'timestamp': DateTime.now().millisecondsSinceEpoch,
            'device': {'type': 'mobile', 'os': 'ios'}
          },
          {
            'type': 'purchase',
            'timestamp': DateTime.now().millisecondsSinceEpoch - 3600000,
            'amount': 299.99,
            'items': ['item1', 'item2', 'item3']
          }
        ]
      },
      'pagination': {
        'page': 1,
        'limit': 20,
        'total': 150,
        'has_more': true
      }
    },
    'metadata': {
      'request_id': 'req_abc123',
      'processing_time': 0.045,
      'server': 'api-01.example.com'
    },
    'embedded_json': '{"nested": {"array": [1, 2, {"deep": true}], "value": "test"}}',
    'raw_data': [
      {'type': 'A', 'values': [1, 2, 3]},
      {'type': 'B', 'values': [4, 5, 6]},
      {'type': 'C', 'values': [7, 8, 9]}
    ]
  };
}