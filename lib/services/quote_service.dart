import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class QuoteService {
  static const String _baseUrl = 'https://zenquotes.io/api/random';

  Future<Quote> fetchRandomQuote() async {
    try {
      final uri = Uri.parse(_baseUrl);
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        debugPrint('QuoteService: non-200 status code: ${response.statusCode}');
        throw Exception('Failed to load quote');
      }

      final decoded = jsonDecode(response.body);

      if (decoded is List &&
          decoded.isNotEmpty &&
          decoded.first is Map<String, dynamic>) {
        return Quote.fromApiJson(decoded.first as Map<String, dynamic>);
      }

      debugPrint('QuoteService: unexpected response format: ${response.body}');
      throw Exception('Invalid quote data');
    } catch (e, stackTrace) {
      debugPrint('QuoteService: error fetching quote: $e');
      debugPrint(stackTrace.toString());
      rethrow;
    }
  }
}
