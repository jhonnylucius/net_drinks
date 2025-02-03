import 'dart:convert';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/services.dart';

class IngredientsTranslationService {
  static Map<String, Map<String, String>>? _translations;

  /// Carrega as traduções do arquivo JSON apenas se ainda não estiverem carregadas.
  static Future<void> loadTranslations({bool forceReload = false}) async {
    if (_translations != null && !forceReload) {
      print('🔄 Traduções já carregadas.');
      return;
    }
    try {
      final jsonString =
          await rootBundle.loadString('assets/data/ingredients_map.json');
      _translations =
          Map<String, Map<String, String>>.from(json.decode(jsonString));
      print('✅ Traduções carregadas: ${_translations?.length} ingredientes');
      print('Conteúdo das traduções: $_translations');
    } catch (e) {
      print('❌ Erro ao carregar traduções: $e');
      _translations = {};
    }
  }

  /// Normaliza o texto removendo diacríticos, convertendo para minúsculas e removendo espaços.
  static String normalize(String text) {
    return removeDiacritics(text.toLowerCase().trim());
  }

  /// Retorna o nome do ingrediente em inglês, dado o nome no idioma de origem.
  static String getEnglishName(String ingredient, String fromLang) {
    try {
      if (_translations == null) {
        print(
            '⚠️ As traduções não foram carregadas ainda. Execute IngredientsTranslationService.loadTranslations() antes.');
        return ingredient;
      }

      if (fromLang == 'en') return ingredient;
      if (fromLang != 'en' && fromLang != 'pt' && fromLang != 'es') {
        print(
            '⚠️ Idioma de origem inválido: $fromLang. Retornando o próprio valor.');
        return ingredient;
      }

      final normalizedIngredient = normalize(ingredient);
      print('🔍 Ingrediente digitado (normalizado): "$normalizedIngredient"');

      for (var entry in _translations!.entries) {
        final valueFromLang = entry.value[fromLang];
        print(
            '   ➡️ Analisando entrada: chave="${entry.key}", $fromLang="${valueFromLang}"');
        if (valueFromLang != null &&
            normalize(valueFromLang) == normalizedIngredient) {
          final englishTranslation = entry.value['en'];
          print('✅ Encontrado: "$ingredient" -> "$englishTranslation"');
          if (englishTranslation != null && englishTranslation.isNotEmpty) {
            return englishTranslation;
          }
          return entry.key;
        }
      }

      for (var entry in _translations!.entries) {
        if (normalize(entry.key) == normalizedIngredient) {
          final englishTranslation = entry.value['en'];
          print(
              '✅ Encontrado via chave: "${entry.key}" -> "$englishTranslation"');
          if (englishTranslation != null && englishTranslation.isNotEmpty) {
            return englishTranslation;
          }
          return entry.key;
        }
      }

      print(
          '⚠️ Não encontrou tradução para "$ingredient" em "$fromLang". Retornando o próprio valor.');
      return ingredient;
    } catch (e) {
      print('❌ Erro ao traduzir "$ingredient": $e');
      return ingredient;
    }
  }
}
