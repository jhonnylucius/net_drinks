import 'package:app_netdrinks/models/cocktail.dart';
import 'package:app_netdrinks/services/search_service.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final SearchService _searchService = SearchService();
  final RxBool isLoading = false.obs;
  final RxList<Cocktail> searchResults = <Cocktail>[].obs;
  var popularResults = <Cocktail>[].obs;
  var maisRecentesResults = <Cocktail>[].obs;

  Future<void> searchByFirstLetter(String letter) async {
    try {
      isLoading.value = true;
      searchResults.value = await _searchService.searchByFirstLetter(letter);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchPopular() async {
    try {
      isLoading.value = true;
      searchResults.value = await _searchService.searchPopular('someArgument');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchMaisRecentes() async {
    try {
      isLoading.value = true;
      searchResults.value =
          await _searchService.searchMaisRecentes('someArgument');
    } finally {
      isLoading.value = false;
    }
  }
}
