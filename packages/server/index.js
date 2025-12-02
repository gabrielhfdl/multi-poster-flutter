import express from 'express'
import cors from 'cors'
import axios from 'axios'
import { TwitterApi } from 'twitter-api-v2'
import dotenv from 'dotenv'
import { fileURLToPath } from 'url'
import { dirname, join } from 'path'
import FormData from 'form-data'
import { scrapeProduct } from './scraper.js'
import { formatPost } from './formatter.js'
import { generateDynamicPhrase } from './productPhrases.js'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)

const envPath = join(__dirname, '.env')
const result = dotenv.config({ path: envPath })

if (result.error) {
  console.warn('Erro ao carregar .env:', result.error.message)
  dotenv.config()
}

const app = express()
const PORT = process.env.PORT || 4000

app.use(cors())
app.use(express.json())

let twitterClient
let twitterClientV2

try {
  twitterClient = new TwitterApi({
    appKey: process.env.X_API_KEY,
    appSecret: process.env.X_API_SECRET,
    accessToken: process.env.X_ACCESS_TOKEN,
    accessSecret: process.env.X_ACCESS_SECRET,
  })
  twitterClientV2 = twitterClient.v2
} catch (error) {
  console.warn('Erro ao inicializar cliente do Twitter:', error.message)
}

app.post('/api/scrape-product', async (req, res) => {
  try {
    const { url } = req.body

    if (!url || typeof url !== 'string' || !url.trim()) {
      return res.status(400).json({
        error: 'Campo "url" é obrigatório e deve ser uma string não vazia'
      })
    }

    const productData = await scrapeProduct(url)

    const { phrase: generatedPhrase, emoji: generatedEmoji } = generateDynamicPhrase(productData.title)

    res.json({
      success: true,
      data: productData,
      generatedPhrase,
      generatedEmoji
    })
  } catch (error) {
    res.status(400).json({
      success: false,
      error: error.message
    })
  }
})

app.post('/api/post-everywhere', async (req, res) => {
  const { text, productUrl, coupon } = req.body

  if (productUrl) {
    const editedPrice = req.body.price || null
    return handleProductPost(req, res, productUrl, coupon, editedPrice)
  }

  if (!text || typeof text !== 'string' || !text.trim()) {
    return res.status(400).json({
      error: 'Campo "text" ou "productUrl" é obrigatório'
    })
  }

  const platforms = req.body.platforms || { telegram: true, twitter: true }
  const sendToTelegram = platforms.telegram !== false
  const sendToTwitter = platforms.twitter !== false

  const result = {
    twitter: { ok: false, error: null, data: null },
    telegram: { ok: false, error: null, data: null }
  }

  if (sendToTwitter) {
    try {
      if (!twitterClientV2) {
        throw new Error('Cliente do Twitter não inicializado. Verifique as variáveis de ambiente.')
      }
      const tweet = await twitterClientV2.tweet(text)
      result.twitter = {
        ok: true,
        data: tweet.data
      }
    } catch (error) {
      let errorMessage = error.message || 'Erro ao publicar no X'
      let errorDetails = null

      if (error.code) {
        errorDetails = {
          code: error.code,
          message: errorMessage
        }

        if (error.code === 403) {
          errorMessage = 'Erro 403: Acesso negado. Possíveis causas:\n' +
            '- Token de acesso não tem permissão para postar (apenas leitura)\n' +
            '- Aplicação não tem permissões de escrita configuradas\n' +
            '- Token expirado ou revogado\n' +
            '- Verifique as configurações no Twitter Developer Portal'
        } else if (error.code === 401) {
          errorMessage = 'Erro 401: Não autorizado. Verifique se as credenciais estão corretas.'
        } else if (error.code === 429) {
          errorMessage = 'Erro 429: Muitas requisições. Aguarde alguns minutos antes de tentar novamente.'
        }
      }

      if (error.data) {
        errorDetails = { ...errorDetails, ...error.data }
      }

      result.twitter = {
        ok: false,
        error: errorMessage,
        details: errorDetails || error.code || null
      }
    }
  } else {
    result.twitter = {
      ok: false,
      error: 'Postagem no X desabilitada',
      skipped: true
    }
  }

  if (sendToTelegram) {
    try {
      const TG_BOT_TOKEN = process.env.TG_BOT_TOKEN
      const TG_CHAT_ID = process.env.TG_CHAT_ID

      if (!TG_BOT_TOKEN || !TG_CHAT_ID) {
        throw new Error('TG_BOT_TOKEN e TG_CHAT_ID devem estar configurados')
      }


      const telegramUrl = `https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage`

      const telegramResponse = await axios.post(telegramUrl, {
        chat_id: TG_CHAT_ID,
        text: text
      })

      result.telegram = {
        ok: true,
        data: telegramResponse.data
      }
    } catch (error) {
      result.telegram = {
        ok: false,
        error: error.response?.data?.description || error.message || 'Erro ao publicar no Telegram'
      }
    }
  } else {
    result.telegram = {
      ok: false,
      error: 'Postagem no Telegram desabilitada',
      skipped: true
    }
  }

  res.json(result)
})

