import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "shippingForm", "creatorAddress", "options", "output" ]

  connect() {
    const choice = this.optionsTargets.find(option => option.checked)
    this.renderChoice(choice.value)
  }

  onChange(evt) {
    this.renderChoice(evt.target.value)
  }

  renderChoice(choice) {
    this.outputTarget.innerHTML = this.choices()[choice]
  }

  choices() {
    return {
      click_and_collect: this.creatorAddressTarget.innerHTML,
      shipping: this.shippingFormTarget.innerHTML,
    }
  }
}
