/**
 * Detecta o tipo de produto e gera frase dinâmica com emoji
 * @param {string} title - Título do produto
 * @returns {Object} - {phrase: string, emoji: string}
 */
export function generateDynamicPhrase(title) {
         if (!title) return { phrase: 'OFERTA IMPERDÍVEL!', emoji: '🔥' }

         const titleLower = title.toLowerCase()

         // edit to your needs
         const categories = [
                  {
                           keywords: ['caixa de som', 'som', 'speaker', 'boombox', 'soundbar', 'home theater', 'audio'],
                           emoji: '🔊',
                           phrases: [
                                    'SOM POTENTE COM PREÇO IMPERDÍVEL!',
                                    'O MELHOR SOM PELO MENOR PREÇO!',
                                    'QUALIDADE DE ÁUDIO EXCEPCIONAL!',
                                    'SOM PROFISSIONAL COM DESCONTO!'
                           ]
                  },
                  {
                           keywords: ['fone', 'headphone', 'headset', 'earphone', 'airpods'],
                           emoji: '🎧',
                           phrases: [
                                    'FONE DE OUVIDO COM PREÇO BOMBADO!',
                                    'AUDIÇÃO DE QUALIDADE COM DESCONTO!',
                                    'MELHOR FONE PELO MENOR PREÇO!',
                                    'ÁUDIO PREMIUM COM PREÇO ESPECIAL!'
                           ]
                  },
                  {
                           keywords: ['celular', 'smartphone', 'iphone', 'samsung', 'xiaomi', 'motorola'],
                           emoji: '📱',
                           phrases: [
                                    'CELULAR COM PREÇO IMBATÍVEL!',
                                    'SMARTPHONE TOP COM DESCONTO BOMBADO!',
                                    'MELHOR CELULAR PELO MENOR PREÇO!',
                                    'TECNOLOGIA DE PONTA COM PREÇO ESPECIAL!'
                           ]
                  },
                  {
                           keywords: ['notebook', 'laptop', 'computador', 'pc', 'macbook'],
                           emoji: '💻',
                           phrases: [
                                    'NOTEBOOK COM PREÇO IMPERDÍVEL!',
                                    'COMPUTADOR POTENTE COM DESCONTO!',
                                    'MELHOR NOTEBOOK PELO MENOR PREÇO!',
                                    'PERFORMANCE MÁXIMA COM PREÇO BOMBADO!'
                           ]
                  },
                  {
                           keywords: ['tv', 'televisão', 'televisao', 'smart tv', 'led', 'oled'],
                           emoji: '📺',
                           phrases: [
                                    'TV COM PREÇO IMBATÍVEL!',
                                    'SMART TV COM DESCONTO BOMBADO!',
                                    'MELHOR TV PELO MENOR PREÇO!',
                                    'IMAGEM DE QUALIDADE COM PREÇO ESPECIAL!'
                           ]
                  },
                  {
                           keywords: ['geladeira', 'refrigerador', 'freezer'],
                           emoji: '🧊',
                           phrases: [
                                    'GELADEIRA COM PREÇO IMPERDÍVEL!',
                                    'REFRIGERADOR TOP COM DESCONTO!',
                                    'MELHOR GELADEIRA PELO MENOR PREÇO!',
                                    'EFICIÊNCIA ENERGÉTICA COM PREÇO BOMBADO!'
                           ]
                  },
                  {
                           keywords: ['fogão', 'cooktop', 'forno'],
                           emoji: '🔥',
                           phrases: [
                                    'FOGÃO COM PREÇO IMBATÍVEL!',
                                    'COZINHA COMPLETA COM DESCONTO!',
                                    'MELHOR FOGÃO PELO MENOR PREÇO!',
                                    'QUALIDADE PROFISSIONAL COM PREÇO ESPECIAL!'
                           ]
                  },
                  {
                           keywords: ['máquina de lavar', 'lavadora', 'secadora'],
                           emoji: '🌀',
                           phrases: [
                                    'LAVADORA COM PREÇO IMPERDÍVEL!',
                                    'MÁQUINA DE LAVAR COM DESCONTO BOMBADO!',
                                    'MELHOR LAVADORA PELO MENOR PREÇO!',
                                    'EFICIÊNCIA MÁXIMA COM PREÇO ESPECIAL!'
                           ]
                  },
                  {
                           keywords: ['ar condicionado', 'ar-condicionado', 'split'],
                           emoji: '❄️',
                           phrases: [
                                    'AR CONDICIONADO COM PREÇO IMBATÍVEL!',
                                    'CLIMATIZAÇÃO COM DESCONTO BOMBADO!',
                                    'MELHOR AR PELO MENOR PREÇO!',
                                    'CONFORTO TOTAL COM PREÇO ESPECIAL!'
                           ]
                  },
                  {
                           keywords: ['tablet', 'ipad'],
                           emoji: '📱',
                           phrases: [
                                    'TABLET COM PREÇO IMPERDÍVEL!',
                                    'TABLET TOP COM DESCONTO BOMBADO!',
                                    'MELHOR TABLET PELO MENOR PREÇO!',
                                    'PORTABILIDADE COM PREÇO ESPECIAL!'
                           ]
                  },
                  {
                           keywords: ['smartwatch', 'relógio', 'watch', 'apple watch'],
                           emoji: '⌚',
                           phrases: [
                                    'SMARTWATCH COM PREÇO IMBATÍVEL!',
                                    'RELÓGIO INTELIGENTE COM DESCONTO!',
                                    'MELHOR SMARTWATCH PELO MENOR PREÇO!',
                                    'TECNOLOGIA NO PULSO COM PREÇO ESPECIAL!'
                           ]
                  },
                  {
                           keywords: ['videogame', 'console', 'playstation', 'xbox', 'nintendo', 'switch'],
                           emoji: '🎮',
                           phrases: [
                                    'CONSOLE COM PREÇO IMPERDÍVEL!',
                                    'VIDEOGAME TOP COM DESCONTO BOMBADO!',
                                    'MELHOR CONSOLE PELO MENOR PREÇO!',
                                    'DIVERSÃO GARANTIDA COM PREÇO ESPECIAL!'
                           ]
                  },
                  {
                           keywords: ['câmera', 'camera', 'filmadora', 'gopro'],
                           emoji: '📷',
                           phrases: [
                                    'CÂMERA COM PREÇO IMBATÍVEL!',
                                    'FOTOS PROFISSIONAIS COM DESCONTO!',
                                    'MELHOR CÂMERA PELO MENOR PREÇO!',
                                    'QUALIDADE DE IMAGEM COM PREÇO ESPECIAL!'
                           ]
                  },
                  {
                           keywords: ['ferramenta', 'furadeira', 'parafusadeira', 'serra', 'esmerilhadeira'],
                           emoji: '🔧',
                           phrases: [
                                    'FERRAMENTA PROFISSIONAL COM PREÇO BOMBADO!',
                                    'QUALIDADE INDUSTRIAL COM DESCONTO!',
                                    'MELHOR FERRAMENTA PELO MENOR PREÇO!',
                                    'TRABALHO FACILITADO COM PREÇO ESPECIAL!'
                           ]
                  },
                  {
                           keywords: ['bicicleta', 'bike', 'mountain bike'],
                           emoji: '🚲',
                           phrases: [
                                    'BICICLETA COM PREÇO IMPERDÍVEL!',
                                    'BIKE TOP COM DESCONTO BOMBADO!',
                                    'MELHOR BICICLETA PELO MENOR PREÇO!',
                                    'PEDAL COM QUALIDADE E PREÇO ESPECIAL!'
                           ]
                  }
         ]

         for (const category of categories) {
                  for (const keyword of category.keywords) {
                           if (titleLower.includes(keyword)) {
                                    const randomIndex = Math.floor(Math.random() * category.phrases.length)
                                    return {
                                             phrase: category.phrases[randomIndex],
                                             emoji: category.emoji
                                    }
                           }
                  }
         }

         // generic phrases if no category is found
         const genericPhrases = [
                  'MAIS BARATA QUE A ANTERIOR!',
                  'OFERTA IMPERDÍVEL COM DESCONTO BOMBADO!',
                  'MELHOR PREÇO DO MERCADO!',
                  'PROMOÇÃO ESPECIAL COM PREÇO IMBATÍVEL!',
                  'OFERTA EXCLUSIVA COM DESCONTO MÁXIMO!',
                  'PREÇO BOMBADO PARA VOCÊ!',
                  'ECONOMIA GARANTIDA COM ESTE PREÇO!',
                  'OFERTA LIMITADA COM DESCONTO ESPECIAL!'
         ]

         const randomIndex = Math.floor(Math.random() * genericPhrases.length)
         return {
                  phrase: genericPhrases[randomIndex],
                  emoji: '🔥'
         }
}

/**
 * @param {string} title - Título do produto
 * @returns {string} - Marca extraída ou string vazia
 */
export function extractBrand(title) {
         if (!title) return ''

         const brands = [
                  'JBL', 'Sony', 'Samsung', 'LG', 'Apple', 'Xiaomi', 'Motorola', 'Nokia',
                  'Dell', 'HP', 'Lenovo', 'Acer', 'Asus', 'MSI', 'Razer',
                  'Philips', 'Panasonic', 'Electrolux', 'Brastemp', 'Consul',
                  'Bosch', 'Black+Decker', 'Makita', 'Dewalt', 'Stanley',
                  'Nike', 'Adidas', 'Puma', 'Reebok', 'Olympikus',
                  'Canon', 'Nikon', 'GoPro', 'DJI',
                  'PlayStation', 'Xbox', 'Nintendo', 'Steam'
         ]

         const titleUpper = title.toUpperCase()

         for (const brand of brands) {
                  if (titleUpper.includes(brand.toUpperCase())) {
                           return brand
                  }
         }

         const words = title.split(' ')
         const brandWord = words.find(word =>
                  word.length > 2 &&
                  word === word.toUpperCase() &&
                  /^[A-Z]+$/.test(word)
         )

         return brandWord || ''
}

