import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/quote.dart';
import '../services/favorites_service.dart';
import '../services/quote_service.dart';
import '../widgets/floating_toast.dart';
import '../widgets/quote_card.dart';
import '../widgets/app_background.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFavorite = false;

  final QuoteService _quoteService = QuoteService();
  final FavoritesService _favoritesService = FavoritesService();

  Quote? _currentQuote;

  bool _isLoading = false;
  bool _isFetchingNew = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRandomQuote();
  }

  Future<void> _loadRandomQuote() async {
    final isFirstLoad = _currentQuote == null;

    setState(() {
      if (isFirstLoad) {
        _isLoading = true;
      } else {
        _isFetchingNew = true;
      }
      _errorMessage = null;
    });

    try {
      final quote = await _quoteService.fetchRandomQuote();
      final isSaved = await _favoritesService.isFavorite(quote);

      if (!mounted) return;

      setState(() {
        _currentQuote = quote;
        isFavorite = isSaved;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Could not load a quote. Please try again in 30 seconds.';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isFetchingNew = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final quote = _currentQuote;
    if (quote == null) return;

    final added = await _favoritesService.addFavorite(quote);
    if (!mounted) return;

    setState(() {
      isFavorite = true;
    });

    showFloatingToast(
      context,
      message: added ? 'Added to favorites' : 'Already in favorites',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Twinkle ',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              TextSpan(
                text: 'Quote',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: const Color(0xFF60A5FA),
                ),
              ),
            ],
          ),
        ),

        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),

                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.12),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),

                          border: Border.all(
                            color: Colors.white.withOpacity(0.18),
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF60A5FA).withOpacity(0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Text(
                          'A tiny spark of inspiration ✨',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.95),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(child: Center(child: _buildContent())),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: (_isLoading || _isFetchingNew)
                              ? null
                              : _loadRandomQuote,
                          icon: const Icon(Icons.autorenew_rounded),
                          label: _isFetchingNew
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('New Quote'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF60A5FA),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFavorite
                              ? const Color(0xFF60A5FA).withOpacity(0.15)
                              : Colors.white.withOpacity(0.05),
                          border: Border.all(
                            color: isFavorite
                                ? const Color(0xFF60A5FA)
                                : Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: IconButton(
                          tooltip: isFavorite
                              ? 'Already in favorites'
                              : 'Add to favorites',
                          onPressed: (_currentQuote == null || isFavorite)
                              ? null
                              : _toggleFavorite,
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFavorite
                                ? const Color(0xFF60A5FA)
                                : Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      OutlinedButton.icon(
                        onPressed: () async {
                          await context.push('/favorites');

                          if (_currentQuote != null && mounted) {
                            final isSaved = await _favoritesService.isFavorite(
                              _currentQuote!,
                            );
                            setState(() {
                              isFavorite = isSaved;
                            });
                          }
                        },
                        icon: const Icon(Icons.bookmarks_rounded),
                        label: const Text('Favorites'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white.withOpacity(0.85),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.25),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const CircularProgressIndicator();
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _loadRandomQuote,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    final quote = _currentQuote;
    if (quote == null) {
      return const SizedBox.shrink();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 700),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(animation);

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
      child: QuoteCard(
        key: ValueKey('${quote.text}-${quote.author}'),
        quote: quote,
      ),
    );
  }
}
