// lib/screens/results_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models.dart';

class ResultsScreen extends StatelessWidget {
  static const routeName = '/results';

  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args is! GenerateResult) {
      return Scaffold(
        appBar: AppBar(title: const Text('Results')),
        body: const Center(child: Text('No results found.')),
      );
    }

    final result = args;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Trip Plan')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Budgets comparison
            Text(
              'Budgets Overview (₹)',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
            ),
            const SizedBox(height: 12),
            _BudgetComparison(
              low: result.lowBudget,
              mid: result.midRange,
              lux: result.luxury,
            ),
            const SizedBox(height: 24),

            // Itinerary
            Text(
              'Itinerary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
            ),
            const SizedBox(height: 12),
            ...result.itinerary.map((d) => _DayCard(day: d)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _BudgetComparison extends StatelessWidget {
  final BudgetPlan low;
  final BudgetPlan mid;
  final BudgetPlan lux;

  const _BudgetComparison({
    required this.low,
    required this.mid,
    required this.lux,
  });

  Widget _budgetTile(String label, double value, ColorScheme scheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: scheme.onSurface)),
        Text('₹${value.toStringAsFixed(0)}',
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w600,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget card(String title, BudgetPlan b, Color color) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _budgetTile('Flights/Bus/Train', b.flights + b.localTransport, scheme),
            const SizedBox(height: 6),
            _budgetTile('Lodging', b.lodging, scheme),
            const SizedBox(height: 6),
            _budgetTile('Activities', b.activities, scheme),
            const SizedBox(height: 6),
            _budgetTile('Food', b.food, scheme),
            const Divider(height: 20),
            _budgetTile('Buffer (10%)', b.buffer, scheme),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total: ₹${b.total.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: scheme.primary,
                      ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 640) {
          return Column(
            children: [
              card('Low Budget', low, Colors.teal),
              const SizedBox(height: 12),
              card('Mid Budget', mid, Colors.orange),
              const SizedBox(height: 12),
              card('Luxury', lux, Colors.amber),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: card('Low Budget', low, Colors.teal)),
            const SizedBox(width: 12),
            Expanded(child: card('Mid Budget', mid, Colors.orange)),
            const SizedBox(width: 12),
            Expanded(child: card('Luxury', lux, Colors.amber)),
          ],
        );
      },
    );
  }
}

class _DayCard extends StatelessWidget {
  final ItineraryDay day;

  const _DayCard({required this.day});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final df = DateFormat('EEE, MMM d');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.primary.withOpacity(0.15)),
      ),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(
          '${df.format(day.date)} • ${day.area}',
          style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w700),
        ),
        children: day.items
            .map(
              (it) => ListTile(
                title: Text(it.poi.name),
                subtitle: Text(
                  '${DateFormat.Hm().format(it.start)} - ${DateFormat.Hm().format(it.end)} • ${it.transport} • ${it.poi.category}',
                ),
                trailing: Text(
                  it.costEstimate == 0 ? 'Free' : '₹${it.costEstimate.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: it.costEstimate == 0 ? scheme.onSurface : scheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
