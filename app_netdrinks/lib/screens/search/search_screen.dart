import 'package:app_netdrinks/controller/search_controller.dart' as netdrink;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  final controller = Get.put(netdrink.SearchController());
  final searchController = TextEditingController();

  SearchScreen({super.key});

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
              decoration: InputDecoration(
                hintText: 'Buscar por primeira letra...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () =>
                      controller.searchByFirstLetter(searchController.text),
                ),
              ),
            ),
          ),
          Obx(() => controller.isLoading.value
              ? CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemCount: controller.searchResults.length,
                    itemBuilder: (context, index) {
                      final cocktail = controller.searchResults[index];
                      return ListTile(
                        leading: Image.network(cocktail.imageUrl),
                        title: Text(cocktail.name),
                        onTap: () => Get.toNamed('/cocktail-detail',
                            arguments: cocktail),
                      );
                    },
                  ),
                )),
        ],
      ),
    );
  }
}
