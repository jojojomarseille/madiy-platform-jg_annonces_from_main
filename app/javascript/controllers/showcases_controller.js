import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    this.apiUrl = this.data.get("url")
    this.fetchContent()
  }

  async fetchContent() {
    await fetch(this.apiUrl)
      .then(response => response.text())
      .then(html => {
        this.element.innerHTML = html
        const event = new Event('carousel:load')
        document.dispatchEvent(event)
      })
  }
}
