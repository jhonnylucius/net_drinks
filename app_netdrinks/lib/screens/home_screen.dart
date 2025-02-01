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
  late PageController pageController;
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  late final CocktailController controller;

  double _viewportFraction = 0.7; //Initial default value

  @override
  void initState() {
    super.initState();
    controller = Get.find<CocktailController>();
    _initializePageController();
  }

  void _initializePageController() {
    pageController = PageController(viewportFraction: _viewportFraction);
    pageController.addListener(_onPageChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenWidth = MediaQuery.of(context).size.width;
    final newViewportFraction = screenWidth > 768 ? 0.3 : 0.7;

    if (newViewportFraction != _viewportFraction) {
      _viewportFraction = newViewportFraction;
      //remove old listener
      pageController.removeListener(_onPageChanged);
      //Dispose of the old controller
      pageController.dispose();
      //recreate controller with new viewportFraction
      _initializePageController();
      //reset the current page
      _currentPage.value = 0;
    }
  }

// Método chamado quando a página do PageView muda.
  void _onPageChanged() {
    int page = pageController.page?.round() ?? 0;
    _currentPage.value = page;
  }

  // Corrige o método de navegação
  void _navigateToDetails(Cocktail cocktail) {
    Get.to(() => CocktailDetailScreen(cocktail: cocktail));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Estende o corpo do Scaffold para trás da AppBar.
      extendBodyBehindAppBar: true,
      // Define a AppBar da tela.
      appBar: AppBar(
        // Define a cor de fundo da AppBar com transparência.
        backgroundColor: Colors.black.withAlpha(179),
        // Remove a sombra da AppBar.
        elevation: 0,
        // Define o título da AppBar baseado no estado 'showFavorites'.
        title: Text(widget.showFavorites
            ? FlutterI18n.translate(context, 'Favoritos')
            : FlutterI18n.translate(context, 'NetDrinks')),
        // Define o botão de menu lateral.
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            // Abre o menu lateral quando o botão é pressionado.
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        // Define os botões de ação da AppBar.
        actions: [
          // Se 'showFavorites' for true, mostra o botão de voltar para a Home.
          if (widget.showFavorites)
            IconButton(
              icon: const Icon(Icons.home),
              // Navega para a tela Home.
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('/home'),
            ),
          // Botão de pesquisa.
          IconButton(
            icon: const Icon(Icons.search),
            // Navega para a tela de pesquisa.
            onPressed: () => Get.toNamed('/search'),
          ),
        ],
      ),
      // Define o menu lateral.
      drawer: Menu(user: widget.user),
      // Define o corpo da tela, que é um Obx para reatividade do GetX.
      body: Obx(() {
        // Se estiver carregando, mostra um indicador de carregamento.
        if (controller.loading) {
          return Center(child: CircularProgressIndicator());
        }

        // Determina quais drinks exibir com base no estado 'showFavorites'.
        final displayCocktails = widget.showFavorites
            ? controller.getFavoriteCocktails()
            : controller.cocktails;

        // Se não houver drinks favoritos e 'showFavorites' for true, mostra uma mensagem.
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

        // Retorna um Stack para sobrepor os elementos da tela.
        return Stack(
          fit: StackFit.expand,
          children: [
            // Um Positioned.fill para ocupar todo o espaço da tela.
            Positioned.fill(
              child: ValueListenableBuilder<int>(
                valueListenable: _currentPage,
                builder: (context, currentIndex, _) {
                  // Se não houver drinks, retorna um Container vazio.
                  if (displayCocktails.isEmpty) return Container();

                  // Evita um erro de índice se currentIndex for maior que o tamanho da lista
                  if (currentIndex >= displayCocktails.length) {
                    return Container(); // Evita erro de índice
                  }

                  // Mostra uma imagem de fundo que corresponde ao drink selecionado
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
            // Um Positioned.fill para criar um efeito de gradiente sobre a imagem de fundo.
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
            // Um SafeArea para evitar sobreposição com elementos da interface do sistema.
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Exibe o nome do drink selecionado.
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
                  // Define o PageView para exibir os cards de drinks.
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: displayCocktails.length,
                      onPageChanged: (index) {
                        _currentPage.value = index;
                      },
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
    //remove old listener
    pageController.removeListener(_onPageChanged);
    // Libera o PageController ao descartar o widget.
    pageController.dispose();
    super.dispose();
  }
}