async function handleProductPost(req, res, productUrl, coupon = '', editedPrice = null) {
  const platforms = req.body.platforms || { telegram: true, twitter: true }
  const sendToTelegram = platforms.telegram !== false
  const sendToTwitter = platforms.twitter !== false

  const result = {
    twitter: { ok: false, error: null, data: null },
    telegram: { ok: false, error: null, data: null },
    productData: null
  }

  try {
    const productData = await scrapeProduct(productUrl)

    if (editedPrice && editedPrice.trim()) {
      productData.price = editedPrice.trim()
    }

    result.productData = productData

    const customPhrase = req.body.customPhrase || null
    const customEmoji = req.body.customEmoji || null
    const formatResult = formatPost(productData, coupon, customPhrase, customEmoji)
    const { formattedText, twitterText, generatedPhrase, generatedEmoji } = formatResult

    result.generatedPhrase = generatedPhrase
    result.generatedEmoji = generatedEmoji

    if (req.body.preview === true) {
      return res.json(result)
    }

    let imageBuffer = null
    let imageContentType = 'image/jpeg'

    if (productData.imageUrl) {
      try {
        const imageResponse = await axios.get(productData.imageUrl, {
          responseType: 'arraybuffer',
          timeout: 10000,
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
          }
        })
        imageBuffer = Buffer.from(imageResponse.data)
        imageContentType = imageResponse.headers['content-type'] || 'image/jpeg'
      } catch (error) {
        console.warn('Erro ao baixar imagem:', error.message)
      }
    }

    if (sendToTwitter) {
      try {
        if (!twitterClientV2) {
          throw new Error('Cliente do Twitter não inicializado')
        }

        if (imageBuffer) {
          const mediaId = await twitterClient.v1.uploadMedia(imageBuffer, {
            mimeType: imageContentType
          })

          const tweet = await twitterClientV2.tweet({
            text: twitterText,
            media: { media_ids: [mediaId] }
          })

          result.twitter = {
            ok: true,
            data: tweet.data
          }
        } else {
          const tweet = await twitterClientV2.tweet(twitterText)
          result.twitter = {
            ok: true,
            data: tweet.data
          }
        }
      } catch (error) {
        let errorMessage = error.message || 'Erro ao publicar no X'
        if (error.code === 403) {
          errorMessage = 'Erro 403: Verifique as permissões da aplicação no Twitter Developer Portal'
        }
        result.twitter = {
          ok: false,
          error: errorMessage,
          details: error.code || null
        }
      }
    } else {
      result.twitter = {
        ok: false,
        error: 'Postagem no X desabilitada',
        skipped: true
      }
    }

    if (sendToTelegram) {
      try {
        const TG_BOT_TOKEN = process.env.TG_BOT_TOKEN
        const TG_CHAT_ID = process.env.TG_CHAT_ID

        if (!TG_BOT_TOKEN || !TG_CHAT_ID) {
          throw new Error('TG_BOT_TOKEN e TG_CHAT_ID devem estar configurados')
        }

        if (imageBuffer) {
          const formData = new FormData()
          formData.append('chat_id', TG_CHAT_ID)
          formData.append('photo', imageBuffer, {
            filename: 'product.jpg',
            contentType: imageContentType
          })
          formData.append('caption', formattedText)
          formData.append('parse_mode', 'HTML')

          const inlineKeyboard = {
            inline_keyboard: [[
              {
                text: '🛒 Comprar agora',
                url: productData.url
              }
            ]]
          }
          formData.append('reply_markup', JSON.stringify(inlineKeyboard))

          const telegramResponse = await axios.post(
            `https://api.telegram.org/bot${TG_BOT_TOKEN}/sendPhoto`,
            formData,
            {
              headers: formData.getHeaders()
            }
          )

          result.telegram = {
            ok: true,
            data: telegramResponse.data
          }
        } else {
          const telegramUrl = `https://api.telegram.org/bot${TG_BOT_TOKEN}/sendMessage`
          const inlineKeyboard = {
            inline_keyboard: [[
              {
                text: '🛒 Comprar agora',
                url: productData.url
              }
            ]]
          }

          const telegramResponse = await axios.post(telegramUrl, {
            chat_id: TG_CHAT_ID,
            text: formattedText,
            parse_mode: 'HTML',
            reply_markup: inlineKeyboard
          })

          result.telegram = {
            ok: true,
            data: telegramResponse.data
          }
        }
      } catch (error) {
        result.telegram = {
          ok: false,
          error: error.response?.data?.description || error.message || 'Erro ao publicar no Telegram'
        }
      }
    } else {
      result.telegram = {
        ok: false,
        error: 'Postagem no Telegram desabilitada',
        skipped: true
      }
    }

    res.json(result)
  } catch (error) {
    res.status(400).json({
      error: error.message,
      result
    })
  }
}

app.get('/health', (req, res) => {
  res.json({ status: 'ok' })
})

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`)
  console.log(`Endpoint: http://localhost:${PORT}/api/post-everywhere`)
})
