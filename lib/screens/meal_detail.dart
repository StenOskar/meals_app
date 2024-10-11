import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';

import '../models/day.dart';

/// The screen that displays the details of a meal. The user can favorite the
/// meal or add it to the meal planner.
class MealsDetailScreen extends StatefulWidget {
  const MealsDetailScreen({
    super.key,
    required this.meal,
    required this.onToggleFavorite,
    required this.onToggleMealPlanner,
  });

  /// The meal to display.
  final Meal meal;
  final void Function(Meal meal) onToggleFavorite;
  final void Function(Day? day, Meal meal) onToggleMealPlanner;

  @override
  State<MealsDetailScreen> createState() => _MealsDetailScreenState();
}

class _MealsDetailScreenState extends State<MealsDetailScreen> {
  Day? selectedDay; // Initialize as nullable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal.title),
        actions: [
          IconButton(
            onPressed: () {
              widget.onToggleFavorite(widget.meal);
            },
            icon: const Icon(Icons.star),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              widget.meal.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 14),
            Text(
              "Ingredients",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            for (final ingredients in widget.meal.ingredients)
              Text(
                ingredients,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            const SizedBox(height: 24),
            Text(
              "Steps",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            for (final step in widget.meal.steps)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(
                  step,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<Day>(
                  value: selectedDay,
                  hint: const Text("Select a day"),
                  items: Day.values.map((day) {
                    return DropdownMenuItem(
                      value: day,
                      child: Text(day.name, style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),),
                    );
                  }).toList(),
                  onChanged: (day) {
                    setState(() {
                      selectedDay = day;
                    });
                  },
                ),
                IconButton(
                  onPressed: () {
                    widget.onToggleMealPlanner(selectedDay, widget.meal);
                  },
                  icon: const Icon(
                    Icons.add,
                    semanticLabel: "Create meal plan",
                  ),
                  iconSize: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            )
          ],
        ),
      ),
    );
  }
}