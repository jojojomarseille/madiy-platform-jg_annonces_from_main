
import { Controller } from "stimulus"
import { DirectUpload } from "@rails/activestorage"

export default class extends Controller {
  static targets = ["input2", "image"]

  event() {
    if (this._event == undefined) {
      this._event = document.createEvent("CustomEvent")
      this._event.initCustomEvent("instant-uploaded", true, true, null)
    }
    return this._event
  }

  changed() {
    Array.from(this.input2Target.files).forEach(file => {
      const upload = new DirectUpload(file, this.postURL())
      upload.create((error, blob) => {
        this.hiddenInput().value = blob.signed_id
        // this.input2Target.type = "hidden"
        this.imageTarget.src = `${this.getURL()}/${blob.signed_id}/${blob.filename}`
        this.imageTarget.dispatchEvent(this.event())
      })
    })
  }

  hiddenInput() {
    if (this._hiddenInput2 == undefined ) {
      this._hiddenInput2 = document.createElement('input2')
      this._hiddenInput2.name = this.input2Target.name
      this._hiddenInput2.type = "hidden"
      this.input2Target.parentNode.insertBefore(this._hiddenInput2, this.input2Target.nextSibling)
    }
    return this._hiddenInput2
  }

  postURL() {
    return '/rails/active_storage/direct_uploads'
  }

  getURL() {
    return '/rails/active_storage/blobs'
  }
}