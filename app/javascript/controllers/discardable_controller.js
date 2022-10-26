import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    window.setTimeout(this.hideElement.bind(this), 5000)
  }

  discard() {
    this.hideElement()
  }

  hideElement() {
    this.element.remove()
  }
}
