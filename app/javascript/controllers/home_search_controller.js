import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "link", "select" ]
  connect() {
    this.path = this.data.get("path")
    this.onSelectChange()
  }

  onSelectChange() {
    const id = this.selectTarget.options[this.selectTarget.selectedIndex].value
    this.setLink(id)
  }

  setLink(id) {
    this.linkTarget.href = `${this.path}?q%5Bcategory_id_eq%5D=${id}`
  }
}
