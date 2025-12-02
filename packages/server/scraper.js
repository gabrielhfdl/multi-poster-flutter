import axios from 'axios'
import * as cheerio from 'cheerio'

async function resolveShortUrl(url) {
         if (!url || typeof url !== 'string') return url

         const urlLower = url.toLowerCase()

         if (urlLower.includes('amzn.to/')) {
                  try {
                           const response = await axios.get(url, {
                                    maxRedirects: 10,
                                    timeout: 15000,
                                    validateStatus: () => true,
                                    headers: {
                                             'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
                                             'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
                                             'Accept-Language': 'pt-BR,pt;q=0.9,en-US;q=0.8',
                                    }
                           })

                           let finalUrl = url

                           if (response.request?.res?.responseUrl) {
                                    finalUrl = response.request.res.responseUrl
                           }
                           else if (response.request?.responseURL) {
                                    finalUrl = response.request.responseURL
                           }
                           else if (response.request?.redirectURLs && response.request.redirectURLs.length > 0) {
                                    finalUrl = response.request.redirectURLs[response.request.redirectURLs.length - 1]
                           }
                           else if (response.config?.url && response.config.url !== url) {
                                    finalUrl = response.config.url
                           }

                           if (finalUrl.includes('amazon.com') || finalUrl.includes('amazon.com.br')) {
                                    return finalUrl
                           } else {
                                    return url
                           }
                  } catch (error) {
                           console.warn('Erro ao resolver URL encurtada:', error.message)
                           return url
                  }
         }

         return url
}

export function detectSite(url) {
         if (!url || typeof url !== 'string') return null

         const urlLower = url.toLowerCase()

         if (urlLower.includes('mercadolivre.com') || urlLower.includes('mercadolivre.com.br')) {
                  return 'mercadolivre'
         }
         if (urlLower.includes('amazon.com') || urlLower.includes('amazon.com.br') || urlLower.includes('amzn.to/')) {
                  return 'amazon'
         }
         if (urlLower.includes('shopee.com') || urlLower.includes('shopee.com.br')) {
                  return 'shopee'
         }

         return null
}

