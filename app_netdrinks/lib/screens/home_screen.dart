import 'package:app_netdrinks/components/menu.dart';
import 'package:app_netdrinks/controller/cocktail_detail_controller.dart';
import 'package:app_netdrinks/models/cocktail.dart';
import 'package:app_netdrinks/widgets/cocktail_card_widget.dart';
import 'package:app_netdrinks/widgets/progress_indicador2_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final controller = Get.find<CocktailController>();
  final PageController pageController = PageController(viewportFraction: 0.7);
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    int page = pageController.page?.round() ?? 0;
    _currentPage.value = page;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(user: widget.user),
      appBar: AppBar(
        title: Text('NetDrinks'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.loading) {
          return ProgressIndicador2Widget();
        }

        if (controller.cocktails.isEmpty) {
          return Center(child: Text('Nenhum drink encontrado'));
        }

        return Stack(
          children: [
            // Background com imagem do drink atual
            ValueListenableBuilder<int>(
              valueListenable: _currentPage,
              builder: (context, currentIndex, _) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: Image.network(
                    controller.cocktails[currentIndex].imageUrl,
                    key: ValueKey(currentIndex),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
            // Gradiente sobre a imagem
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                    Colors.black,
                  ],
                ),
              ),
            ),
            // Carrossel na parte inferior
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Nome do drink atual
                  ValueListenableBuilder<int>(
                    valueListenable: _currentPage,
                    builder: (context, currentIndex, _) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          controller.cocktails[currentIndex].name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Carrossel de drinks
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: controller.cocktails.length,
                      itemBuilder: (context, index) {
                        return AnimatedScale(
                          scale: _currentPage.value == index ? 1.0 : 0.8,
                          duration: Duration(milliseconds: 300),
                          child: GestureDetector(
                            onTap: () =>
                                _navigateToDetails(controller.cocktails[index]),
                            child: CocktailCard(
                                cocktail: controller.cocktails[index]),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void _navigateToDetails(Cocktail cocktail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CocktailDetailScreen(cocktail: cocktail),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search'),
          content: TextField(
            decoration: InputDecoration(hintText: 'Enter search term'),
            onSubmitted: (value) {
              // Perform search logic here
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
