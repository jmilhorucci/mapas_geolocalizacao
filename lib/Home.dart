import 'package:flutter/material.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'navigation_drawer_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Completer<GoogleMapController> _controller = Completer();
  //Completer é uma maneira para fazer requisições para APIs

  Set<Marker> _markers = {};

  _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  _moveCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: LatLng(-23.5871069, -46.6624017),
          zoom: 12,
          //tilt: 45,
          //bearing: 30.0,
        ),
      ),
    );
  }

  _loadMakers() {
    Set<Marker> localMakers = {};

    Marker location01 = Marker(
      markerId: const MarkerId('coord01'),
      position: const LatLng(-23.58608545, -46.66190963338509),
      infoWindow: const InfoWindow(title: 'Pavilhão Japonês'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueViolet,
      ),
      onTap: () {
        print("Ciclou em Pavilhão Japonês");
      },
    );
    Marker location02 = Marker(
      markerId: const MarkerId('coord02'),
      position: const LatLng(-23.58389455, -46.65919333915626),
      infoWindow: const InfoWindow(title: 'Museu Afro Brasil'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueViolet,
      ),
      onTap: () {
        print("Ciclou em Museu Afro Brasil");
      },
    );
    Marker location03 = Marker(
      markerId: const MarkerId('coord03'),
      position: const LatLng(-23.5916469, -46.6436403),
      infoWindow: const InfoWindow(title: ''),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueViolet,
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

  @override
  void initState() {
    super.initState();
    _loadMakers();
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
        initialCameraPosition: const CameraPosition(
          target: LatLng(-23.5871069, -46.6624017),
          zoom: 12,
        ),
        onMapCreated: _onMapCreated,
        markers: _markers,
        myLocationEnabled: true,
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
                  "https://lh5.googleusercontent.com/p/AF1QipMcYaJK8XVIP8nfPoXvuvqY8L26rVx2GKnxHDJV=w427-h240-k-no",
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
                  color: Color(0xFF6200EE),
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
