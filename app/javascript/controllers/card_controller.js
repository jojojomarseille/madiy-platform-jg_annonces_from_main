import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    this.element.querySelector("input[name='payment[screen_height]'").value = window.screen.height
    this.element.querySelector("input[name='payment[screen_width]'").value = window.screen.width
    this.element.querySelector("input[name='payment[color_depth]'").value = window.screen.colorDepth
    this.element.querySelector("input[name='payment[java_enabled]'").value = navigator.javaEnabled()
  }
}
