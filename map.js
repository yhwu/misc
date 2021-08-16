var styles = {
    'Point': [new ol.style.Style({
        image: new ol.style.Circle({
            radius: 8,
            fill: new ol.style.Fill({
                color: [255, 255, 255, 0.3]
            }),
            stroke: new ol.style.Stroke({color: '#cb1d1d', width: 2})
        })
    })],
    'LineString': [new ol.style.Style({
        stroke: new ol.style.Stroke({
            color: 'green',
            width: 1
        })
    })],
    'Polygon': [new ol.style.Style({
        stroke: new ol.style.Stroke({
            color: 'blue',
            lineDash: [4],
            width: 3
        }),
        fill: new ol.style.Fill({
            color: 'rgba(0, 0, 255, 0.1)'
        })
    })],
    'Circle': [new ol.style.Style({
        stroke: new ol.style.Stroke({
            color: 'red',
            width: 2
        }),
        fill: new ol.style.Fill({
            color: 'rgba(255,0,0,0.2)'
        })
    })],
};


var styleFunction = function(feature, resolution) {
  return styles[feature.getGeometry().getType()];
};


var styleFunction_FTR = function (feature) {
    var linestroke = new ol.style.Stroke({color: '#ffcc33', strokeOpacity: 0.7, width: 2});
    var shortlinestroke = new ol.style.Stroke({color: 'green', strokeOpacity: 0.7, width: 1});
    var circle = new ol.style.Circle({
                radius: 8,
                fill: new ol.style.Fill({color: [255, 255, 255, 0.3]}),
                stroke: new ol.style.Stroke({color: '#cb1d1d', width: 2})})
    var styles = [new ol.style.Style({stroke: linestroke})];

    var geometry = feature.getGeometry();
    var ddx = 100000, ratio = 0.3;
    geometry.forEachSegment(function (start, end) {
        var dx = end[0] - start[0];
        var dy = end[1] - start[1];
        var rotation = Math.atan2(dy, dx);
        var maxlen = Math.sqrt(dx*dx + dy*dy) * 0.1;
        if (ddx>maxlen){ddx = maxlen;}

        var lineStr1 = new ol.geom.LineString([end, [end[0] - ddx, end[1] + ddx * ratio]]);
        var lineStr2 = new ol.geom.LineString([end, [end[0] - ddx, end[1] - ddx * ratio]]);
        lineStr1.rotate(rotation, end);
        lineStr2.rotate(rotation, end);

        styles.push(new ol.style.Style({geometry: lineStr1, stroke: shortlinestroke}));
        styles.push(new ol.style.Style({geometry: lineStr2, stroke: shortlinestroke}));
        styles.push(new ol.style.Style({geometry: new ol.geom.Point(start), image:circle}));
        styles.push(new ol.style.Style({geometry: new ol.geom.Point(end), image:circle}));
    });

    return styles;
};


var Philadelphia = [-75.134109, 39.99808];
var Boston = [-71.057083, 42.361145];


var path = new ol.Feature({
    geometry: new ol.geom.LineString([Philadelphia, Boston]).transform('EPSG:4326', 'EPSG:3857'),
    name: 'Line',
    from: 'Philadelphia',
    to: 'Boston'
});


const geojsonPnodes = {
    "type": "FeatureCollection",
    "crs": {"type": "name", "properties": { "name": "EPSG:4326"}},
    "features": [
        {
            "type": "Feature",
            "geometry": {"type": "Point", "coordinates": Philadelphia},
            "properties": {
                "name": "Phyladelphia",
                "description": "Phyladelphia -75.134109, 39.99808"
            }
        },
        {
            "type": "Feature",
            "geometry": {"type": "Point", "coordinates": Boston},
            "properties": {
                "name": "Boston",
                "description": "Boston -71.057083, 42.361145"
            }
        }
    ]
};


const geojsonFTR = {
  'type': 'FeatureCollection',
  'crs': {'type': 'name', 'properties': {"name": "EPSG:4326"}},
  'features': [
      {
          'type': 'Feature',
          'geometry': {'type': 'LineString', 'coordinates': [Philadelphia, Boston]},
          "properties": {
              "name": "FTR",
              "type": "FTR source sink",
              "description": "a path",
              'source': 'Philadelphia',
              'sink':'Boston'
          }
      },
  ]
};


var ftr_layer = new ol.layer.Vector({
    // source: new ol.source.Vector({features: [path]}),
    source: new ol.source.Vector({
        features: new ol.format.GeoJSON().readFeatures(geojsonFTR, {featureProjection: 'EPSG:3857'}),
    }),
    style: styleFunction_FTR
});


var pnode_layer = new ol.layer.Vector({
    source: new ol.source.Vector({
        features: new ol.format.GeoJSON().readFeatures(geojsonPnodes, {featureProjection: 'EPSG:3857'}),
    }),
    style: styleFunction
});


/**
 * Layers
 **/
var map = new ol.Map({
    target: $('#map')[0],
    view: new ol.View({ center: ol.proj.fromLonLat(Philadelphia), zoom: 6, minZoom: 2, maxZoom: 20}),
    layers: [new ol.layer.Tile({source: new ol.source.OSM(), opacity:0.7})],
});
map.addLayer(ftr_layer);
map.addLayer(pnode_layer);


/**
 * Popup
 **/
var container = $('#popup')[0],
    content_element = $('#popup-content')[0],
    closer = $('#popup-closer')[0];

closer.onclick = function() {
    overlay.setPosition(undefined);
    closer.blur();
    return false;
};
var overlay = new ol.Overlay({
    element: container,
    autoPan: true,
    offset: [0, -10]
});
map.addOverlay(overlay);

var fullscreen = new ol.control.FullScreen();
map.addControl(fullscreen);

map.on('click', function(evt){
    var feature = map.forEachFeatureAtPixel(evt.pixel,
      function(feature, layer) {
        return feature;
      });
    if (feature) {
        var coord = feature.getGeometry().getCoordinates();
        if (Array.isArray(coord[0])){
            var x=0, y=0;
            coord.forEach(c => {x += c[0]; y+=c[1]});
            x /= coord.length;
            y /= coord.length;
            coord = [x,y];
        }
        var content = '<h3>' + feature.get('name') + '</h3>';
        content += '<h5>' + feature.get('description') + '</h5>';
        if (feature.get('from')){
            content += '<h5>' + feature.get('from') + ' -> ' + feature.get('to') +  '</h5>';
        }
        if (feature.get('source')){
            content += '<h5>' + feature.get('source') + ' -> ' + feature.get('sink') +  '</h5>';
        }
        content_element.innerHTML = content;
        overlay.setPosition(coord);
    }
});
map.on('pointermove', function(e) {
    if (e.dragging) return;
    var pixel = map.getEventPixel(e.originalEvent);
    var hit = map.hasFeatureAtPixel(pixel);
    map.getTarget().style.cursor = hit ? 'pointer' : '';
});

