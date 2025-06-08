pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin_all_from(
  ActionValidator::Engine.root.join("app/javascript/action_validator/controllers"),
  under: "controllers/action_validator",
  to: "action_validator/controllers"
)
