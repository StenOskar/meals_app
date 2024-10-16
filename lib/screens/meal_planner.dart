import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:meals_app/models/day.dart';
import 'package:meals_app/widgets/meal_item.dart';
import '../models/meal.dart';
import 'meal_detail.dart';

/// The screen that displays the meal planner. The meal planner allows users to
/// select a meal for each day of the week. The user can also remove a meal from
/// a day by swiping it away.
class MealPlannerScreen extends StatefulWidget {
  const MealPlannerScreen(
      {super.key,
        required this.onToggleMealPlanner,
        required this.onToggleFavorite,
        required this.mealPlan,
        required this.onRemoveMealPlanner});

  final void Function(Day? day, Meal meal) onToggleMealPlanner;
  final void Function(Meal meal) onToggleFavorite;
  final void Function(Day day) onRemoveMealPlanner;
  final HashMap<Day, Meal> mealPlan;

  @override
  MealPlannerScreenState createState() => MealPlannerScreenState();
}

class MealPlannerScreenState extends State<MealPlannerScreen> {
  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsDetailScreen(
          meal: meal,
          onToggleFavorite: widget.onToggleFavorite,
          onToggleMealPlanner: widget.onToggleMealPlanner,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    HashMap<Day, Meal> mealPlan = widget.mealPlan;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Day.values.map((day) {
                return Column(
                  children: [
                    Text(
                      day.name[0].toUpperCase() + day.name.substring(1),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    mealPlan.containsKey(day)
                        ? Dismissible(
                      // Wrap only MealItem with Dismissible
                      key: ValueKey(mealPlan[day]),
                      onDismissed: (direction) {
                        widget.onRemoveMealPlanner(day);
                      },
                      child: MealItem(
                        meal: mealPlan[day]!,
                        onSelectMeal: (meal) {
                          selectMeal(context, meal);
                        },
                      ),
                    )
                        : const Text(
                      'No meal selected',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }).toList()),
        ),
      ),
    );
  }
}
