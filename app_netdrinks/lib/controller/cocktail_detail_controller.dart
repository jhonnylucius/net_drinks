import 'package:app_netdrinks/models/cocktail.dart';
import 'package:app_netdrinks/repository/cocktail_repository.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CocktailController extends GetxController {
  final CocktailRepository repository;
  final _loading = false.obs;
  final _cocktails = <Cocktail>[].obs;
  final _favorites = <String>[].obs;

  CocktailController(this.repository);

  bool get loading => _loading.value;
  List<Cocktail> get cocktails => _cocktails;
  List<String> get favorites => _favorites;

  @override
  void onInit() {
    super.onInit();
    fetchPopularCocktails();
    loadFavorites();
  }

  Future<void> fetchPopularCocktails() async {
    try {
      _loading.value = true;
      final result = await repository.getPopularCocktails();
      _cocktails.assignAll(result);
      Logger().e('Cocktails fetched: ${_cocktails.length}');
    } catch (e) {
      Logger().e('Error fetching cocktails: $e');
    } finally {
      _loading.value = false;
    }
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favoriteCocktails') ?? [];
    _favorites.assignAll(favoriteIds);
  }

  Future<void> toggleFavorite(String cocktailId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favoriteIds = [..._favorites];

    if (favoriteIds.contains(cocktailId)) {
      favoriteIds.remove(cocktailId);
    } else {
      favoriteIds.add(cocktailId);
    }

    await prefs.setStringList('favoriteCocktails', favoriteIds);
    _favorites.assignAll(favoriteIds);
  }

  bool isFavorite(String cocktailId) {
    return _favorites.contains(cocktailId);
  }

  List<Cocktail> getFavoriteCocktails() {
    return _cocktails.where((c) => _favorites.contains(c.idDrink)).toList();
  }
}
