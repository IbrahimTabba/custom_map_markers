# Custom Map Markers

Not only "*Everything is a widget*" also "*Everywhere is a widget*".  
`custom_map_marker` is a package that turns runtime widgets into map marker icons.

<img src="https://github.com/IbrahimTabba/custom_map_markers/blob/master/example/images/custom-map-markers.png?raw=true" width="256">

## Features

this package providers the following features:

- Ability to create runtime map markers using flutter widgets.
- Capture Images of any list of widgets.


## Getting started

First, add `custom_map_markers` as a dependency in your pubspec.yaml file.
```yaml
dependencies:
  custom_map_markers: ^0.0.1
```


## Usage


1. Wrap your `GoogleMaps` widget with `CustomGoogleMapMarkerBuilder`.
2. Define each marker and its custom widget in `customMarkers`
3. Once custom markers are ready they will be passed as `Set<Marer>` in `builder` function.


```dart  
final locations = const [  
  LatLng(37.42796133580664, -122.085749655962),  
  LatLng(37.41796133580664, -122.085749655962),  
];  

CustomGoogleMapMarkerBuilder(  
  customMarkers: [  
  MarkerData(  
        marker: Marker(  markerId: const MarkerId('id-1'), position: locations[0]),  
		child: _customMarker('A', Colors.black)),  
  MarkerData(  
        marker: Marker(  markerId: const MarkerId('id-2'), position: locations[1]),  
		child: _customMarker('B', Colors.red)),    
  ],  
  builder: (BuildContext context, Set<Marker>? markers) {  
    if (markers == null) {  
      return const Center(child: CircularProgressIndicator());  
  }  
    return GoogleMap(  
      initialCameraPosition: const CameraPosition(  
        target: LatLng(37.42796133580664, -122.085749655962),  
  zoom: 14.4746,  
  ),  
  markers: markers,  
  onMapCreated: (GoogleMapController controller) { },  
  );  
  },  
)
```  

**Not a google map user?**

> if you are not willing to use google maps you can use
> `CustomMapMarkerBuilder` that takes `List<widgets>` instead  of `List<MarkerData>` and returns `List<Uint8List>` instead of `Set<Marker>` so you are free to use captured png images as you need.

### Notes:

1. Make sure your marker widget has boundaries.
2. This package capture a png image of widget markers once they render, if your widget would take more time to render like `Image.network` you can use `screenshotDelay` parameter to daley the capture process making sure that your widget is rendered properly before capturing it.
3. to run project example you have to add a valid google maps key to android/ios directories.


## Features and bugs
Please feel free to:

-   file feature requests and bugs at the  [issue tracker](https://github.com//IbrahimTabba/custom_map_markers/issues)
  