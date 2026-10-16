#  Livro de Receitas

Aplicativo mobile desenvolvido em Flutter para a atividade **Aula06 — App com dados de uma API própria**, do curso de Desenvolvimento de Sistemas do SESI SENAI.

O projeto consiste em um livro de receitas digital que consome dados de uma API própria hospedada na Vercel, permitindo visualizar receitas, consultar seus detalhes, cadastrar novas receitas e excluir receitas existentes.

##  Download do aplicativo

[ **BAIXAR LIVRO DE RECEITAS — APK ANDROID**](https://github.com/biaams-sys/flutter_desafio_receitas/releases/latest/download/app-release.apk)

Após baixar, abra o arquivo em um dispositivo Android e autorize a instalação, caso o sistema solicite.
##  Funcionalidades

- **Listagem de receitas:** consulta as receitas disponibilizadas pela API.
- **Detalhes da receita:** exibe informações como nome, ingredientes, modo de preparo, custo aproximado e imagem.
- **Cadastro de receitas:** permite adicionar novas receitas.
- **Exclusão de receitas:** remove receitas por meio de uma requisição à API.
- **Atualização da lista:** permite atualizar os dados ao deslizar a tela para baixo.
- **Splash Screen:** tela inicial do aplicativo.
- **Interface personalizada:** design com tons de branco e laranja, cartões arredondados e navegação inferior.

## 🛠️ Tecnologias utilizadas

- **Flutter:** desenvolvimento da interface mobile.
- **Dart:** linguagem de programação.
- **HTTP:** comunicação com a API por meio de requisições HTTP.
- **API REST:** integração com o back-end.
- **Vercel:** hospedagem da API.
- **Git e GitHub:** versionamento e disponibilização do projeto.

##  API utilizada

A aplicação consome a API do Livro de Receitas, hospedada na Vercel.

- **API online:** https://receitasapi-b-2025.vercel.app/
- **Endpoint de receitas:** `GET /receitas`
- **Exclusão de receitas:** `DELETE /receitas/:id`

A comunicação com a API permite obter e manipular os dados das receitas diretamente pelo aplicativo.

##  Como executar o projeto

1. Instale o Flutter e configure o ambiente de desenvolvimento.
2. Clone este repositório.
3. Abra a pasta do projeto no VS Code.
4. Instale as dependências:

   ```bash
   flutter pub get
   ```

5. Execute o aplicativo:

   ```bash
   flutter run
   ```

6. Para gerar uma versão APK para Android:

   ```bash
   flutter build apk --release
   ```

O APK gerado ficará disponível em:

`build/app/outputs/flutter-apk/app-release.apk`

##  Estrutura do projeto

```text
.
├── android/
├── assets/
│   └── app-release.apk
├── lib/
│   ├── main.dart
│   ├── splash_page.dart
│   ├── home_page.dart
│   ├── nova_receita_page.dart
│   └── detalhes_page.dart
├── pubspec.yaml
└── README.md
```

**Aula 06 — App com dados de uma API própria**

Atividade prática de desenvolvimento mobile com Flutter, com foco no consumo de uma API REST própria, integração entre front-end e back-end e geração de um APK para instalação em dispositivos Android.

Desenvolvido como parte do curso de Desenvolvimento de Sistemas — SESI SENAI.

Feito por Beatriz - biaams-sys
