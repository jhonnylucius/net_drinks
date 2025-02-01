# 🍹 Net Drinks App

Bem-vindo ao **Net Drinks App**! Este aplicativo foi desenvolvido com o objetivo de ajudar os usuários a aprenderem a fazer coquetéis incríveis. Além disso, foi uma excelente oportunidade para praticar e aprimorar habilidades em **Dart** e **Flutter**.

## 🎯 Objetivo

O objetivo principal do Net Drinks App é fornecer uma plataforma onde os usuários possam explorar e aprender a fazer diversos coquetéis. O aplicativo oferece receitas detalhadas, listas de ingredientes e instruções passo a passo.

## 🛠️ Tecnologias Utilizadas

- **Dart**: Linguagem de programação utilizada para desenvolver o aplicativo.
- **Flutter**: Framework utilizado para construir a interface do usuário.
- **Firebase**: Utilizado para autenticação e armazenamento de dados.

## 📋 Funcionalidades

- **Autenticação de Usuário**: Verificação de e-mails e segurança aprimorada.
- **Exploração de Receitas**: Navegue por uma vasta coleção de receitas de coquetéis.
- **Favoritos**: Salve suas receitas favoritas para fácil acesso.
- **Busca Avançada**: Encontre receitas por nome, ingrediente ou categoria.

## 🔒 Segurança

A segurança é uma prioridade no Net Drinks App. Implementamos verificações de e-mail para garantir que apenas usuários autenticados possam acessar certas funcionalidades. Além disso, utilizamos práticas recomendadas de segurança para proteger os dados dos usuários.

## 📂 Estrutura do Código

O código do aplicativo está organizado da seguinte forma:

```
├── lib/
        │   ├── main.dart
        │   ├── adapters/
        │   │   └── cocktail_adapter.dart
        │   ├── bindings/
        │   │   ├── app_bindings.dart
        │   │   └── search_binding.dart
        │   ├── components/
        │   │   └── menu.dart
        │   ├── controller/
        │   │   ├── cocktail_detail_controller.dart
        │   │   ├── cocktail_list_controller.dart
        │   │   └── search_controller.dart
        │   ├── modal/
        │   │   └── reset_password_modal.dart
        │   ├── models/
        │   │   ├── cocktail.dart
        │   │   ├── cocktails_example_api.dart
        │   │   └── user_model.dart
        │   ├── repository/
        │   │   └── cocktail_repository.dart
        │   ├── screens/
        │   │   ├── cocktail_detail_screen.dart
        │   │   ├── home_screen.dart
        │   │   ├── language_selection_screen.dart
        │   │   ├── login_screen.dart
        │   │   ├── register_screen.dart
        │   │   ├── search_dialog.dart
        │   │   ├── verify_email_screen.dart
        │   │   └── search/
        │   │       ├── search_filter_dialog.dart
        │   │       ├── search_results_screen.dart
        │   │       └── search_screen.dart
        │   ├── services/
        │   │   ├── auth_services.dart
        │   │   ├── locator_service.dart
        │   │   ├── search_service.example.dart
        │   │   └── translation_service.dart
        │   └── widgets/
        │       ├── cocktail_card_widget.dart
        │       ├── progress_indicador2_widget.dart
        │       └── terms_of_service_dialog.dart
```


- **models**: Contém as classes de modelo que representam os dados.
- **screens**: Contém as telas do aplicativo.
- **services**: Contém a lógica de negócios e integração com APIs.
- **widgets**: Contém os componentes reutilizáveis da interface do usuário.

## 📧 Verificação de E-mails

Utilizamos o Firebase para autenticação de usuários, incluindo a verificação de e-mails. Isso garante que apenas usuários válidos possam acessar o aplicativo.

## ⚙️ Utilização dos Arquivos `.example`

No repositório, você encontrará arquivos `.example`. Estes arquivos são exemplos de configuração que podem ser utilizados diretamente. Basta remover a extensão `.example` e inserir suas próprias chaves de API para utilizar a versão gratuita da API que estamos usando.

## 🚀 Como Começar

1. Clone o repositório.
2. Renomeie os arquivos `.example` removendo a extensão.
3. Insira suas chaves de API nos arquivos de configuração.
4. Execute o aplicativo utilizando o Flutter.

Aproveite e divirta-se explorando e aprendendo a fazer coquetéis com o Net Drinks App! 🍸
