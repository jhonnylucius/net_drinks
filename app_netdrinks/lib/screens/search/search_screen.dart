import 'package:app_netdrinks/controller/search_controller.dart' as netdrink;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = Get.put(netdrink.SearchController());
  final searchController = TextEditingController();
  final multiIngredientsController = TextEditingController();
  final FocusNode _focusNodeFirstLetter = FocusNode();
  final FocusNode _focusNodeMultiIngredients = FocusNode();

  @override
  void dispose() {
    _focusNodeFirstLetter.dispose();
    _focusNodeMultiIngredients.dispose();
    searchController.dispose();
    multiIngredientsController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    _focusNodeFirstLetter.unfocus(); // Fecha o teclado
    final searchText = searchController.text.trim(); // Remove espaços em branco
    controller.searchByFirstLetter(searchText);
  }

  void _handleMultiIngredientsSearch() {
    _focusNodeMultiIngredients.unfocus(); // Fecha o teclado
    final searchText = multiIngredientsController.text.trim();
    controller.searchMultiIngredients(searchText);
  }

  void _handlePopularSearch() {
    _focusNodeFirstLetter.unfocus();
    _focusNodeMultiIngredients.unfocus();
    controller.searchPopular();
  }

  void _handleMaisRecentesSearch() {
    _focusNodeFirstLetter.unfocus();
    _focusNodeMultiIngredients.unfocus();
    controller.searchMaisRecentes();
  }

  void _handleDezAleatorio() {
    _focusNodeFirstLetter.unfocus();
    _focusNodeMultiIngredients.unfocus();
    controller.searchDezAleatorio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesquisar Drinks'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Get.toNamed('/home'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              focusNode: _focusNodeFirstLetter,
              decoration: InputDecoration(
                hintText: 'Buscar por primeira letra...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _handleSearch,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: multiIngredientsController,
              focusNode: _focusNodeMultiIngredients,
              decoration: InputDecoration(
                hintText: 'Buscar por vários ingredientes...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _handleMultiIngredientsSearch,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _handlePopularSearch,
            child: Text('Pesquisar Drinks Populares'),
          ),
          ElevatedButton(
            onPressed: _handleMaisRecentesSearch,
            child: Text('Pesquisar os Drinks mais recentes'),
          ),
          ElevatedButton(
            onPressed: _handleDezAleatorio,
            child: Text('Pesquisar 10 Drinks Aleatórios'),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              final allResults = [
                ...controller.searchResults,
                ...controller.popularResults,
                ...controller.maisRecentesResults,
                ...controller.dezAleatorioResults,
                ...controller.multiIngredientsResults
              ];

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: allResults.length,
                itemBuilder: (context, index) {
                  final cocktail = allResults[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Container(
                        width: 80,
                        height: 80,
                        child: Image.network(
                          cocktail.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        cocktail.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        if (cocktail.ingredients.isNotEmpty &&
                            cocktail.instructions.isNotEmpty) {
                          // Se já tem detalhes completos, navega direto
                          Get.toNamed('/cocktail-detail', arguments: cocktail);
                        } else {
                          // Caso contrário, busca detalhes antes de navegar
                          print(
                              "Buscando detalhes para ID: ${cocktail.idDrink}");
                          await controller.fetchCocktailDetailsAndNavigate(
                              cocktail.idDrink);
                        }
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
