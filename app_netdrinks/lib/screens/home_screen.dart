import 'package:app_netdrinks/components/menu.dart';
import 'package:app_netdrinks/controller/cocktail_detail_controller.dart';
import 'package:app_netdrinks/models/cocktail.dart';
import 'package:app_netdrinks/screens/cocktail_detail_screen.dart';
import 'package:app_netdrinks/widgets/cocktail_card_widget.dart';
import 'package:app_netdrinks/widgets/progress_indicador2_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController(viewportFraction: 0.7);
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  late final CocktailController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CocktailController>();
    pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    int page = pageController.page?.round() ?? 0;
    _currentPage.value = page;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Permite conteúdo atrás do AppBar
      appBar: AppBar(
        backgroundColor:
            Colors.black.withAlpha(179), // AppBar preto semi-transparente
        elevation: 0,
        title: Text('NetDrinks'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
        ],
      ),
      drawer: Menu(user: widget.user), // Adiciona o Drawer
      body: Obx(() {
        if (controller.loading) {
          return ProgressIndicador2Widget();
        }

        return Stack(
          fit: StackFit.expand, // Força Stack ocupar tela toda
          children: [
            // Background com imagem
            Positioned.fill(
              child: ValueListenableBuilder<int>(
                valueListenable: _currentPage,
                builder: (context, currentIndex, _) {
                  if (controller.cocktails.isEmpty) return Container();

                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: Container(
                      key: ValueKey(currentIndex),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            controller.cocktails[currentIndex].imageUrl,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Gradiente mais forte
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withAlpha(179),
                      Colors.black.withAlpha(51),
                      Colors.black.withAlpha(179),
                      Colors.black.withAlpha(230),
                    ],
                    stops: [0.0, 0.1, 0.5, 0.9],
                  ),
                ),
              ),
            ),

            // Nome do cocktail e carrossel
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Nome do cocktail atual
                  ValueListenableBuilder<int>(
                    valueListenable: _currentPage,
                    builder: (context, currentIndex, _) {
                      if (controller.cocktails.isEmpty) return Container();

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

                  // Carrossel
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
                              cocktail: controller.cocktails[index],
                              user: '',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Widget _navigateToDetails(Cocktail cocktail) {
    // Navigate to details page
    Get.to(() => CocktailDetailScreen(cocktail: cocktail));
    return SizedBox.shrink();
  }

  Widget _showSearchDialog(BuildContext context) {
    return AlertDialog(
      title: Text(FlutterI18n.translate(context, 'search.title')),
      content: TextField(
        decoration: InputDecoration(
          hintText: FlutterI18n.translate(context, 'search.name'),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(FlutterI18n.translate(context, 'search.cancel')),
        ),
        TextButton(
          onPressed: () {
            // Perform search action
            Navigator.of(context).pop();
          },
          child: Text(FlutterI18n.translate(context, 'search.search')),
        ),
      ],
    );
  }
}
