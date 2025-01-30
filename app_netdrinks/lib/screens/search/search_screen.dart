import 'package:app_netdrinks/controller/search_controller.dart' as netdrink;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = Get.put(netdrink.SearchController());
  final searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _handleSearch() {
    _focusNode.unfocus(); // Fecha o teclado
    controller.searchByFirstLetter(searchController.text);
    final searchText = searchController.text.trim(); // Remove espaços em branco
    controller.searchByFirstLetter(searchText);
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
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Buscar por primeira letra...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _handleSearch,
                ),
              ),
            ),
          ),
          Obx(() => controller.isLoading.value
              ? CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0), // Padding na lista
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      final cocktail = controller.searchResults[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0), // Espaço entre itens
                        child: ListTile(
                          leading: Container(
                            width: 80, // Aumentar largura da imagem
                            height: 80, // Aumentar altura da imagem
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
                          onTap: () => Get.toNamed('/cocktail-detail',
                              arguments: cocktail),
                        ),
                      );
                    },
                  ),
                )),
        ],
      ),
    );
  }
}
