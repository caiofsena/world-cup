# Copa do Mundo FIFA 2026

Aplicativo mobile para acompanhar a Copa do Mundo 2026 — classificação dos grupos, calendário de jogos e palpites pessoais.

## Funcionalidades

- **12 grupos (A-L)** com 48 seleções e tabela de classificação
- **104 jogos** da fase de grupos até a final
- **Palpites** com pontuação (resultado exato, saldo de gols, vencedor)
- **Login** com Google e Apple via Firebase Auth
- Dados oficiais do sorteio realizado em dezembro de 2025
- Suporte a **pt-BR**

## Screenshots

| Grupos | Jogos | Palpites |
|--------|-------|----------|
| Classificação com P/J/V/E/D/GP/GC/SG | Filtro por fase (grupos → final) | Histórico de palpites salvos |

## Arquitetura

```
lib/
├── core/               # Tema, rotas, constantes
├── domain/             # Entidades e interfaces (contratos)
├── data/               # Datasources (JSON, SQLite) e repositórios
└── presentation/       # Providers Riverpod, telas e widgets
```

**Stack:** Riverpod · go_router · sqflite · Firebase Auth · Clean Architecture

## Como rodar

### Pré-requisitos

- Flutter 3.29+
- Conta Firebase com projeto configurado

### Setup

```bash
# 1. Gerar plataformas nativas (caso não existam)
flutter create . --project-name world_cup_2026

# 2. Instalar dependências
flutter pub get

# 3. Configurar Firebase
flutterfire configure

# 4. Rodar
flutter run
```

### Configuração do Firebase

1. Crie um projeto em [console.firebase.google.com](https://console.firebase.google.com)
2. Adicione os apps Android e iOS com os package names do projeto
3. Habilite **Authentication → Google** e **Sign in with Apple**
4. Adicione o SHA-1 do debug keystore no app Android:
   ```bash
   cd android && ./gradlew signingReport
   ```
5. Rode `flutterfire configure` ou baixe os arquivos manualmente:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`

## Formato do Torneio

| Fase | Jogos | Datas |
|------|-------|-------|
| Fase de Grupos | 72 | 11–28 Jun |
| 16-avos de Final | 16 | 30 Jun–4 Jul |
| Oitavas de Final | 8 | 6–9 Jul |
| Quartas de Final | 4 | 11–12 Jul |
| Semifinais | 2 | 14–15 Jul |
| 3º Lugar | 1 | 18 Jul |
| Final | 1 | 19 Jul |

**Total:** 104 jogos em 39 dias

## Pontuação dos Palpites

| Acerto | Pontos |
|--------|--------|
| Placar exato | 10 |
| Saldo de gols correto | 5 |
| Resultado (vitória/empate) | 3 |

## Licença

MIT
