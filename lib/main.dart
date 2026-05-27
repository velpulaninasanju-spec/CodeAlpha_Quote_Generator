import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const QuoteGeneratorApp());
}

class QuoteGeneratorApp extends StatelessWidget {
  const QuoteGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elegant Quotes',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const QuotePage(),
    );
  }
}

class QuotePage extends StatefulWidget {
  const QuotePage({super.key});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  // Hardcoded repository of inspiring quotes
  final List<Map<String, String>> _quotes = [
    {
      "text": "The only way to do great work is to love what you do.",
      "author": "Steve Jobs"
    },
    {
      "text": "In the middle of difficulty lies opportunity.",
      "author": "Albert Einstein"
    },
    {
      "text": "Do not go where the path may lead, go instead where there is no path and leave a trail.",
      "author": "Ralph Waldo Emerson"
    },
    {
      "text": "The best way to predict the future is to create it.",
      "author": "Peter Drucker"
    },
    {
      "text": "Everything you can imagine is real.",
      "author": "Pablo Picasso"
    },
    {
      "text": "Make each day your masterpiece.",
      "author": "John Wooden"
    }
  ];

  int _currentIndex = 0;

  // Navigation history tracker
  final List<int> _historyStack = [];

  // List to store saved quotes chosen by the user
  final List<Map<String, String>> _savedQuotes = [];

  void _showNextQuote() {
    final random = Random();
    int nextIndex;

    do {
      nextIndex = random.nextInt(_quotes.length);
    } while (nextIndex == _currentIndex && _quotes.length > 1);

    setState(() {
      _historyStack.add(_currentIndex);
      _currentIndex = nextIndex;
    });
  }

  void _showPreviousQuote() {
    if (_historyStack.isNotEmpty) {
      setState(() {
        _currentIndex = _historyStack.removeLast();
      });
    }
  }

  // Toggles the favorite state of the current quote
  void _toggleFavorite() {
    final currentQuote = _quotes[_currentIndex];
    setState(() {
      if (_savedQuotes.contains(currentQuote)) {
        _savedQuotes.remove(currentQuote);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from Favorites'),
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        _savedQuotes.add(currentQuote);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saved to Favorites! ❤️'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    });
  }

  // Opens a beautiful bottom sheet panel displaying all saved items
  void _showSavedQuotesBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A0D22), // Deep matching background
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SAVED QUOTES (${_savedQuotes.length})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white60),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  _savedQuotes.isEmpty
                      ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(
                      child: Text(
                        'No saved quotes yet. Tap ❤️ to add some!',
                        style: TextStyle(color: Colors.white38, fontSize: 14),
                      ),
                    ),
                  )
                      : Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _savedQuotes.length,
                      itemBuilder: (context, index) {
                        final item = _savedQuotes[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            title: Text(
                              '"${item["text"]}"',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                '- ${item["author"]}',
                                style: TextStyle(color: Colors.amber[100], fontSize: 12),
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () {
                                // Remove item and instantly refresh the view inside the open drawer panel
                                setState(() {
                                  _savedQuotes.remove(item);
                                });
                                setModalState(() {});
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuote = _quotes[_currentIndex];
    final hasHistory = _historyStack.isNotEmpty;
    final isFavorite = _savedQuotes.contains(currentQuote);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6A1B29), // Rich Deep Burgundy
              Color(0xFF281526), // Dark Plum
              Color(0xFF11091C), // Deep Midnight Violet
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Header System Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Hidden spacing element to keep the title perfectly centered
                      const SizedBox(width: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_awesome_outlined,
                            color: Colors.amber[200]!.withOpacity(0.8),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'DAILY INSPIRATION',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 3.0,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      // Bookmark Icon Button to review your collections
                      IconButton(
                        icon: const Icon(Icons.bookmarks_outlined, color: Colors.white70, size: 24),
                        onPressed: _showSavedQuotesBottomSheet,
                      )
                    ],
                  ),
                ),

                // Core Card Frame
                Expanded(
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 36.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.format_quote_rounded,
                                size: 54,
                                color: const Color(0xFFE2B4BD).withOpacity(0.4),
                              ),
                              // Heart interactive toggle button
                              IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: isFavorite ? Colors.redAccent : Colors.white60,
                                  size: 28,
                                ),
                                onPressed: _toggleFavorite,
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentQuote["text"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 28),
                          Container(
                            width: 40,
                            height: 1.5,
                            color: Colors.amber[200]!.withOpacity(0.4),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            currentQuote["author"]!.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.0,
                              color: Colors.amber[100],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Footer Dual Action Buttons
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Opacity(
                        opacity: hasHistory ? 1.0 : 0.4,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFE2B4BD).withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: OutlinedButton(
                            onPressed: hasHistory ? _showPreviousQuote : null,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFE2B4BD),
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Icon(Icons.arrow_back_rounded, size: 22),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE2B4BD).withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: _showNextQuote,
                          icon: const Icon(Icons.navigate_next_rounded, size: 26),
                          label: const Text(
                            'NEXT QUOTE',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE2B4BD),
                            foregroundColor: const Color(0xFF281526),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}