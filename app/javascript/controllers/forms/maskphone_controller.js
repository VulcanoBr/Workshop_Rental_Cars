import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="mask-phone"
export default class extends Controller {

  static targets = [ "inputPhone" ]

  connect() {
  }

  addMaskToPhoneFields() {
    var input_phone = this.inputPhoneTarget.value
    console.log("Input target:", input_phone);
    let value_phone = input_phone.replace(/\D/g, '')
    let mask
    
    if (value_phone.length <= 10) {
      mask = value_phone.replace(/(\d{2})(\d)/, "($1) $2").replace(/(\d{4})(\d)/, "$1-$2")
    } else {
      mask = value_phone.replace(/(\d{2})(\d)/, "($1) $2").replace(/(\d{5})(\d)/, "$1-$2")
    }

    if (mask.length > 15) {
      // Atualiza o valor do input para o último estado válido
      this.inputPhoneTarget.value = mask.slice(0, 15)
    } else {
      this.inputPhoneTarget.value = mask
    }
  }

}
