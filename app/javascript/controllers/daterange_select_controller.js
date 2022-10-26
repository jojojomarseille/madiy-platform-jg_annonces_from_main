import { Controller } from "stimulus"
import queryString from "query-string"
// import debounce from "underscore/modules/debounce"

import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = [ "range" ]

  connect() {
    // const debounced = debounce(this.onPriceChange, 250)
    this.rangeTarget.addEventListener("daterangepicked", this.onRangeChange.bind(this))
  }

  clear() {
    const event = new CustomEvent("daterangepicked", { detail: { from: null, to: null } })
    this.rangeTarget.dispatchEvent(event)
  }

  onRangeChange(evt) {
    const from = evt.detail.from
    const to = evt.detail.to
    const location = window.location
    const search = queryString.parse(location.search)

    search["q[events_end_time_lteq]"] = to
    search["q[events_start_time_gteq]"] = from
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
