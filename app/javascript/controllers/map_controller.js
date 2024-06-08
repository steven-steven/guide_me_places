import { Controller } from "@hotwired/stimulus"
import L from 'leaflet'
import "leaflet.markercluster"
import boundary from 'idn_boundaries'
import { get } from "@rails/request.js"

export default class extends Controller {
  initialize() {
    const isMobile = window.matchMedia("(max-width: 768px)").matches;
    const zoomLevel = isMobile ? 3.6 : 4.6

    this.map = L.map('map', {
      maxBounds: [
        [-11.554099, 92.902008],
        [7.864076, 145.115198]
      ],
      zoomSnap: 1,
      zoomDelta: 2
    }).setView([-2.600029, 118.015776], zoomLevel);

    this.highlightFeature = this.highlightFeature.bind(this);
  }

  connect() {
    L.tileLayer('https://tiles.stadiamaps.com/tiles/stamen_terrain/{z}/{x}/{y}{r}.{ext}', {
      minZoom: 0,
      maxZoom: 18,
      // attribution: '&copy; <a href="https://www.stadiamaps.com/" target="_blank">Stadia Maps</a> &copy; <a href="https://www.stamen.com/" target="_blank">Stamen Design</a> &copy; <a href="https://openmaptiles.org/" target="_blank">OpenMapTiles</a> &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      ext: 'png'
    }).addTo(this.map);

    this.setBoundaries()
    this.addInfoControl()
    const locationData = JSON.parse(this.element.dataset.mapLocations)
    this.setMarkers(locationData)

    this.map.on('click', function (e) {
      console.log("You clicked the map at " + e.latlng.toString())
    });
  }

  setMarkers = (locations) => {
    const markers = new L.MarkerClusterGroup({showCoverageOnHover: false});

    locations.forEach((location) => {
      const marker = L.marker([location.lat, location.long], {icon: this.markerIcons(location.emoji)})
        .on('click', (e) => {
          this.info.update(location.place);
          get(`/place_details`, { query: { location: location.place, iframe1: location.iframe1 }, responseKind: "turbo-stream" })
        });

      markers.addLayer(marker);
    })

    this.map.addLayer(markers);
  }

  markerIcons = (emoji) => (
    L.divIcon({
      className: 'custom-div-icon',
      html: `<div class='marker-pin'></div><i>${emoji}</i>`,
      iconSize: [30, 42],
      iconAnchor: [15, 42] // half of width + height
    })
  )

  addInfoControl = () => {
    this.info = L.control({ position: 'bottomleft' });

    this.info.onAdd = (map) => {
      this._div = L.DomUtil.create('div', 'info'); // div with class "info"
      this._div.style.fontSize = '10px';
      this.info.update();
      return this._div;
    };

    this.info.update = (label) => {
      this._div.innerHTML = '<h4>Region</h4>' +  (label ? `<b>${label}</b>` : 'Hover over a regency<br/> or click on a location pin');
    };

    this.info.addTo(this.map);
  }

  setBoundaries = () => {
    this.geojson = L.geoJson(boundary, {
      style: this.styleBoundaries,
      onEachFeature: this.onEachFeature
    })
    this.geojson.addTo(this.map);
  }

  onEachFeature = (feature, layer) => {
    layer.on({
      "mouseover": this.highlightFeature,
      "mouseout": this.resetHighlight,
      "click": this.zoomToFeature
    });
  }

  styleBoundaries = (features) => {
    return {
      fillColor: '#FFF',
      weight: 2,
      opacity: 0.1,
      color: 'white',
      dashArray: '3',
      fillOpacity: 0.1
    };
  }

  highlightFeature = (e) => {
    var layer = e.target;

    layer.setStyle({
        weight: 5,
        color: '#666',
        dashArray: '',
        fillOpacity: 0.7
    });

    layer.bringToFront();
    this.info.update(layer.feature.properties.shapeName);
  }

  resetHighlight = (e) => {
    this.geojson.resetStyle(e.target);
    this.info.update();
  }

  zoomToFeature = (e) => {
    this.map.fitBounds(e.target.getBounds());
  }

}