# ActionValidator

ActionValidator is a Rails engine that provides a simple way to perform dynamic client and server side validations
for your Rails forms.

It leverages native HTML5 validations by default and will only perform server side validations if the HTML5 validation
passes.

Behind the scenes, ActionValidator uses ActionCable to perform the server side validations. Any validations that exist
on your model will be automatically validated on the server side, and if there are any errors, they will be returned
to the client and displayed in the appropriate form field.

## Usage

Usage of this gem is very straightforward. There are two helper methods that you can use to render your forms.

### validator_form_for

This is the same as the standard Rails `form_for` helper, but it ensures your form uses the `ActionValidator::FormBuilder`
to build your forms and automatically adds all of the necessary attributes to the form.

If you have your own custom form builder, make sure to inherit from `ActionValidator::FormBuilder` and set that as
your default builder in your `application_controller.rb` file.

Also be sure to call `super` in any form builder methods that you override, otherwise you will not get the necessary
attributes added to your form.

### validator_form_with

This is the same as the standard Rails `form_with` helper and provides the same functionality as `validator_form_for`.

### validator_error

This helper method will render a div with the correct Stimulus data attributes on it so that errors can be displayed
on your form.

## Requirements

All of the JavaScript for ActionValidator is shipped with the gem and currently only supports integration when using
Importmaps.

## Example

Check the [dummy app](https://github.com/dphaener/action_validator/tree/main/test/dummy) for a working example of how the gem can be used.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "action_validator"
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install action_validator
```

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
