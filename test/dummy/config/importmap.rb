# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin '@rails/actioncable', to: 'https://ga.jspm.io/npm:@rails/actioncable@7.0.4-2/app/assets/javascripts/actioncable.esm.js'
pin 'ramda', to: 'https://ga.jspm.io/npm:ramda@0.28.0/es/index.js'

pin_all_from 'app/javascript/controllers', under: 'controllers'
pin_all_from 'app/javascript/channels', under: 'channels'
