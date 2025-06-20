import { Controller } from "@hotwired/stimulus";
import consumer from "channels/consumer";

export default class extends Controller {
  static targets = ["submit", "input", "error"];
  static values = { modelName: String };

  connect() {
    this.remoteValidatableInputs = [];
    this.channel = consumer.subscriptions.create(
      "ActionValidator::FormChannel",
      {
        connected: this.#cableConnected.bind(this),
        disconnected: this.#cableDisconnected.bind(this),
        received: this.#cableReceived.bind(this),
      },
    );

    this.inputTargets.forEach((input) => {
      if (input.dataset.remoteValidate === "true")
        this.remoteValidatableInputs.push(input);
    });

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
    const inputElement = ev.target;
    const {
      dataset: { remoteValidate },
    } = inputElement;
    this.#checkAndSetDirty(inputElement);
    if (inputElement.dataset.isDirty === "false") return;

    const htmlValid = this.validateInput(ev.target);

    if (remoteValidate === "true" && htmlValid) {
      this.channel.perform("validate", { formData: this.#serializeForm() });
    } else {
      this.validateForm();
    }
  }

  validateInput(input) {
    input.setCustomValidity("");
    const isValid = input.checkValidity();
    const errorElement = this.errorTargets.find(
      (target) => input.dataset.attribute === target.dataset.attribute,
    );

    if (isValid) {
      if (errorElement) errorElement.innerHTML = "";
      input.dataset.valid = true;

      return true;
    } else {
      if (errorElement) errorElement.innerHTML = input.validationMessage;
      input.dataset.valid = false;

      return false;
    }
  }

  debouncedValidate(ev) {
    clearTimeout(this.timeout);

    this.timeout = setTimeout(this.validate.bind(this, ev), 500);
  }

  #checkAndSetDirty(element) {
    const currentlyDirty = element.dataset.isDirty;
    const value = element.value;

    if (currentlyDirty === "false" && value) element.dataset.isDirty = true;
  }

  #serializeForm() {
    const formData = new FormData(this.element);
    const queryString = new URLSearchParams(formData).toString();

    return queryString;
  }

  #formValid() {
    return this.inputTargets.every(
      (element) => element.dataset.valid === "true",
    );
  }

  // TODO: Add an option to just show errors globally somewhere and not next to each input. We should support arbitrary
  //       error messages that map to some sort of error container with a `errorTarget` that maps to the attribute name.
  //
  #cableReceived(data) {
    const { errors } = data;

    this.remoteValidatableInputs.forEach((inputElement) => {
      if (inputElement.dataset.isDirty === "false") return;

      const attributeName = inputElement.dataset.attribute;
      const error = errors[attributeName];
      const errorElement = this.errorTargets.find(
        (target) => attributeName === target.dataset.attribute,
      );
      if (!errorElement) {
        Stimulus.logDebugActivity(
          `No error element found for input with attribute '${attributeName}'. Cannot add error.`,
          "cableReceived",
        );
        return;
      }

      if (error) {
        errorElement.innerHTML = errors[attributeName];
        inputElement.setCustomValidity(errors[attributeName]);
        inputElement.dataset.valid = false;
      } else {
        errorElement.innerHTML = "";
        inputElement.setCustomValidity("");
        inputElement.dataset.valid = true;
      }
    });

    this.validateForm();
  }

  #disableSubmit() {
    if (this.hasSubmitTarget) {
      this.submitTarget.setAttribute("disabled", true);
    } else {
      Stimulus.logDebugActivity(
        "No submit target found for form",
        "disableSubmit",
      );
    }
  }

  #enableSubmit() {
    if (this.hasSubmitTarget) {
      this.submitTarget.removeAttribute("disabled");
    } else {
      Stimulus.logDebugActivity(
        "No submit target found for form",
        "enableSubmit",
      );
    }
  }

  #cableConnected() {
    Stimulus.logDebugActivity(
      "ActionValidator connected to cable",
      "cableConnected",
    );
  }

  #cableDisconnected() {
    Stimulus.logDebugActivity(
      "ActionValidator disconnected from cable",
      "cableDisconnected",
    );
  }
}
