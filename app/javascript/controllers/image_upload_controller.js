import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hint"]

  connect() {
    this.inputTarget.addEventListener("change", this.validateFileSize.bind(this))
  }

  validateFileSize(event) {
    const file = event.target.files[0]
    if (file) {
      const maxSize = 5 * 1024 * 1024 // 5MB in bytes
      if (file.size > maxSize) {
        alert("File size should be less than 5MB")
        event.target.value = "" // Clear the input
        this.updateHint("File too large. Please select a file smaller than 5MB.", "error")
      } else {
        this.updateHint("File accepted", "success")
      }
    }
  }

  updateHint(message, type) {
    if (this.hasHintTarget) {
      this.hintTarget.textContent = message
      this.hintTarget.className = `form-hint ${type === "error" ? "error" : "success"}`
    }
  }
}
