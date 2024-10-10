import '../models/meal.dart';

enum Day {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class MealPlan {
  const MealPlan({
    required this.meal,
    required this.day,
  });

  final String meal;
  final String day;
}