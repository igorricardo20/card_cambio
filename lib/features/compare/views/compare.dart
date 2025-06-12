import 'package:flutter/material.dart';
import 'package:card_cambio/features/home/widgets/mainchart.dart';
import 'package:card_cambio/features/home/model/rate.dart';
import 'package:card_cambio/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:card_cambio/providers/rate_provider.dart';

class Compare extends StatefulWidget {
  const Compare({super.key});

  @override
  State<Compare> createState() => _CompareState();
}

class _CompareState extends State<Compare> {
  late Map<String, List<Rate>> _selectedRates;
  late List<String> _allBanks;
  late List<String> _availableBanks;

  @override
  void initState() {
    super.initState();
    final allRates = Provider.of<RateProvider>(context, listen: false).rates;
    _allBanks = allRates.keys.toList();
    _selectedRates = {};
    // Start with Nubank as default
    if (_allBanks.contains('nubank')) _selectedRates['nubank'] = allRates['nubank']!;
    // if (_allBanks.contains('itau')) _selectedRates['itau'] = allRates['itau']!;
    _updateAvailableBanks();
  }

  void _updateAvailableBanks() {
    final allRates = Provider.of<RateProvider>(context, listen: false).rates;
    setState(() {
      _availableBanks = _allBanks.where((b) => !_selectedRates.containsKey(b)).toList();
    });
  }

  void _addBank(String bank) {
    final allRates = Provider.of<RateProvider>(context, listen: false).rates;
    setState(() {
      _selectedRates[bank] = allRates[bank]!;
      _updateAvailableBanks();
    });
  }

  void _removeBank(String bank) {
    setState(() {
      _selectedRates.remove(bank);
      _updateAvailableBanks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      AppLocalizations.of(context)?.compare_title ?? 'Compare Banks',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 18),
                    // Move chart above the bank selection
                    SizedBox(
                      height: 406,
                      child: MainChart(
                        rates: _selectedRates,
                        chartHeight: 320,
                        showLegend: true,
                        showCompareButton: false,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        AppLocalizations.of(context)?.compare_add_bank_instruction ?? 'Select banks below to compare their rates:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 0,
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: _selectedRates.keys.map((bank) {
                                  return Chip(
                                    label: Text(_bankLabel(bank)),
                                    backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                                    deleteIcon: const Icon(Icons.close, size: 18),
                                    onDeleted: _selectedRates.length > 1 ? () => _removeBank(bank) : null,
                                  );
                                }).toList(),
                              ),
                            ),
                            if (_availableBanks.isNotEmpty)
                              PopupMenuButton<String>(
                                icon: Icon(
                                  Icons.add,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                itemBuilder: (context) => _availableBanks
                                    .map((bank) => PopupMenuItem(
                                          value: bank,
                                          child: Text(_bankLabel(bank)),
                                        ))
                                    .toList(),
                                onSelected: _addBank,
                                tooltip: AppLocalizations.of(context)?.add_bank ?? 'Add bank',
                              ),
                          ],
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

  String _bankLabel(String bank) {
    switch (bank) {
      case 'nubank':
        return 'Nubank';
      case 'itau':
        return 'Itaú';
      case 'c6':
        return 'C6 Bank';
      case 'bb':
        return 'Banco do Brasil';
      case 'caixa':
        return 'Caixa';
      case 'safra':
        return 'Safra';
      default:
        return bank;
    }
  }
}
