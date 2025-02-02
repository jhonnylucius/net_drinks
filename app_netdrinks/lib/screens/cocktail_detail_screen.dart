import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:app_netdrinks/controller/cocktail_detail_controller.dart';
import 'package:app_netdrinks/models/cocktail.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:translator/translator.dart';

class CocktailDetailScreen extends StatefulWidget {
  final Cocktail cocktail;

  const CocktailDetailScreen({super.key, required this.cocktail});

  @override
  CocktailDetailScreenState createState() => CocktailDetailScreenState();
}

class CocktailDetailScreenState extends State<CocktailDetailScreen> {
  final GlobalKey _screenShotKey = GlobalKey();
  String _selectedLanguage = 'pt';
  final translator = GoogleTranslator();
  final CocktailController controller = Get.find<CocktailController>();

  String? translatedAlternateName;
  String? translatedCategory;
  String? translatedAlcohol;
  String? translatedGlass;
  String? translatedInstructions;
  List<String>? translatedTags;
  List<Map<String, String>>? translatedIngredients;

  final TextEditingController _myVersionController = TextEditingController();

  Future<void> _shareScreen() async {
    try {
      await Future.delayed(Duration(milliseconds: 100));

      final boundary = _screenShotKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        Logger().e("RenderRepaintBoundary não encontrado");
        return;
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData?.buffer.asUint8List();

      if (bytes != null) {
        if (kIsWeb) {
          // Download direto no web
          base64Encode(bytes);
        } else {
          // Share no mobile
          final tempDir = await getTemporaryDirectory();
          final file = await File('${tempDir.path}/drink.png').create();
          await file.writeAsBytes(bytes);

          await Share.shareXFiles(
            [XFile(file.path)],
            text: 'Confira essa receita incrível de ${widget.cocktail.name}!',
          );
        }
      }
    } catch (e) {
      Logger().e('Erro ao compartilhar: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    controller.loadMyVersion(widget.cocktail.idDrink);
    _translateContent();
  }

  @override
  void dispose() {
    _myVersionController.dispose();
    super.dispose();
  }

  Future<void> _translateContent() async {
    // Remover esse bloco else que está sobrescrevendo as traduções
    if (_selectedLanguage != 'en') {
      translatedAlternateName =
          await _translateText(widget.cocktail.strDrinkAlternate);
      translatedCategory = await _translateText(widget.cocktail.category);
      translatedAlcohol = await _translateText(widget.cocktail.alcohol);
      translatedGlass = await _translateText(widget.cocktail.strGlass);
      translatedInstructions =
          await _translateText(widget.cocktail.instructions);
      translatedTags = await _translateTags(widget.cocktail.strTags);
      translatedIngredients = await _translateIngredients(
          widget.cocktail.getIngredientsWithMeasures());
    } else {
      // Se for inglês, usar valores originais
      translatedAlternateName = widget.cocktail.strDrinkAlternate;
      translatedCategory = widget.cocktail.category;
      translatedAlcohol = widget.cocktail.alcohol;
      translatedGlass = widget.cocktail.strGlass;
      translatedInstructions = widget.cocktail.instructions;
      translatedTags =
          widget.cocktail.strTags?.split(',').map((tag) => tag.trim()).toList();
      translatedIngredients = widget.cocktail.getIngredientsWithMeasures();
    }

    setState(() {});
  }

  Future<String?> _translateText(String? text) async {
    if (text == null || text.isEmpty) return text;
    if (RegExp(r'^\d+$').hasMatch(text)) return text;

    try {
      final translation =
          await translator.translate(text, to: _selectedLanguage);
      return translation.text;
    } catch (e) {
      Logger().e("Erro ao traduzir: $e");
      return text;
    }
  }

  Future<List<String>> _translateTags(String? tags) async {
    if (tags == null) return [];
    final tagList = tags.split(',').map((tag) => tag.trim()).toList();
    final translatedTagList =
        await Future.wait(tagList.map((tag) => _translateText(tag)));
    return translatedTagList.whereType<String>().toList();
  }

  Future<List<Map<String, String>>> _translateIngredients(
      List<Map<String, String>>? ingredients) async {
    if (ingredients == null) return [];
    final translatedIngredients =
        await Future.wait(ingredients.map((ingredient) async {
      final translatedIngredient =
          await _translateText(ingredient['ingredient']);
      final translatedMeasure = await _translateText(ingredient['measure']);
      return {
        'ingredient': translatedIngredient ?? ingredient['ingredient']!,
        'measure': translatedMeasure ?? ingredient['measure']!,
        'originalIngredient': ingredient['ingredient']!,
      };
    }));
    return translatedIngredients;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cocktail.name),
        backgroundColor: Colors.black.withAlpha((0.7 * 255).toInt()),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.redAccent),
            onPressed: _shareScreen,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLanguage,
                icon: Icon(Icons.language,
                    color: const Color.fromARGB(255, 185, 3, 3)),
                dropdownColor: Colors.black,
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child:
                        Text('English', style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: 'pt',
                    child: Text('Português',
                        style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: 'es',
                    child:
                        Text('Español', style: TextStyle(color: Colors.white)),
                  ),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedLanguage = newValue;
                      _translateContent();
                    });
                  }
                },
                hint: Text('Idioma', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: RepaintBoundary(
          key: _screenShotKey,
          child: _buildFullContent(),
        ),
      ),
    );
  }

  Widget _buildFullContent() {
    if (translatedInstructions == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.cocktail.imageUrl,
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            widget.cocktail.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 8.0),
          if (translatedAlternateName != null)
            Text(
              '${FlutterI18n.translate(context, "alternative_name")}: $translatedAlternateName',
              style: TextStyle(color: Colors.white),
            ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Icon(Icons.category, color: Colors.redAccent),
              SizedBox(width: 8.0),
              Text(
                '${FlutterI18n.translate(context, "category")}: $translatedCategory',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Icon(Icons.local_bar, color: Colors.redAccent),
              SizedBox(width: 8.0),
              Text(
                '${FlutterI18n.translate(context, "type")}: $translatedAlcohol',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Icon(Icons.wine_bar, color: Colors.redAccent),
              SizedBox(width: 8.0),
              Text(
                '${FlutterI18n.translate(context, "glass")}: $translatedGlass',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          if (translatedTags != null)
            Wrap(
              spacing: 8.0,
              children: translatedTags!.map((tag) {
                return Chip(
                  label: Text(tag),
                  backgroundColor: Colors.redAccent,
                  labelStyle: TextStyle(color: Colors.white),
                );
              }).toList(),
            ),
          SizedBox(height: 8.0),
          Text(
            '${FlutterI18n.translate(context, "ingredients")}:',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 8.0),
          if (translatedIngredients != null)
            ...translatedIngredients!
                .where((ingredient) =>
                    ingredient['ingredient'] != null &&
                    ingredient['ingredient']!.isNotEmpty)
                .map((ingredient) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Icon(Icons.check, color: Colors.redAccent),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        '${ingredient['ingredient']} - ${ingredient['measure'] ?? 'To taste'}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    if (ingredient['originalIngredient'] != null)
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Image.network(
                          widget.cocktail.getIngredientImageUrl(
                              ingredient['originalIngredient']!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, color: Colors.red);
                          },
                        ),
                      ),
                  ],
                ),
              );
            }),
          SizedBox(height: 16.0),
          Row(
            children: [
              Text(
                '${FlutterI18n.translate(context, "instructions")}:',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(width: 8.0),
              Text(
                '1 oz ou onça = 29,5735 ml(U) ou 28,4131 ml(UK)',
                style: TextStyle(color: Colors.white, fontSize: 10.0),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            translatedInstructions ?? '',
            style: TextStyle(color: Colors.white),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Minha Versão',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Obx(() {
                final myVersion = controller.myVersion.value;
                if (myVersion != null) {
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          myVersion.text,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () =>
                            controller.deleteMyVersion(widget.cocktail.idDrink),
                      ),
                    ],
                  );
                } else {
                  return TextField(
                    controller: _myVersionController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Adicione sua versão da receita...',
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.save, color: Colors.redAccent),
                        onPressed: () {
                          if (_myVersionController.text.isNotEmpty) {
                            controller.saveMyVersion(
                              widget.cocktail.idDrink,
                              _myVersionController.text,
                            );
                          }
                        },
                      ),
                    ),
                    maxLines: 3,
                  );
                }
              }),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  controller.isFavorite(widget.cocktail.idDrink)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.redAccent,
                ),
                onPressed: () async {
                  await controller.toggleFavorite(widget.cocktail.idDrink);
                  setState(() {});
                },
              ),
              Text(
                controller.isFavorite(widget.cocktail.idDrink)
                    ? 'Favorito'
                    : 'Adicionar aos Favoritos',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
