import 'package:flutter/material.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'navigation_drawer_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Completer<GoogleMapController> _controller = Completer();
  //Completer é uma maneira para fazer requisições para APIs

  CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(-23.5871069, -46.6624017), zoom: 12);

  Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};
  Set<Polyline> _polylines = {};

  _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  _moveCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(_cameraPosition
          /*const CameraPosition(
          target: LatLng(-23.5871069, -46.6624017),
          zoom: 12,
          //tilt: 45,
          //bearing: 30.0,
        ),*/
          ),
    );
  }

  _loadMakers() {
    Set<Marker> localMakers = {};

    Marker location01 = Marker(
      markerId: const MarkerId('coordLocation01'),
      position: const LatLng(-23.58608545, -46.66190963338509),
      infoWindow: const InfoWindow(title: 'Pavilhão Japonês'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      ),
      onTap: () {
        print("Ciclou em Pavilhão Japonês");
      },
    );
    Marker location02 = Marker(
      markerId: const MarkerId('coordLocation02'),
      position: const LatLng(-23.5916469, -46.6436403),
      infoWindow: const InfoWindow(title: 'Museu Afro Brasil'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      ),
      onTap: () {
        print("Ciclou em Museu Afro Brasil");
      },
    );
    Marker location03 = Marker(
      markerId: const MarkerId('coordLocation03'),
      position: const LatLng(-23.5916469, -46.6436403),
      infoWindow: const InfoWindow(title: ''),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      ),
      onTap: () {
        print("Ciclou em Taverna Medieval");
      },
    );

    localMakers.add(location01);
    localMakers.add(location02);
    localMakers.add(location03);

    setState(() {
      _markers = localMakers;
    });
  }

  _loadPolygons() {
    Set<Polygon> listPolygons = {};

    Polygon polygon01 = Polygon(
      polygonId: const PolygonId("coordPolygon01"),
      fillColor: const Color.fromARGB(158, 255, 94, 0),
      strokeColor: const Color.fromRGBO(50, 75, 205, 1),
      strokeWidth: 5,
      points: const [
        LatLng(-23.568701, -46.672486),
        LatLng(-23.600904, -46.661202),
        LatLng(-23.594529, -46.627680),
      ],
      consumeTapEvents: true,
      onTap: () {
        print("Ciclou na área do Polygon 01");
      },
      zIndex: 0,
    );

    Polygon polygon02 = Polygon(
      polygonId: const PolygonId("coordPolygon02"),
      fillColor: const Color.fromARGB(158, 51, 255, 0),
      strokeColor: const Color.fromRGBO(50, 75, 205, 1),
      strokeWidth: 5,
      points: const [
        LatLng(-23.610325, -46.668235),
        LatLng(-23.570736, -46.677200),
        LatLng(-23.573962, -46.628040),
      ],
      consumeTapEvents: true,
      onTap: () {
        print("Ciclou na área do Polygon 02");
      },
      zIndex: 1,
    );

    listPolygons.add(polygon01);
    listPolygons.add(polygon02);

    setState(() {
      _polygons = listPolygons;
    });
  }

  _loadPolylines() {
    Set<Polyline> listPolylines = {};

    Polyline polyline01 = Polyline(
        polylineId: const PolylineId("coordPolyline01"),
        color: const Color.fromRGBO(50, 75, 205, 1),
        width: 20,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
        points: const [
          LatLng(-23.524854, -46.664158),
          LatLng(-23.546161, -46.665602),
          LatLng(-23.540903, -46.628739),
        ],
        consumeTapEvents: true,
        onTap: () {
          AlertDialog alert = AlertDialog(
            title: const Text('Polyline 01'),
            content: const Text('Clicou no linha do Polyline 01'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
        });

    listPolylines.add(polyline01);
    setState(() {
      _polylines = listPolylines;
    });
  }

  void _recoverActualLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(
            'Parece que você não permitiu o uso do GPS, abra as configurações do aplicativo e libere a permissão.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  void getLocationUpdates() {
    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _cameraPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 15);
        _moveCamera();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMakers();
    _loadPolygons();
    _loadPolylines();
    _recoverActualLocation();
    getLocationUpdates();
    //_addListenerLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const NavigationDrawerWidget(),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(50, 75, 205, 1),
        title:
            const Text("Mapas e Geolocalização", textAlign: TextAlign.center),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.my_location_outlined),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        hoverColor: Colors.white54,
        onPressed: _moveCamera,
      ),
      body: Stack(
        children: <Widget>[
          _googleMap(context),
          _buidContainer(),
        ],
      ),
    );
  }

  Widget _googleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        //-23.5871069,-46.6624017
        initialCameraPosition: _cameraPosition,
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        markers: _markers,
        polygons: _polygons,
        polylines: _polylines,
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 16,
      tilt: 30.0,
      bearing: 45.0,
    )));
  }

  Widget _buidContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 100.0),
        height: 150.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            const SizedBox(width: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://lh5.googleusercontent.com/p/AF1QipOtAErWhT1bWXR65T4cpSRcTnKSoAnXtX1vwMPE=w408-h306-k-no",
                  -23.58608545,
                  -46.66190963338509,
                  "Pavilhão Japonês"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://lh5.googleusercontent.com/p/AF1QipNIcuHy2OGrjVKom4TBex1elzBVkIdXL57vkZ2J=w408-h280-k-no",
                  -23.58389455,
                  -46.65919333915626,
                  "Museu Afro Brasil"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://lh5.googleusercontent.com/p/AF1QipPPgylvuj9AJSu7sPkqXykwEAeeGAEk0cAG-LNu=w426-h240-k-no",
                  -23.5916469,
                  -46.6436403,
                  "Taverna Medieval"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boxes(String _image, double lat, double long, String points) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: Container(
        child: FittedBox(
          child: Material(
            color: Colors.white,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(24.0),
            shadowColor: const Color(0x802196F3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 180,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.0),
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(_image),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: myDetailsContainer(points),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myDetailsContainer(String pointsName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            child: Text(
              pointsName,
              style: const TextStyle(
                  color: Color.fromRGBO(50, 75, 205, 1),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 5.0),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: const Text(
                  "4.1",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Container(
                child: const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 15.0,
                ),
              ),
              Container(
                child: const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 15.0,
                ),
              ),
              Container(
                child: const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 15.0,
                ),
              ),
              Container(
                child: const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 15.0,
                ),
              ),
              Container(
                child: const Icon(
                  Icons.star_border_outlined,
                  color: Colors.grey,
                  size: 15.0,
                ),
              ),
              Container(
                child: const Text(
                  "(946)",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5.0),
        Container(
          child: const Text(
            "São Paulo \u00B7 \u0024\u0024 \u00B7 1.6 mi",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
            ),
          ),
        ),
        const SizedBox(height: 5.0),
        Container(
          child: const Text(
            "Aberto \u00B7 Horários: 17:00 Seg",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
