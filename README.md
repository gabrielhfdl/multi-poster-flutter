# Multi-Poster

Aplicação para publicar produtos automaticamente no X (Twitter) e no Telegram com scraping automático de Mercado Livre, Amazon e Shopee.

## 📦 Estrutura do Projeto

```
multi-poster/
├─ package.json            # Root com workspaces
├─ .env.example           # Template de variáveis de ambiente
├─ apps/
│  └─ web/                # Frontend Flutter Web
│     ├─ pubspec.yaml
│     ├─ lib/
│     │  ├─ main.dart
│     │  ├─ app.dart
│     │  ├─ services/
│     │  │  └─ api_service.dart
│     │  └─ widgets/
│     │     ├─ platform_selector.dart
│     │     ├─ product_post_widget.dart
│     │     └─ simple_post_widget.dart
│     └─ web/
│        └─ index.html
└─ packages/
   └─ server/             # Backend Node/Express
      ├─ package.json
      ├─ index.js
      └─ .env.example
```

## 🚀 Instalação e Configuração

### 1. Instalar Dependências

Na raiz do projeto, execute:

```bash
npm install
```

Isso instalará todas as dependências dos workspaces (frontend e backend).

### 2. Configurar Variáveis de Ambiente

#### Backend


```bash
cd packages/server
```

Crie o arquivo `.env` e preencha com suas credenciais:

```env
PORT=4000

# X (Twitter)
X_API_KEY=sua_api_key_aqui
X_API_SECRET=seu_api_secret_aqui
X_ACCESS_TOKEN=seu_access_token_aqui
X_ACCESS_SECRET=seu_access_secret_aqui

# Telegram
TG_BOT_TOKEN=seu_bot_token_aqui
TG_CHAT_ID=seu_chat_id_aqui
```

**Como obter as credenciais:**

- **X (Twitter)**: Acesse [Twitter Developer Portal](https://developer.twitter.com/) e crie uma aplicação
- **Telegram**: 
  - Crie um bot com [@BotFather](https://t.me/botfather) no Telegram
  - Obtenha o `TG_BOT_TOKEN`
  - Para obter o `TG_CHAT_ID`, envie uma mensagem para seu bot e acesse: `https://api.telegram.org/bot<SEU_TOKEN>/getUpdates`

### 3. Executar a Aplicação

#### Terminal 1 - Backend

```bash
npm run dev:server
```

O servidor estará rodando em `http://localhost:4000`

#### Terminal 2 - Frontend Flutter Web

```bash
npm run dev:web
```

Ou diretamente:

```bash
cd apps/web
flutter run -d chrome
```

O app abrirá automaticamente no navegador Chrome.

### No workspace server:

- `npm run dev` - Inicia o servidor
- `npm start` - Inicia o servidor (produção)

## 🛠️ Tecnologias Utilizadas

- **Frontend**: Flutter Web, Dart, HTTP
- **Backend**: Node.js, Express, Twitter API v2, Telegram Bot API
- **Scraping**: Cheerio, Axios
- **Monorepo**: NPM Workspaces

## 🆕 Novas Funcionalidades

- ✅ **Scraping automático** de produtos do Mercado Livre, Amazon e Shopee
- ✅ **Formatação automática** de postagens com título, preço e hashtags
- ✅ **Envio de imagens** para X e Telegram
- ✅ **Botão inline** no Telegram para comprar
- ✅ **Suporte a cupons** opcionais
- ✅ **Interface melhorada** com preview do produto antes de postar

## 📡 API Endpoints

### POST /api/scrape-product

Faz scraping de um produto e retorna os dados.

**Request:**
```json
{
  "url": "https://www.mercadolivre.com.br/produto..."
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "title": "Nome do Produto",
    "price": "R$ 199,90",
    "imageUrl": "https://...",
    "url": "https://...",
    "site": "mercadolivre"
  }
}
```

### POST /api/post-everywhere

Publica um produto no X e no Telegram (com scraping automático).

**Request (novo formato com produto):**
```json
{
  "productUrl": "https://www.mercadolivre.com.br/produto...",
  "coupon": "LIBERACUPOM"
}
```

**Request (apenas texto):**
```json
{
  "text": "Sua mensagem aqui"
}
```

**Response:**
```json
{
  "twitter": {
    "ok": true,
    "data": { ... }
  },
  "telegram": {
    "ok": true,
    "data": { ... }
  },
  "productData": {
    "title": "...",
    "price": "...",
    "imageUrl": "...",
    "url": "...",
    "site": "mercadolivre"
  }
}
```

### GET /health

Endpoint de health check.

**Response:**
```json
{
  "status": "ok"
}
```

## ⚠️ Notas Importantes

- As publicações são feitas de forma independente. Se uma falhar, a outra ainda será executada.
- Certifique-se de que todas as variáveis de ambiente estão configuradas corretamente.
- O Flutter Web precisa do backend rodando para funcionar.
- A URL da API está configurada como `http://localhost:4000/api` no arquivo `apps/web/lib/services/api_service.dart`.

