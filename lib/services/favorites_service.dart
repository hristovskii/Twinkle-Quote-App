import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_quotes';

  Future<List<Quote>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedList = prefs.getStringList(_favoritesKey) ?? <String>[];

      final List<Quote> quotes = [];

      for (final jsonString in storedList) {
        try {
          final Map<String, dynamic> data =
              jsonDecode(jsonString) as Map<String, dynamic>;
          quotes.add(Quote.fromJson(data));
        } catch (e) {
          debugPrint('FavoritesService: skipping invalid entry: $e');
        }
      }

      return quotes;
    } catch (e, stackTrace) {
      debugPrint('FavoritesService: error loading favorites: $e');
      debugPrint(stackTrace.toString());
      return [];
    }
  }

  Future<void> _saveFavorites(List<Quote> quotes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = quotes
          .map((quote) => jsonEncode(quote.toJson()))
          .toList(growable: false);
      await prefs.setStringList(_favoritesKey, jsonList);
    } catch (e, stackTrace) {
      debugPrint('FavoritesService: error saving favorites: $e');
      debugPrint(stackTrace.toString());
    }
  }

  Future<bool> addFavorite(Quote quote) async {
    final current = await getFavorites();

    if (current.contains(quote)) {
      return false;
    }

    current.add(quote);
    await _saveFavorites(current);
    return true;
  }

  Future<void> removeFavorite(Quote quote) async {
    final current = await getFavorites();
    current.remove(quote);
    await _saveFavorites(current);
  }

  Future<bool> isFavorite(Quote quote) async {
    final current = await getFavorites();
    return current.contains(quote);
  }
}
