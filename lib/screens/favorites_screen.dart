import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/quote.dart';
import '../services/favorites_service.dart';
import '../widgets/quote_card.dart';
import '../widgets/app_background.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();

  List<Quote> _favorites = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    final quotes = await _favoritesService.getFavorites();

    if (!mounted) return;

    setState(() {
      _favorites = quotes;
      _isLoading = false;
    });
  }

  Future<void> _removeFavorite(Quote quote) async {
    await _favoritesService.removeFavorite(quote);

    if (!mounted) return;

    setState(() {
      _favorites.remove(quote);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: const Text('Favorites', style: TextStyle(fontSize: 32)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _favorites.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bookmarks_outlined,
                            size: 40,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No favorite quotes yet',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the heart icon on a quote you love to save it here.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      final quote = _favorites[index];

                      return Dismissible(
                        key: ValueKey('${quote.text}-${quote.author}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Icon(
                            Icons.delete_rounded,
                            color: colorScheme.onError,
                          ),
                        ),
                        onDismissed: (_) => _removeFavorite(quote),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: QuoteCard(quote: quote),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
