import 'package:app_netdrinks/models/cocktail.dart';
import 'package:app_netdrinks/repository/cocktail_repository.dart';
import 'package:get/get.dart';

class CocktailController extends GetxController {
  final CocktailRepository repository;
  final _loading = false.obs;
  final _cocktails = <Cocktail>[].obs;

  CocktailController(this.repository);

  bool get loading => _loading.value;
  List<Cocktail> get cocktails => _cocktails;

  @override
  void onInit() {
    super.onInit();
    fetchPopularCocktails();
  }

  Future<void> fetchPopularCocktails() async {
    try {
      _loading.value = true;
      final result = await repository.getPopularCocktails();
      _cocktails.assignAll(result);
    } finally {
      _loading.value = false;
    }
  }
}
