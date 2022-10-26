import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "link" ]

  onClick(evt) {
    this.linkTarget.click()
  }
}