async function scrapeMercadoLivre(url) {
         try {
                  let normalizedUrl = url

                  const response = await axios.get(normalizedUrl, {
                           headers: {
                                    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
                                    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
                                    'Accept-Language': 'pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7',
                                    'Referer': 'https://www.mercadolivre.com.br/',
                                    'Cache-Control': 'no-cache',
                                    'Pragma': 'no-cache',
                                    'Accept-Encoding': 'gzip, deflate, br',
                           },
                           timeout: 15000,
                           maxRedirects: 5,
                           params: {
                                    _t: Date.now()
                           }
                  })

                  const $ = cheerio.load(response.data)

                  let title = ''
                  const titleSelectors = [
                           'h1.ui-pdp-title',
                           'h1[data-testid="product-title"]',
                           '.ui-pdp-header__title',
                           'h1.andes-visually-hidden',
                           'meta[property="og:title"]',
                           'h1'
                  ]

                  for (const selector of titleSelectors) {
                           if (selector.startsWith('meta')) {
                                    title = $(selector).attr('content')?.trim()
                           } else {
                                    title = $(selector).first().text().trim()
                           }
                           if (title) break
                  }

                  let priceWhole = ''
                  let priceCents = ''

                  const scripts = $('script').toArray()
                  for (const script of scripts) {
                           const scriptContent = $(script).html() || ''

                           const pricePatterns = [
                                    /"price"\s*:\s*(\d+\.?\d*)/i,
                                    /"price"\s*:\s*"(\d+\.?\d*)"/i,
                                    /price:\s*(\d+\.?\d*)/i,
                                    /"amount"\s*:\s*(\d+\.?\d*)/i,
                                    /"value"\s*:\s*(\d+\.?\d*)/i,
                                    /window\.__PRELOADED_STATE__.*?"price":\s*(\d+\.?\d*)/i,
                                    /__PRELOADED_STATE__.*?"price":\s*(\d+\.?\d*)/i
                           ]

                           for (const pattern of pricePatterns) {
                                    const match = scriptContent.match(pattern)
                                    if (match && match[1]) {
                                             const priceValue = parseFloat(match[1])
                                             if (!isNaN(priceValue) && priceValue > 0) {
                                                      priceWhole = Math.floor(priceValue).toString()
                                                      const cents = Math.round((priceValue - Math.floor(priceValue)) * 100)
                                                      priceCents = cents > 0 ? cents.toString().padStart(2, '0') : ''
                                                      break
                                             }
                                    }
                           }
                           if (priceWhole) break
                  }

                  if (!priceWhole) {
                           const jsonLdScripts = $('script[type="application/ld+json"]').toArray()
                           for (const script of jsonLdScripts) {
                                    try {
                                             const jsonContent = $(script).html()
                                             if (jsonContent) {
                                                      const data = JSON.parse(jsonContent)

                                                      if (data.offers) {
                                                               const offers = Array.isArray(data.offers) ? data.offers : [data.offers]
                                                               for (const offer of offers) {
                                                                        if (offer.price) {
                                                                                 const priceValue = parseFloat(offer.price)
                                                                                 if (!isNaN(priceValue) && priceValue > 0) {
                                                                                          priceWhole = Math.floor(priceValue).toString()
                                                                                          const cents = Math.round((priceValue - Math.floor(priceValue)) * 100)
                                                                                          priceCents = cents > 0 ? cents.toString().padStart(2, '0') : ''
                                                                                          break
                                                                                 }
                                                                        }
                                                               }
                                                      }

                                                      if (!priceWhole && data.price) {
                                                               const priceValue = parseFloat(data.price)
                                                               if (!isNaN(priceValue) && priceValue > 0) {
                                                                        priceWhole = Math.floor(priceValue).toString()
                                                                        const cents = Math.round((priceValue - Math.floor(priceValue)) * 100)
                                                                        priceCents = cents > 0 ? cents.toString().padStart(2, '0') : ''
                                                               }
                                                      }
                                             }
                                             if (priceWhole) break
                                    } catch (e) {
                                    }
                           }
                  }

                  if (!priceWhole) {
                           const secondLinePrice = $('.ui-pdp-price__second-line')
                           if (secondLinePrice.length) {
                                    const fraction = secondLinePrice.find('.andes-money-amount__fraction').first()
                                    const cents = secondLinePrice.find('.andes-money-amount__cents').first()

                                    if (fraction.length) {
                                             priceWhole = fraction.text().trim().replace(/\D/g, '')
                                             if (cents.length) {
                                                      priceCents = cents.text().trim()
                                             }
                                    }
                           }
                  }

                  if (!priceWhole) {
                           const firstLinePrice = $('.ui-pdp-price__first-line')
                           if (firstLinePrice.length) {
                                    const fraction = firstLinePrice.find('.andes-money-amount__fraction').first()
                                    const cents = firstLinePrice.find('.andes-money-amount__cents').first()

                                    if (fraction.length) {
                                             priceWhole = fraction.text().trim().replace(/\D/g, '')
                                             if (cents.length) {
                                                      priceCents = cents.text().trim()
                                             }
                                    }
                           }
                  }

                  if (!priceWhole) {
                           const alternativeSelectors = [
                                    '[data-testid="price"] .andes-money-amount__fraction',
                                    '.ui-pdp-price .andes-money-amount__fraction',
                                    '.andes-money-amount__fraction'
                           ]

                           for (const selector of alternativeSelectors) {
                                    const priceElement = $(selector).first()
                                    if (priceElement.length) {
                                             priceWhole = priceElement.text().trim().replace(/\D/g, '')
                                             if (priceWhole) {
                                                      const parent = priceElement.parent()
                                                      priceCents = parent.find('.andes-money-amount__cents').first().text().trim() ||
                                                               parent.siblings('.andes-money-amount__cents').first().text().trim()
                                                      break
                                             }
                                    }
                           }
                  }

                  if (!priceWhole) {
                           const fullPriceText = $('.ui-pdp-price__second-line').text().trim() ||
                                    $('.ui-pdp-price__first-line').text().trim() ||
                                    $('[data-testid="price"]').text().trim() ||
                                    $('.ui-pdp-price').text().trim() ||
                                    $('.andes-money-amount').first().text().trim()

                           if (fullPriceText) {
                                    const priceMatch = fullPriceText.match(/R\$\s*(\d{1,3}(?:\.\d{3})*)[,.](\d{2})/) ||
                                             fullPriceText.match(/R\$\s*(\d+)[,.](\d{2})/) ||
                                             fullPriceText.match(/(\d{1,3}(?:\.\d{3})*)[,.](\d{2})/) ||
                                             fullPriceText.match(/(\d+)[,.](\d{2})/) ||
                                             fullPriceText.match(/(\d+)/)

                                    if (priceMatch) {
                                             priceWhole = priceMatch[1].replace(/\./g, '')
                                             priceCents = priceMatch[2] || ''
                                    }
                           }
                  }

                  let price = ''
                  if (priceWhole) {
                           const formattedWhole = priceWhole.replace(/\B(?=(\d{3})+(?!\d))/g, '.')
                           if (priceCents) {
                                    price = `R$ ${formattedWhole},${priceCents}`
                           } else {
                                    price = `R$ ${formattedWhole}`
                           }
                  } else {
                           throw new Error('Não foi possível extrair o preço do produto')
                  }

                  let imageUrl = ''
                  const imageSelectors = [
                           'meta[property="og:image"]',
                           'img.ui-pdp-image',
                           'img[data-testid="product-image"]',
                           '.ui-pdp-gallery__figure img',
                           '.ui-pdp-image img',
                           'img[alt*="produto"]',
                           'img[alt*="imagem"]'
                  ]

                  for (const selector of imageSelectors) {
                           if (selector.startsWith('meta')) {
                                    imageUrl = $(selector).attr('content')?.trim()
                           } else {
                                    imageUrl = $(selector).first().attr('src') || $(selector).first().attr('data-src')
                           }
                           if (imageUrl) {
                                    if (imageUrl.includes('http')) {
                                             imageUrl = imageUrl.split('?')[0]
                                    }
                                    break
                           }
                  }

                  if (!title) {
                           throw new Error('Não foi possível extrair o título do produto')
                  }

                  return {
                           title: title.trim(),
                           price: price.trim(),
                           imageUrl: imageUrl || null,
                           url: url,
                           site: 'mercadolivre'
                  }
         } catch (error) {
                  throw new Error(`Erro ao fazer scraping do Mercado Livre: ${error.message}`)
         }
}

