import { Controller } from "stimulus"
import mangoPay from "mangopay-cardregistration-js-kit"
import Rails from "@rails/ujs"

export default class extends Controller {
  connect() {
    this.initMango()
  }

  initMango() {
    mangoPay.cardRegistration.baseURL = this.data.get("cardRegistrationBaseUrl")
    mangoPay.cardRegistration.clientId = this.data.get("clientId")

    mangoPay.cardRegistration.init({
      cardRegistrationURL: this.data.get("url"),
      preregistrationData: this.data.get("preregistrationData"),
      accessKey: this.data.get("accessKey"),
      Id: this.data.get("id"),
    })
  }

  submitCardRegistration(event) {
    event.preventDefault()

    const expiration = `${document.getElementById("payment_expiration_2i").value}${document.getElementById("payment_expiration_1i").value.slice(-2)}`.padStart(4, "0")
    const apiUrl = event.currentTarget.getAttribute('data-mango-api-url')

    const cardData = {
      cardNumber: document.getElementById("payment_card_number").value,
      cardExpirationDate: expiration,
      cardCvx: document.getElementById("payment_cvc").value,
      cardType: "CB_VISA_MASTERCARD",
    }

    mangoPay.cardRegistration.registerCard(
      cardData,
      function (res) {
        const formData = new FormData()
        formData.append("payment[card_id]", res["CardId"])
        formData.append("payment[screen_height]", window.screen.height)
        formData.append("payment[screen_width]", window.screen.width)
        formData.append("payment[color_depth]", window.screen.colorDepth)
        formData.append("payment[java_enabled]", navigator.javaEnabled())

        Rails.ajax({
          type: "post",
          url: apiUrl,
          data: formData
        })
      },
      function (res) {
        document.getElementById("messageErreur").innerText = res["ResultMessage"]
      }
    )
  }
}
