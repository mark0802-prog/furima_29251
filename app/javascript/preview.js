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

    const inputHTML = document.createElement("input")
    inputHTML.setAttribute("id", `item_image_${imageElementNum}`)
    inputHTML.setAttribute("name", "item[images][]")
    inputHTML.setAttribute("type", "file")

    imageElement.appendChild(blobImage)
    itemPreview.appendChild(imageElement)
    itemPreview.appendChild(inputHTML)

    inputHTML.addEventListener("change", (e) => {
      // const imageContent = document.querySelector("#item-preview img")
      // if (imageContent) {
      //   imageContent.remove()
      // }
  
      file = e.target.files[0]
      blob = URL.createObjectURL(file)

      createImageHTML(blob)
    })
  }

  itemImage.addEventListener("change", (e) => {
    // const imageContent = document.querySelector("#item-preview img")
    // if (imageContent) {
    //   imageContent.remove()
    // }

    const file = e.target.files[0]
    const blob = URL.createObjectURL(file)

    createImageHTML(blob)

  })
}

addEventListener("DOMContentLoaded", preview)
