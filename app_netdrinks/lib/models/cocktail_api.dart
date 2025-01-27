import 'package:app_netdrinks/models/cocktail.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class CocktailApi {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.thecocktaildb.com/api/json/v1',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
    ),
  );
  final Logger logger = Logger();

  Future<List<Cocktail>> getPopularCocktails() async {
    try {
      logger.d('Buscando cocktails populares...');
      final response = await _dio.get('/popular.php');
      return _parseCocktailList(response.data);
    } catch (e) {
      logger.e('Erro ao buscar cocktails populares: $e');
      rethrow;
    }
  }

  Future<List<Cocktail>> searchByName(String name) async {
    try {
      logger.d('Buscando cocktails por nome: $name');
      final response =
          await _dio.get('/search.php', queryParameters: {'s': name});
      return _parseCocktailList(response.data);
    } catch (e) {
      logger.e('Erro na busca por nome: $e');
      rethrow;
    }
  }

  Future<List<Cocktail>> filterByCategory(String category) async {
    try {
      logger.d('Filtrando por categoria: $category');
      final response =
          await _dio.get('/filter.php', queryParameters: {'c': category});
      return _parseCocktailList(response.data);
    } catch (e) {
      logger.e('Erro ao filtrar por categoria: $e');
      rethrow;
    }
  }

  Future<List<Cocktail>> filterByIngredient(String ingredient) async {
    try {
      logger.d('Filtrando por ingrediente: $ingredient');
      final response =
          await _dio.get('/filter.php', queryParameters: {'i': ingredient});
      return _parseCocktailList(response.data);
    } catch (e) {
      logger.e('Erro ao filtrar por ingrediente: $e');
      rethrow;
    }
  }

  Future<Cocktail> getRandomCocktail() async {
    try {
      logger.d('Buscando cocktail aleatório...');
      final response = await _dio.get('/random.php');
      final drinks = _parseCocktailList(response.data);
      return drinks.first;
    } catch (e) {
      logger.e('Erro ao buscar cocktail aleatório: $e');
      rethrow;
    }
  }

  List<Cocktail> _parseCocktailList(Map<String, dynamic> data) {
    final drinks = data['drinks'] as List;
    return drinks.map((drink) => Cocktail.fromJson(drink)).toList();
  }

  Future<List<String>> getCategories() async {
    try {
      logger.d('Buscando categorias...');
      final response =
          await _dio.get('/list.php', queryParameters: {'c': 'list'});
      return (response.data['drinks'] as List)
          .map((item) => item['strCategory'] as String)
          .toList();
    } catch (e) {
      logger.e('Erro ao buscar categorias: $e');
      rethrow;
    }
  }
}
