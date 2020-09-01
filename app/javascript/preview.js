const preview = () => {
  const itemPreview = document.getElementById("item-preview")
  const itemImage = document.getElementById("item-image")

  if (itemImage == null) {
    return null
  }

  const createImageHTML = (blob) => {
    const imageElement = document.createElement("div")
    imageElement.setAttribute("id", "image-element")
    let imageElementNum = document.querySelectorAll("#image-element").length

    const blobImage = document.createElement("img")
    blobImage.setAttribute("src", blob)
    blobImage.setAttribute("class", "item-preview")
    blobImage.setAttribute("id", `item_image_${imageElementNum}`)

    const inputHTML = document.createElement("input")
    inputHTML.setAttribute("id", `item_image_${imageElementNum+1}`)
    inputHTML.setAttribute("name", "item[images][]")
    inputHTML.setAttribute("type", "file")

    imageElement.appendChild(blobImage)
    itemPreview.appendChild(imageElement)
    itemPreview.appendChild(inputHTML)

    inputHTML.addEventListener("change", (e) => {
  
      file = e.target.files[0]
      blob = URL.createObjectURL(file)
      const image_id = inputHTML.getAttribute("id")

      const imageContent = document.querySelector(`#image-element img[id='item_image_${imageElementNum+1}']`)
      if (imageContent) {
        changeImageHTML(blob, image_id)
      } else {
        createImageHTML(blob)
      }
    })
  }

  const changeImageHTML = (blob, image_id) => {
    const blobImage = document.querySelector(`#image-element img[id='${image_id}']`)
    blobImage.removeAttribute("src")
    blobImage.setAttribute("src", blob)
  }

  itemImage.addEventListener("change", (e) => {

    const file = e.target.files[0]
    const blob = URL.createObjectURL(file)

    const imageContent = document.querySelector("#image-element img[id='item_image_0']")
    if (imageContent) {
      changeImageHTML(blob, "item_image_0")
    } else {
      createImageHTML(blob)
    }
  })
}

addEventListener("DOMContentLoaded", preview)
