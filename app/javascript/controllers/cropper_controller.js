import { Controller } from "stimulus"
import Cropper from "cropperjs"
import "cropperjs/dist/cropper.css"

export default class extends Controller {
  static targets = ["image"]
  static values = { model: String }

  changed() {
    let _this = this
    new Cropper(this.imageTarget, {
      dragMode: 'move',
      aspectRatio: 3/2,
      center: false,
      highlight: false,
      cropBoxMovable: false,
      cropBoxResizable: false,
      toggleDragModeOnDblclick: false,
      crop(event) {
        _this.crop_x().value = event.detail.x
        _this.crop_y().value = event.detail.y
        _this.crop_width().value = event.detail.width
        _this.crop_height().value = event.detail.height
      }
    })
  }

  crop_x() {
    if (this._crop_x == undefined) {
      this._crop_x = document.createElement("input")
      this._crop_x.name = `${this.modelValue}[crop_x]`
      this._crop_x.type = "hidden"
      this.imageTarget.parentNode.insertBefore(this._crop_x, this.imageTarget.nextSibling)
    }
    return this._crop_x
  }

  crop_y() {
    if (this._crop_y == undefined) {
      this._crop_y = document.createElement("input")
      this._crop_y.name = `${this.modelValue}[crop_y]`
      this._crop_y.type = "hidden"
      this.imageTarget.parentNode.insertBefore(this._crop_y, this.imageTarget.nextSibling)
    }
    return this._crop_y
  }

  crop_width() {
    if (this._crop_width == undefined) {
      this._crop_width = document.createElement("input")
      this._crop_width.name = `${this.modelValue}[crop_width]`
      this._crop_width.type = "hidden"
      this.imageTarget.parentNode.insertBefore(this._crop_width, this.imageTarget.nextSibling)
    }
    return this._crop_width
  }

  crop_height() {
    if (this._crop_height == undefined) {
      this._crop_height = document.createElement("input")
      this._crop_height.name = `${this.modelValue}[crop_height]`
      this._crop_height.type = "hidden"
      this.imageTarget.parentNode.insertBefore(this._crop_height, this.imageTarget.nextSibling)
    }
    return this._crop_height
  }
  
}