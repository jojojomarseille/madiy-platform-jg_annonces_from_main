import { Controller } from "stimulus"
import queryString from "query-string"

import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = [ "select" ]
  connect() {
  }

  clearSelect() {
    this.selectTarget.selectedIndex = 0
    this.onSelectChange()
  }

  onSelectChange() {
    const index = this.selectTarget.selectedIndex
    const zone = this.selectTarget.options[index].value
    const location = window.location
    const search = queryString.parse(location.search)

    search["q[zone_id_eq]"] = zone
    search["page"] = 1
    const url = `${location.pathname}?${queryString.stringify(search)}`

    Rails.ajax({
      url: url,
      type: "GET",
      dataType: "script",
      accept: "script",
      success: () =>{
        history.replaceState(null, "", url)
      }
    })
  }
}
