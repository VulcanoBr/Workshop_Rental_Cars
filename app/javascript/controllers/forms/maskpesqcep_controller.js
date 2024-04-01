import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="maskpesqcep"
export default class extends Controller {
  
  static targets = [ "inputZipCode", "logradouroText", "numeroText", "complementoText", "bairroText", 
                      "cidadeText", "estadoText" ]

  connect() {
  }

  addMaskToZipCodeFields() {
    this.inputZipCodeTarget.value = this.inputZipCodeTarget.value
        .replace(/\D/g, "") // Remove tudo o que não é dígito
        .replace(/^(\d{5})(\d{3})/, "$1-$2") // Formata como CEP
  }

  consultarCEP() {
    this.limparFormulario();
    let cep = this.inputZipCodeTarget.value
    // usando Fetch API
    fetch(`https://viacep.com.br/ws/${cep}/json/`)
        .then(response => response.json())
        .then(data => {
        // Aqui você pode manipular a resposta da API e realizar as ações desejadas
            if (data.erro) {
                this.logradouroTextTarget.value = 'Cep Inválido !!!!'
                return
            }
          
            this.logradouroTextTarget.value = data.logradouro
            this.bairroTextTarget.value = data.bairro
            this.cidadeTextTarget.value = data.localidade
            this.estadoTextTarget.value = data.uf
            this.numeroTextTarget.focus()
            
        })
        .catch(error => {
          this.logradouroTextTarget.value = 'CEP incorreto !!!'
              
        })
  }

  limparFormulario() {
    this.logradouroTextTarget.value = ""
    this.bairroTextTarget.value = ""
    this.cidadeTextTarget.value = ""
    this.estadoTextTarget.value = ""
    this.numeroTextTarget.value = ""
    this.complementoTextTarget.value = ""
  }



}
