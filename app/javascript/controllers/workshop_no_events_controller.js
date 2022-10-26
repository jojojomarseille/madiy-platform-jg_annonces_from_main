import { Controller } from "stimulus"
import moment from "moment"

export default class extends Controller {
  static targets = [ "template", "eventElement", "priceSeats", "totalPrice" ]

  connect() {
    this.seatsLeft = parseInt(this.data.get("seatsLeft"))
    this.totalPrice = 0
  }

  refreshTotalPrice(evt) {
    this.totalPrice = this.priceSeatsTargets.reduce((total, priceTarget) => {
      const number = parseInt(priceTarget.closest("div").querySelector("input.input-cpt").value)
      if (number <= 0) return total

      return total + (number * parseInt(priceTarget.dataset.price))
    }, 0)

    this.totalPriceTarget.innerText = `${this.totalPrice / 100.0}€`
  }

  showSeatsLeft(seats) {
    if (seats === 0) return "Il ne reste plus de places pour cette date"
    if (seats === 1) return "Il reste <strong>1</strong> place libre"

    return `Il reste <strong>${seats}</strong> places libres`
  }

  checkSeats(evt) {
    const total = this.priceSeatsTargets.reduce((prev, curr) => prev + (parseInt(curr.dataset.value) * parseInt(curr.value)), 0)

    if (total > this.seatsLeft) {
      alert("L'atelier ne dispose pas d'assez de places")
      const el = evt.currentTarget.closest("div").querySelector("input.input-cpt")
      el.value -= 1
    }
  }
}
