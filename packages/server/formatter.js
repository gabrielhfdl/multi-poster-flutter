import { generateDynamicPhrase, extractBrand } from './productPhrases.js'

export function formatPost(productData, coupon = '', customPhrase = null, customEmoji = null) {
  const { title, price, url, site } = productData

  const { phrase: generatedPhrase, emoji: generatedEmoji } = generateDynamicPhrase(title)
  const brand = extractBrand(title)

  const finalPhrase = customPhrase || generatedPhrase
  const finalEmoji = customEmoji || generatedEmoji

  let header = ''
  let couponText = ''
  let hashtags = ''

  switch (site) {
    case 'mercadolivre':
      if (brand) {
        header = `${finalEmoji} ${finalPhrase} ${brand.toUpperCase()}`
      } else {
        header = `${finalEmoji} ${finalPhrase}`
      }

      if (coupon) {
        couponText = `\n🛒 CUPOM MERCADO LIVRE : ${coupon.toUpperCase()}`
      }
      hashtags = '#blackfriday #cupom #ml #mercado #livre'
      break
    case 'amazon':
      header = `${finalEmoji} ${finalPhrase}`
      if (coupon) {
        couponText = `\n🛒 CUPOM AMAZON : ${coupon.toUpperCase()}`
      }
      hashtags = '#amazon #ofertas #cupom'
      break
    case 'shopee':
      header = `${finalEmoji} ${finalPhrase}`
      if (coupon) {
        couponText = `\n🛒 CUPOM SHOPEE : ${coupon.toUpperCase()}`
      }
      hashtags = '#shopee #ofertas #cupom'
      break
    default:
      header = `${finalEmoji} ${finalPhrase}`
      if (coupon) {
        couponText = `\n🛒 CUPOM : ${coupon.toUpperCase()}`
      }
      hashtags = '#ofertas #cupom'
  }

  const formattedTitle = title
    .split(' ')
    .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
    .join(' ')

  const formattedText = `${header}\n\n${formattedTitle}\n\n${price}${couponText}\n\n${url}\n\n${hashtags}`

  let twitterText = `${header}\n\n${formattedTitle}\n\n${price}${couponText}\n\n${url}\n\n${hashtags}`

  if (twitterText.length > 280) {
    const maxLength = 250
    twitterText = `${header}\n\n${formattedTitle}\n\n${price}${couponText}\n\n${url}`

    if (twitterText.length > maxLength) {
      const titleMaxLength = maxLength - (header.length + price.length + couponText.length + url.length + 20)
      const shortTitle = formattedTitle.length > titleMaxLength
        ? formattedTitle.substring(0, titleMaxLength - 3) + '...'
        : formattedTitle
      twitterText = `${header}\n\n${shortTitle}\n\n${price}${couponText}\n\n${url}`

      if (twitterText.length > 280) {
        twitterText = `${header}\n${shortTitle}\n\n${price}${couponText}\n\n${url}`
      }
    }
  }

  return {
    formattedText,
    twitterText,
    hashtags,
    generatedPhrase,
    generatedEmoji
  }
}


