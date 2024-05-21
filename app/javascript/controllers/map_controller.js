import { Controller } from "@hotwired/stimulus"
import L from 'leaflet'
import boundary from 'idn_boundaries'

export default class extends Controller {

  initialize() {
    const isMobile = window.matchMedia("(max-width: 768px)").matches;
    const zoomLevel = isMobile ? 3.6 : 4.8

    this.map = L.map('map', {
      maxBounds: [
        [-11.554099, 92.902008],
        [7.864076, 145.115198]
      ],
      zoomSnap: 0.25,
      zoomDelta: 2
    }).setView([-2.600029, 118.015776], zoomLevel);

    this.highlightFeature = this.highlightFeature.bind(this);
  }

  connect() {
    L.tileLayer('https://tiles.stadiamaps.com/tiles/stamen_terrain/{z}/{x}/{y}{r}.{ext}', {
      minZoom: 0,
      maxZoom: 18,
      attribution: '&copy; <a href="https://www.stadiamaps.com/" target="_blank">Stadia Maps</a> &copy; <a href="https://www.stamen.com/" target="_blank">Stamen Design</a> &copy; <a href="https://openmaptiles.org/" target="_blank">OpenMapTiles</a> &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      ext: 'png'
    }).addTo(this.map);

    const locationData = [{lat: -1.685247, long: 111.447739, emoji: "⛰️"}]
    this.setMarkers(locationData)
    this.setBoundaries()
    this.addInfoControl()

    this.map.on('click', function (e) {
      console.log("You clicked the map at " + e.latlng.toString())
    });
  }

  setMarkers = (locations) => {
    locations.forEach((location) => {
      L.marker([location.lat, location.long], {icon: this.markerIcons(location.emoji)})
        .addTo(this.map)
        .on('click', function(e) {
          console.log(e.latlng);
        });
        // marker.bindPopup("<b>Hello world!</b><br>I am a popup.");
    })
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
    this.info = L.control();

    this.info.onAdd = (map) => {
      this._div = L.DomUtil.create('div', 'info'); // div with class "info"
      this.info.update();
      return this._div;
    };

    this.info.update = (props) => {
      this._div.innerHTML = '<h4>Region</h4>' +  (props ? `<b>${props.shapeName}</b>` : 'Hover over a regency<br/> or click on a location pin');
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
    this.info.update(layer.feature.properties);
  }

  resetHighlight = (e) => {
    this.geojson.resetStyle(e.target);
    this.info.update();
  }

  zoomToFeature = (e) => {
    this.map.fitBounds(e.target.getBounds());
  }

}