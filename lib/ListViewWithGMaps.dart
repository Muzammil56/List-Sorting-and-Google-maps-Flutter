import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:list_sorting_with_gmaps/ListOfLocations.dart';
import 'package:location/location.dart';

class ListViewWitGMaps extends StatefulWidget {
  @override
  _ListViewWitGMapsState createState() => _ListViewWitGMapsState();
}

class _ListViewWitGMapsState extends State<ListViewWitGMaps> {

  //giving initial Position latitude and longitude when app starts
  LatLng _initialPosition = LatLng(30.3894007, 69.3532207);

  //using predefined function of location in package
  Location _location = Location();

  GoogleMapController _controller;

  //function for getting current location of user and updating it in realtime
  void _onMapCreated(GoogleMapController _controll) {
    _controller = _controll;
    _location.onLocationChanged().listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(l.latitude, l.longitude),
            zoom: 15,
          ),
        ),
      );
    });
  }

  //list for distances
  List<services> locations = [
    services(from: "A", to: "B", value: 12),
    services(from: "A", to: "C", value: 18),
    services(from: "A", to: "D", value: 8),
    services(from: "A", to: "E", value: 24),
    services(from: "Z", to: "X", value: 5),
    services(from: "Z", to: "Y", value: 15),
  ];

// generate a random index based on the list length

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "ListView With Google Maps",
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          //row for choosing Ascending or Descending sorting of given list
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                  onPressed: () {
                    setState(() {
                      locations.sort((a, b) => a.value.compareTo(b.value));
                    });
                  },
                  child: Text('Ascending')),
              FlatButton(

                  onPressed: () {
                    setState(() {
                      locations.sort((a, b) => b.value.compareTo(a.value));
                    });
                  },
                  child: Text('Descending')),
              FlatButton(
                  onPressed: () {
                    setState(() {
                      locations.shuffle();
                    });
                  },
                  child: Text('Random')),
            ],
          ),

          //List View for given Data
          ListView.builder(
            shrinkWrap: true,
            itemCount: locations.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(locations[index].from),
                      Text(locations[index].to),
                      Text(locations[index].value.toString() + "Km"),
                    ],
                  ),
                ),
              );
            },
          ),

          //google maps container
          Expanded(
            child: GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _initialPosition, zoom: 3),
              mapType: MapType.terrain,
              onMapCreated: _onMapCreated,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
            ),
          )
        ],
      ),
    );
  }
}
