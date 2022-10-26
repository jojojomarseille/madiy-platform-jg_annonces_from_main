import { Controller } from "stimulus"
import moment from "moment"

export default class extends Controller {
  static targets = [ "template", "eventElement", "priceSeats", "totalPrice" ]

  connect() {
    this.seatsLeft = 0;
    this.totalPrice = 0;
    this.events = JSON.parse(this.data.get("events"))
    this.setEvent(this.data.get("initial"))
  }

  eventSelected(evt) {
    const id = evt.currentTarget.dataset['eventId']
    this.setEvent(id)
  }

  refreshTotalPrice(evt) {
    this.totalPrice = this.priceSeatsTargets.reduce((total, priceTarget) => {
      const number = parseInt(priceTarget.closest("div").querySelector("input.input-cpt").value)
      if (number <= 0) return total

      return total + (number * parseInt(priceTarget.dataset.price))
    }, 0)

    this.totalPriceTarget.innerText = `${this.totalPrice / 100.0}€`
  }

  setEvent(id) {
    const event = this.events.find(event => event.id === id)
    this.seatsLeft = event.seats_left
    this.priceSeatsTargets.forEach(input => input.value = 0)

    const html = this.templateTarget.innerHTML
      .replace("/START_TIME/", moment(event.start_time).format("H[h]mm"))
      .replace("/END_TIME/", moment(event.end_time).format("H[h]mm"))
      .replace("/SEATS_LEFT/", this.showSeatsLeft(this.seatsLeft))

    this.eventElementTarget.innerHTML = html
    this.totalPriceTarget.innerText = ""
  }

  showSeatsLeft(seats) {
    if (seats === 0) return "Il ne reste plus de places pour cette date"
    if (seats === 1) return "Il reste <strong>1</strong> place libre"
    if (seats > 2) return "Il reste des places"

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
