import 'package:app_netdrinks/components/menu.dart';
import 'package:app_netdrinks/controller/cocktail_detail_controller.dart';
import 'package:app_netdrinks/models/cocktail.dart';
import 'package:app_netdrinks/screens/cocktail_detail_screen.dart';
import 'package:app_netdrinks/widgets/cocktail_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  final bool showFavorites;

  const HomeScreen({super.key, required this.user, this.showFavorites = false});

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withAlpha(179),
        elevation: 0,
        title: Text(widget.showFavorites
            ? FlutterI18n.translate(context, 'Favoritos')
            : FlutterI18n.translate(context, 'NetDrinks')),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          if (widget.showFavorites)
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('/home'),
            ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.toNamed('/search'),
          ),
        ],
      ),
      drawer: Menu(user: widget.user),
      body: Obx(() {
        if (controller.loading) {
          return Center(child: CircularProgressIndicator());
        }

        final displayCocktails = widget.showFavorites
            ? controller.getFavoriteCocktails()
            : controller.cocktails;

        if (displayCocktails.isEmpty && widget.showFavorites) {
          return Center(
            child: Text(
              FlutterI18n.translate(context,
                  'Você não tem Drinks Salvos,\n clique no coração ao lado da foto do Drink pra salvá-lo como favorito!'),
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: ValueListenableBuilder<int>(
                valueListenable: _currentPage,
                builder: (context, currentIndex, _) {
                  if (displayCocktails.isEmpty) return Container();

                  if (currentIndex >= displayCocktails.length) {
                    return Container(); // Evita erro de índice
                  }

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      key: ValueKey(currentIndex),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            displayCocktails[currentIndex].imageUrl,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
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
                    stops: const [0.0, 0.1, 0.5, 0.9],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: _currentPage,
                    builder: (context, currentIndex, _) {
                      if (displayCocktails.isEmpty ||
                          currentIndex >= displayCocktails.length) {
                        return Container();
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          displayCocktails[currentIndex].name,
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
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: displayCocktails.length,
                      itemBuilder: (context, index) {
                        return AnimatedScale(
                          scale: _currentPage.value == index ? 1.0 : 0.8,
                          duration: const Duration(milliseconds: 300),
                          child: GestureDetector(
                            onTap: () =>
                                _navigateToDetails(displayCocktails[index]),
                            child: CocktailCard(
                              cocktail: displayCocktails[index],
                              user: widget.user.uid,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
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
    Get.to(() => CocktailDetailScreen(cocktail: cocktail));
    return const SizedBox.shrink();
  }
}
