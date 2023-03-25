import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer";

export default class extends Controller {
  static targets = ['submit', 'input', 'error', 'baseErrors'];
  static values = { modelName: String };

  connect() {
    console.log('Connected to form controller');
    this.inputs = {};
    this.channel = consumer.subscriptions.create('ActionValidator::FormChannel', {
      connected: this.#cableConnected.bind(this),
      disconnected: this.#cableDisconnected.bind(this),
      received: this.#cableReceived.bind(this),
    });

    this.remoteValidatableInputs = []
    for (const input of this.element.elements) {
      if (input.dataset.remoteValidate === 'true') this.remoteValidatableInputs.push(input);
    }

    this.#disableSubmit();
  }

  validateForm() {
    if (this.#formValid()) {
      this.#enableSubmit();
    } else {
      this.#disableSubmit();
    }
  }

  validate(ev) {
    const { target: { dataset: { remoteValidate } } } = ev;
    ev.target.dataset.isDirty = true;

    if (remoteValidate === 'true') {
      this.channel.perform('validate', this.#serializeForm());
    } else {
      this.validateInput(ev.target);
      this.validateForm();
    }
  }

  validateInput(input) {
    const isValid = input.checkValidity();
    const errorElement = this.errorTargets.find(target => input.dataset.attribute === target.dataset.attribute);

    if (isValid) {
      errorElement.innerHTML = '';
      input.dataset.valid = true;
    } else {
      errorElement.innerHTML = input.validationMessage;
      input.dataset.valid = false;
    }
  }

  debouncedValidate(ev) {
    clearTimeout(this.timeout);

    this.timeout = setTimeout(this.validate.bind(this, ev), 500);
  }

  #serializeForm() {
    const formData = new FormData(this.element);
    const data = {};

    for (const [name, value] of formData) { data[name] = value; }

    return data;
  }

  #formValid() {
    return this.inputTargets.every(element => element.dataset.valid === 'true');
  }

  #cableReceived(data) {
    const { baseErrors, modelErrors } = data;

    if (this.hasBaseErrorsTarget) {
      if (baseErrors.length > 0) {
        this.baseErrorsTarget.style.display = 'block';
        this.baseErrorsTarget.innerHTML = globalErrors;
      } else {
        this.baseErrorsTarget.style.display = 'hidden';
        this.baseErrorsTarget.innerHTML = '';
      }
    }

    this.remoteValidatableInputs.forEach(inputElement => {
      if (inputElement.dataset.isDirty !== 'true') return;

      inputElement.setCustomValidity('');
      const attributeName = inputElement.dataset.attribute;
      const errorElement = this.errorTargets.find(target => attributeName === target.dataset.attribute);
      const isValid = inputElement.checkValidity();

      if (!isValid) {
        errorElement.innerHTML = inputElement.validationMessage;
        inputElement.dataset.valid = false;
      } else if (modelErrors.hasOwnProperty(attributeName)) {
        errorElement.innerHTML = modelErrors[attributeName].join(', ');
        inputElement.setCustomValidity(modelErrors[attributeName].join(', '));
        inputElement.dataset.valid = false;
      } else {
        errorElement.innerHTML = '';
        inputElement.setCustomValidity('');
        inputElement.dataset.valid = true;
      }
    });

    this.validateForm();
  }

  #disableSubmit() {
    if (this.hasSubmitTarget) this.submitTarget.setAttribute('disabled', true);
  }

  #enableSubmit() {
    if (this.hasSubmitTarget) this.submitTarget.removeAttribute('disabled');
  }

  #cableConnected() {
    console.log('Connected to cable');
  }

  #cableDisconnected() {
    console.log('Disconnected from cable');
  }
}

