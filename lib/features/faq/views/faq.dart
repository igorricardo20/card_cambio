import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:card_cambio/l10n/app_localizations.dart';

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  // Track which groups are expanded
  final Set<String> _expandedGroups = {};

  final List<_FaqGroup> _faqGroups = [
    _FaqGroup(
      title: 'General',
      items: [
        _FaqItem(
          question: 'What is the IOF tax for international credit card purchases?',
          answer: 'The IOF (Imposto sobre Operações Financeiras) for international credit card purchases is currently 4.38%.',
        ),
        _FaqItem(
          question: 'How is the exchange rate determined for my purchase?',
          answer: 'The exchange rate is usually determined at the time the transaction is posted, not when it is authorized. Each bank may use a different rate source and add a spread.',
        ),
        _FaqItem(
          question: 'Are there any additional fees besides IOF and spread?',
          answer: 'Some banks may charge extra administrative or service fees. Always check with your bank for a detailed breakdown.',
        ),
      ],
    ),
    _FaqGroup(
      title: 'Practical Usage',
      items: [
        _FaqItem(
          question: 'Can I pay my international credit card bill in installments?',
          answer: 'Yes, but interest rates may apply. Check with your bank for installment options and rates.',
        ),
        _FaqItem(
          question: 'What should I do if my card is declined abroad?',
          answer: 'Contact your bank immediately. It may be due to security blocks or spending limits. Always inform your bank before traveling.',
        ),
        _FaqItem(
          question: 'Will I be notified of the exchange rate used?',
          answer: 'Most banks notify you of the rate used when the transaction is posted. Some apps show a preview, but the final rate may differ.',
        ),
      ],
    ),
    _FaqGroup(
      title: 'Tips & Recommendations',
      items: [
        _FaqItem(
          question: 'How can I minimize fees on international purchases?',
          answer: 'Compare banks, use cards with lower spreads, and avoid dynamic currency conversion (DCC) at merchants.',
        ),
        _FaqItem(
          question: 'Is it better to use credit, debit, or prepaid cards abroad?',
          answer: 'Each has pros and cons. Credit cards offer more protection, but may have higher spreads. Prepaid cards can help control spending.',
        ),
        _FaqItem(
          question: 'What is dynamic currency conversion (DCC)?',
          answer: 'DCC is when a merchant offers to charge you in your home currency. This usually results in a worse exchange rate and extra fees. Always pay in local currency.',
        ),
      ],
    ),
    _FaqGroup(
      title: 'About the App',
      items: [
        _FaqItem(
          question: 'What does this app do?',
          answer: 'This is a modern app that helps you compare international credit card exchange rates, spreads, and IOF for major Brazilian banks. It provides up-to-date rate charts, simulations, and insights to help you save on international purchases.',
        ),
        _FaqItem(
          question: 'How does it get the exchange rates?',
          answer: 'The app fetches rates directly from official bank APIs and public sources. PTAX rates are retrieved for reference, and missing days are filled using the previous day’s rate for accuracy.',
        ),
        _FaqItem(
          question: 'Can I simulate a purchase with the latest rates?',
          answer: 'Yes! Use the Simulate feature to enter a value and instantly see how much you would pay at each bank, including IOF and the most recent rates.',
        ),
        _FaqItem(
          question: 'How often are the rates updated?',
          answer: 'Rates are updated daily, and the app always uses the most recent available rate for each bank. PTAX is fetched for the previous day to ensure accuracy.',
        ),
        _FaqItem(
          question: 'Is my data safe? Does the app store any personal information?',
          answer: 'This app does not collect or store any personal or financial information. All calculations and simulations are performed locally on your device.',
        ),
        _FaqItem(
          question: 'Can I use the app offline?',
          answer: 'You need an internet connection to fetch the latest rates, but you can view previously loaded data offline. For the most accurate results, connect to the internet regularly.',
        ),
        _FaqItem(
          question: 'How can I suggest a new feature or report a bug?',
          answer: 'Use the Contact Support option in the Services menu to send feedback, suggest features, or report issues. Your input helps improve the app!',
        ),
        _FaqItem(
          question: 'Does the app support multiple languages?',
          answer: 'Yes! The app is localized in English, Portuguese, Spanish, and Dutch. You can change your device language to use the app in your preferred language.',
        ),
        _FaqItem(
          question: 'What platforms are supported?',
          answer: 'The app is available for Android, iOS, and web. The experience is harmonized and modern across all platforms.',
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredGroups = _faqGroups.map((group) {
      final filteredItems = group.items.where((item) {
        final q = item.question.toLowerCase();
        final a = item.answer.toLowerCase();
        final s = _searchQuery.toLowerCase();
        return q.contains(s) || a.contains(s);
      }).toList();
      return _FaqGroup(title: group.title, items: filteredItems);
    }).where((g) => g.items.isNotEmpty).toList();

    // Always expand all groups with search results when searching
    if (_searchQuery.isNotEmpty) {
      final titlesToExpand = Set<String>.from(filteredGroups.map((g) => g.title));
      if (!_expandedGroups.containsAll(titlesToExpand) || _expandedGroups.length != titlesToExpand.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _expandedGroups
                ..clear()
                ..addAll(titlesToExpand);
            });
          }
        });
      }
    } else if (_searchFocusNode.hasFocus) {
      if (_expandedGroups.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _expandedGroups.clear();
            });
          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.faq_help_title ?? 'FAQ / Help',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 18),
                    _buildSearchBox(context),
                    const SizedBox(height: 24),
                    ...filteredGroups.map((group) => _buildGroup(context, group)).toList(),
                    if (filteredGroups.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: Text(
                            'No results found.',
                            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
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

  Widget _buildSearchBox(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CupertinoSearchTextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      placeholder: 'Search FAQ...',
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[200],
      itemColor: isDark ? Colors.white70 : Colors.black54,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
        fontSize: 16,
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
          // Expansion logic is now handled in build()
        });
      },
      onTap: () {
        setState(() {
          // Expansion logic is now handled in build()
        });
      },
    );
  }

  Widget _buildGroup(BuildContext context, _FaqGroup group) {
    final theme = Theme.of(context);
    final isExpanded = _expandedGroups.contains(group.title);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Card(
        elevation: 0,
        color: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Theme(
            data: theme.copyWith(dividerColor: Colors.transparent),
            child: ExpansionTileTheme(
              data: ExpansionTileThemeData(
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: Colors.transparent,
                iconColor: theme.colorScheme.primary,
                collapsedIconColor: Colors.grey,
                textColor: theme.textTheme.titleMedium?.color,
                collapsedTextColor: theme.textTheme.bodyMedium?.color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                childrenPadding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              ),
              child: ExpansionTile(
                key: PageStorageKey(group.title),
                initiallyExpanded: isExpanded,
                onExpansionChanged: (expanded) {
                  setState(() {
                    if (expanded) {
                      _expandedGroups.add(group.title);
                    } else {
                      _expandedGroups.remove(group.title);
                    }
                  });
                },
                title: Text(
                  group.title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                children: group.items.map((item) => _buildFaqItem(context, item)).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, _FaqItem item) {
    final theme = Theme.of(context);
    final s = _searchQuery.trim();
    Widget highlight(String text) {
      if (s.isEmpty) return Text(text, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600));
      final lower = text.toLowerCase();
      final lowerS = s.toLowerCase();
      final spans = <TextSpan>[];
      int start = 0;
      while (true) {
        final index = lower.indexOf(lowerS, start);
        if (index < 0) {
          spans.add(TextSpan(text: text.substring(start)));
          break;
        }
        if (index > start) {
          spans.add(TextSpan(text: text.substring(start, index)));
        }
        spans.add(TextSpan(
          text: text.substring(index, index + s.length),
          style: TextStyle(
            backgroundColor: theme.colorScheme.primary.withOpacity(0.18),
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ));
        start = index + s.length;
      }
      return RichText(text: TextSpan(style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600), children: spans));
    }
    Widget highlightAnswer(String text) {
      if (s.isEmpty) return Text(text, style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.92)));
      final lower = text.toLowerCase();
      final lowerS = s.toLowerCase();
      final spans = <TextSpan>[];
      int start = 0;
      while (true) {
        final index = lower.indexOf(lowerS, start);
        if (index < 0) {
          spans.add(TextSpan(text: text.substring(start)));
          break;
        }
        if (index > start) {
          spans.add(TextSpan(text: text.substring(start, index)));
        }
        spans.add(TextSpan(
          text: text.substring(index, index + s.length),
          style: TextStyle(
            backgroundColor: theme.colorScheme.primary.withOpacity(0.18),
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ));
        start = index + s.length;
      }
      return RichText(text: TextSpan(style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.92)), children: spans));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[100],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(CupertinoIcons.question_circle, size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: highlight(item.question),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(left: 26),
                  child: highlightAnswer(item.answer),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FaqGroup {
  final String title;
  final List<_FaqItem> items;
  const _FaqGroup({required this.title, required this.items});
}

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});
}
