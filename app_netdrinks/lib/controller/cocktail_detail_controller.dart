import 'package:app_netdrinks/models/cocktail.dart';
import 'package:app_netdrinks/repository/cocktail_repository.dart';
import 'package:get/get.dart';

class CocktailController extends GetxController {
  final CocktailRepository _repository;

  final _loading = false.obs;
  final _error = false.obs;
  final _cocktails = <Cocktail>[].obs;
  final _searchTerm = ''.obs;

  CocktailController(this._repository);

  bool get loading => _loading.value;
  bool get error => _error.value;
  List<Cocktail> get cocktails => _cocktails.toList();
  String get searchTerm => _searchTerm.value;

  @override
  void onInit() {
    super.onInit();
    fetchCocktails();
  }

  Future<void> fetchCocktails() async {
    _loading.value = true;
    _error.value = false;

    try {
      final result = await _repository.getPopularCocktails();
      _cocktails.assignAll(result);
    } catch (e) {
      _error.value = true;
    } finally {
      _loading.value = false;
    }
  }

  Future<void> searchCocktails(String term) async {
    if (term.isEmpty) {
      await fetchCocktails();
      return;
    }

    _loading.value = true;
    _error.value = false;
    _searchTerm.value = term;

    try {
      final result = await _repository.searchByName(term);
      _cocktails.assignAll(result);
    } catch (e) {
      _error.value = true;
    } finally {
      _loading.value = false;
    }
  }

  Future<void> filterByCategory(String category) async {
    _loading.value = true;
    _error.value = false;

    try {
      final result = await _repository.filterByCategory(category);
      _cocktails.assignAll(result);
    } catch (e) {
      _error.value = true;
    } finally {
      _loading.value = false;
    }
  }

  Future<void> filterByIngredient(String ingredient) async {
    _loading.value = true;
    _error.value = false;

    try {
      final result = await _repository.filterByIngredient(ingredient);
      _cocktails.assignAll(result);
    } catch (e) {
      _error.value = true;
    } finally {
      _loading.value = false;
    }
  }

  Future<void> getRandomCocktail() async {
    _loading.value = true;
    _error.value = false;

    try {
      final result = await _repository.getRandomCocktail();
      _cocktails.assignAll([result]);
    } catch (e) {
      _error.value = true;
    } finally {
      _loading.value = false;
    }
  }

  void clearSearch() {
    _searchTerm.value = '';
    fetchCocktails();
  }
}
