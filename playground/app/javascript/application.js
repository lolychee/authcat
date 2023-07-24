// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails


import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
import "./channels"
import * as WebAuthnJSON from "@github/webauthn-json"
window.WebAuthnJSON = WebAuthnJSON;

ActiveStorage.start()
