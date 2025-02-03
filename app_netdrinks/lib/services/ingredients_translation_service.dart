import 'dart:convert';
import 'dart:io';

class IngredientsTranslationService {
  static Map<String, Map<String, String>>? _translations;

  static Future<void> loadTranslations() async {
    if (_translations == null) {
      final file = File('lib/data/ingredients_map.json');
      final jsonString = await file.readAsString();
      _translations =
          Map<String, Map<String, String>>.from(json.decode(jsonString));
    }
  }

  static String? getEnglishName(String ingredient, String fromLang) {
    // Procurar ingrediente em todas as traduções
    return _translations?.entries
        .firstWhere(
          (entry) =>
              entry.value[fromLang]?.toLowerCase() == ingredient.toLowerCase(),
          orElse: () => MapEntry(ingredient, {'en': ingredient}),
        )
        .key;
  }
}
