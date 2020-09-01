const calc = () => {
  const price_box = document.getElementById('item-price')
  const add_tax_price_box = document.getElementById('add-tax-price')
  const profit_box = document.getElementById('profit')

  if (price_box == null) {
    return null
  }
  else if (price_box.getAttribute('data_load') != null) {
    return null
  }

  price_box.setAttribute('data_load', 'true')

  price_box.addEventListener("input", (e) => {
    let price = parseInt(e.target.value)
    let add_tax_price = parseInt(price * 0.1)
    let profit = price - add_tax_price
    if (isNaN(add_tax_price)) {
      add_tax_price_box.innerHTML = 0
      profit_box.innerHTML = 0
    } else {
      add_tax_price_box.innerHTML = add_tax_price
      profit_box.innerHTML = profit
    }
  })
}

addEventListener("DOMContentLoaded", calc)