<div align="center">
  <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/flutter/flutter-original.svg" width="70" />
  <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/dart/dart-original.svg" width="70" />
</div>

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

## 📤 Compartilhamento de Receitas

O Net Drinks App permite que você compartilhe suas receitas favoritas com amigos e familiares. Basta selecionar a receita que deseja compartilhar e enviar a foto como os detalhes e instruções  diretamente pelo aplicativo. Seus amigos poderão visualizar a receita completa e até mesmo suas próprias versões.

## 💾 Salvar Versões Personalizadas

Você pode criar e salvar suas próprias versões personalizadas de coquetéis. Essas versões são persistentes e ficam armazenadas em sua conta, permitindo que você acesse suas criações a qualquer momento. Quando você compartilha uma receita personalizada, todas as suas modificações são incluídas, proporcionando uma experiência única para quem recebe.

## 🔒 Criptografia e Segurança de Dados

Utilizamos o Firebase para garantir que todas as informações armazenadas e compartilhadas sejam criptografadas. Isso assegura que seus dados e receitas estejam sempre protegidos, mantendo a privacidade e segurança dos usuários.

## 🤝 Benefícios com Parceiros

Ao utilizar o Net Drinks App, você também poderá ter acesso a benefícios exclusivos com nossos futuros parceiros. Aproveite descontos em ingredientes, utensílios de bar e muito mais. Estamos constantemente trabalhando para trazer novas vantagens para nossos usuários, tornando sua experiência ainda mais completa e satisfatória.

## ⚙️ Utilização dos Arquivos `.example`

No repositório, você encontrará arquivos `.example`. Estes arquivos são exemplos de configuração que podem ser utilizados diretamente. Basta remover a extensão `.example` e inserir suas próprias chaves de API para utilizar a versão gratuita da API que estamos usando.

## 🚀 Como Começar

1. Clone o repositório.
2. Renomeie os arquivos `.example` removendo a extensão.
3. Insira suas chaves de API nos arquivos de configuração.
4. Execute o aplicativo utilizando o Flutter.

Aproveite e divirta-se explorando e aprendendo a fazer coquetéis com o Net Drinks! 🍸 Tin Tin!
