import 'dart:convert';

import 'package:diacritic/diacritic.dart'; // Adicione esta dependência no pubspec.yaml
import 'package:flutter/services.dart';

class IngredientsTranslationService {
  static Map<String, Map<String, String>>? _translations;

  static Future<void> loadTranslations() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/ingredients_map.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      _translations = jsonMap.map((key, value) {
        final Map<String, dynamic> innerMap = value as Map<String, dynamic>;
        return MapEntry(key, innerMap.map((k, v) => MapEntry(k, v.toString())));
      });

      print('✅ Traduções carregadas: ${_translations?.length} ingredientes');
      // Debug
      _translations?.forEach((key, value) {
        print('Chave: $key');
        print('Valores: $value');
      });
    } catch (e) {
      print('❌ Erro ao carregar JSON: $e');
      _translations = {};
    }
  }

  static String normalize(String text) {
    return removeDiacritics(text.toLowerCase().trim());
  }

  static String getEnglishName(String ingredient, String fromLang) {
    try {
      if (_translations == null || _translations!.isEmpty) {
        print('❌ JSON não carregado ou vazio');
        return ingredient;
      }

      if (fromLang == 'en') return ingredient;

      final normalizedInput = normalize(ingredient);
      print('🔍 Buscando: "$normalizedInput" (original: "$ingredient")');

      for (var entry in _translations!.entries) {
        final fromLangValue = entry.value[fromLang];
        if (fromLangValue != null &&
            normalize(fromLangValue) == normalizedInput) {
          final result = entry.value['en'] ?? entry.key;
          print('✅ Tradução: $ingredient -> $result');
          return result;
        }
      }

      print('⚠️ Não encontrado: $ingredient');
      return ingredient;
    } catch (e) {
      print('❌ Erro: $e');
      return ingredient;
    }
  }
}
