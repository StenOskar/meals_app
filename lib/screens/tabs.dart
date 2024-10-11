import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meal_planner.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';
import '../models/meal.dart';
import '../models/day.dart';

/// Sets the initial filters for the app.
const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false
};

/// The screen that displays the tabs for the app. The user can navigate to
/// different screens by tapping on the tabs. The user can also access the
/// filters screen by tapping on the filter icon in the left hand menu.
class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoritesMeals = [];
  final HashMap<Day, Meal> mealPlan = HashMap();
  Map<Filter, bool> _selectedFilters = kInitialFilters;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleMealFavoritesStatus(Meal meal) {
    final isExisting = _favoritesMeals.contains(meal);

    if (isExisting) {
      setState(() {
        _favoritesMeals.remove(meal);
      });
      _showInfoMessage("Meal is no longer a favorite");
      _favoritesMeals.remove(meal);
    } else {
      _favoritesMeals.add(meal);
      _showInfoMessage("Marked as a favorite");
    }
  }

  void _addMealPlannerStatus(Day? day, Meal meal) {
    final isExisting = mealPlan.containsKey(day);

    if (day == null) {
      _showInfoMessage("Please select a day");
    } else if (isExisting) {
      _showInfoMessage("There is already a meal added for ${day.name}");
    } else {
      setState(() {
        mealPlan[day] = meal;
      });
      _showInfoMessage("Meal was added to the meal planner");
    }
  }

  void _removeMealPlannerStatus(Day day) {
    final isExisting = mealPlan.containsKey(day);

    if (!isExisting) {
      _showInfoMessage("There is no meal added for ${day.name}");
    } else {
      setState(() {
        mealPlan.remove(day);
      });
      _showInfoMessage("Meal was removed from the meal planner");
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == "filters") {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
            builder: (ctx) => FilterScreen(currentFilters: _selectedFilters)
        ),
      );
      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoritesStatus,
      onToggleMealPlanner: _addMealPlannerStatus,
      availableMeals: availableMeals,
    );
    var activePageTitle = "Categories";

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoritesMeals,
        onToggleFavorite: _toggleMealFavoritesStatus,
        onToggleMealPlanner: _addMealPlannerStatus,
      );
      activePageTitle = "Your Favorites";
    }

    if (_selectedPageIndex == 2) {
      activePage = MealPlannerScreen(
        mealPlan: mealPlan,
        onToggleFavorite: _toggleMealFavoritesStatus,
        onToggleMealPlanner: _addMealPlannerStatus,
        onRemoveMealPlanner: _removeMealPlannerStatus,
      );
      activePageTitle = "Meal Planner";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: "Categories"),
          BottomNavigationBarItem(
              icon: Icon(Icons.star), label: "Favorites"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_view_week), label: "Meal planner"),
        ],
      ),
    );
  }
}