async function scrapeAmazon(url) {
         try {
                  const urlLower = url.toLowerCase()
                  let finalUrl = url

                  if (urlLower.includes('amzn.to/')) {
                           finalUrl = await resolveShortUrl(url)
                           if (finalUrl === url) {
                           }
                  }

                  const response = await axios.get(finalUrl, {
                           headers: {
                                    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
                                    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
                                    'Accept-Language': 'pt-BR,pt;q=0.9,en-US;q=0.8',
                                    'Referer': 'https://www.amazon.com.br/',
                           },
                           timeout: 15000,
                           maxRedirects: 10
                  })

                  const $ = cheerio.load(response.data)

                  const title = $('#productTitle').text().trim() ||
                           $('h1.a-size-large').text().trim() ||
                           $('span#productTitle').text().trim()

                  const priceWhole = $('.a-price-whole').first().text().trim().replace(/\D/g, '')
                  const priceFraction = $('.a-price-fraction').first().text().trim()
                  const price = priceWhole && priceFraction ? `R$ ${priceWhole},${priceFraction}` :
                           $('.a-price .a-offscreen').first().text().trim() ||
                           $('span.a-price').first().text().trim()

                  const imageUrl = $('#landingImage').attr('src') ||
                           $('#imgBlkFront').attr('src') ||
                           $('img#main-image').attr('src') ||
                           $('meta[property="og:image"]').attr('content')

                  if (!title || !price) {
                           throw new Error('Não foi possível extrair título ou preço do produto')
                  }

                  return {
                           title: title.trim(),
                           price: price.trim(),
                           imageUrl: imageUrl || null,
                           url: url,
                           site: 'amazon'
                  }
         } catch (error) {
                  throw new Error(`Erro ao fazer scraping da Amazon: ${error.message}`)
         }
}

async function scrapeShopee(url) {
         try {
                  const response = await axios.get(url, {
                           headers: {
                                    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                                    'Accept': 'text/html,application/xhtml+xml',
                                    'Accept-Language': 'pt-BR,pt;q=0.9',
                           },
                           timeout: 10000
                  })

                  const $ = cheerio.load(response.data)

                  const title = $('.product-title').text().trim() ||
                           $('h1').first().text().trim() ||
                           $('meta[property="og:title"]').attr('content')

                  const price = $('.product-price').text().trim() ||
                           $('[data-testid="price"]').text().trim() ||
                           $('.price').first().text().trim()

                  const imageUrl = $('img[data-testid="product-image"]').first().attr('src') ||
                           $('.product-image img').first().attr('src') ||
                           $('meta[property="og:image"]').attr('content')

                  if (!title || !price) {
                           throw new Error('Não foi possível extrair título ou preço do produto')
                  }

                  return {
                           title: title.trim(),
                           price: price.trim(),
                           imageUrl: imageUrl || null,
                           url: url,
                           site: 'shopee'
                  }
         } catch (error) {
                  throw new Error(`Erro ao fazer scraping da Shopee: ${error.message}`)
         }
}

export async function scrapeProduct(url) {
         if (!url || typeof url !== 'string') {
                  throw new Error('URL inválida')
         }

         const originalUrl = url

         const urlLower = url.toLowerCase()
         const isShortUrl = urlLower.includes('amzn.to/')

         let resolvedUrl = url
         if (isShortUrl) {
                  resolvedUrl = await resolveShortUrl(url)
         }

         const site = detectSite(resolvedUrl) || detectSite(url)

         if (!site) {
                  throw new Error('Site não suportado. Suportamos: Mercado Livre, Amazon (incluindo links encurtados amzn.to) e Shopee')
         }

         let productData
         switch (site) {
                  case 'mercadolivre':
                           productData = await scrapeMercadoLivre(resolvedUrl)
                           break
                  case 'amazon':
                           productData = await scrapeAmazon(resolvedUrl)
                           break
                  case 'shopee':
                           productData = await scrapeShopee(resolvedUrl)
                           break
                  default:
                           throw new Error(`Scraper não implementado para: ${site}`)
         }

         productData.url = originalUrl

         return productData
}

