const preview = () => {
  const imgUpload = document.getElementById("item-preview")
  const itemImage = document.getElementById("item-image")

  if (itemImage == null) {
    return null
  }

  // const sakujyo = () => {
  //   const imageContent = document.getElementById("item-preview")
  //   if (imageContent) {
  //     imageContent.remove()
  //   }
  // }

  itemImage.addEventListener("change", (e) => {
    const imageContent = document.querySelector("#item-preview img")
    if (imageContent) {
      imageContent.remove()
    }

    const file = e.target.files[0]
    const blob = URL.createObjectURL(file)

    const imageElement = document.createElement("div")

    const blobImage = document.createElement("img")
    blobImage.setAttribute("src", blob)
    blobImage.setAttribute("class", "item-preview")

    imageElement.appendChild(blobImage)
    imgUpload.appendChild(imageElement)
  })
}

addEventListener("DOMContentLoaded", preview)
