# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "leaflet" # @1.9.4
pin "leaflet-providers" # @2.0.0
pin "idn_boundaries"

# pin "leaflet", to: "https://ga.jspm.io/npm:leaflet@1.7.1/dist/leaflet-src.js"
# pin "leaflet-providers", to: "https://ga.jspm.io/npm:leaflet-providers@1.13.0/leaflet-providers.js"
pin "leaflet.markercluster" # @1.5.3
