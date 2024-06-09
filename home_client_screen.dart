import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
// ignore: unused_import
import 'package:provider/provider.dart';

class HomeClientScreen extends StatefulWidget {
  @override
  _HomeClientScreenState createState() => _HomeClientScreenState();
}

class Professional {
  final String username;
  final String businessName;
  final String profileImage;
  final String category;
  final String subCategories;
  final dynamic quality;
  final dynamic generalRating;
  final dynamic jobsCompleted;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic cost;

  Professional({
    required this.username,
    required this.businessName,
    required this.profileImage,
    required this.category,
    required this.subCategories,
    required this.quality,
    required this.generalRating,
    required this.jobsCompleted,
    required this.latitude,
    required this.longitude,
    required this.cost,
  });

  factory Professional.fromMap(Map<String, dynamic> data, String documentId) {
    return Professional(
      username: data['username'],
      businessName: data['businessName'],
      profileImage: data['profile_image'],
      category: data['category'],
      subCategories: data['subCategories'],
      quality: data['quality'],
      generalRating: data['generalRating'],
      jobsCompleted: data['jobs_completed'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      cost: data['cost'],
    );
  }
}

class _HomeClientScreenState extends State<HomeClientScreen> {
  MapboxMapController? mapController;
  LatLng? currentLocation;
  double _sliderValue = 5;
  String _filter = 'relevance';
  List<Professional> _professionals = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchProfessionals();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(
          'Los servicios de localización están deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permisos de localización denegados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Permisos de localización denegados permanentemente.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _fetchProfessionals() async {
    FirebaseFirestore.instance
        .collection('professionals')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        _professionals = querySnapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return Professional.fromMap(data, doc.id);
        }).toList();
        _filterProfessionals();
      });
    });
  }

  void _filterProfessionals() {
    if (currentLocation != null) {
      _professionals.sort((a, b) {
        double distanceA = Geolocator.distanceBetween(
          currentLocation!.latitude,
          currentLocation!.longitude,
          a.latitude,
          a.longitude,
        );
        double distanceB = Geolocator.distanceBetween(
          currentLocation!.latitude,
          currentLocation!.longitude,
          b.latitude,
          b.longitude,
        );
        return distanceA.compareTo(distanceB);
      });

      if (_filter == 'quality_desc') {
        _professionals.sort((a, b) => b.quality.compareTo(a.quality));
      } else if (_filter == 'quality_asc') {
        _professionals.sort((a, b) => a.quality.compareTo(b.quality));
      } else if (_filter == 'cost_desc') {
        _professionals.sort((a, b) => b.cost.compareTo(a.cost));
      } else if (_filter == 'cost_asc') {
        _professionals.sort((a, b) => a.cost.compareTo(b.cost));
      } else if (_filter == 'best_rated') {
        _professionals
            .sort((a, b) => b.generalRating.compareTo(a.generalRating));
      } else if (_filter == 'most_jobs') {
        _professionals
            .sort((a, b) => b.jobsCompleted.compareTo(a.jobsCompleted));
      }

      setState(() {
        _professionals = _professionals.where((prof) {
          double distance = Geolocator.distanceBetween(
            currentLocation!.latitude,
            currentLocation!.longitude,
            prof.latitude,
            prof.longitude,
          );
          return distance <= _sliderValue * 1000;
        }).toList();
      });
    }
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: Column(
            children: [
              ListTile(
                title: Text('Calidad (mejor a peor)'),
                onTap: () {
                  setState(() {
                    _filter = 'quality_desc';
                  });
                  Navigator.pop(context);
                  _filterProfessionals();
                },
              ),
              ListTile(
                title: Text('Calidad (peor a mejor)'),
                onTap: () {
                  setState(() {
                    _filter = 'quality_asc';
                  });
                  Navigator.pop(context);
                  _filterProfessionals();
                },
              ),
              ListTile(
                title: Text('Precio (mejor a peor)'),
                onTap: () {
                  setState(() {
                    _filter = 'cost_desc';
                  });
                  Navigator.pop(context);
                  _filterProfessionals();
                },
              ),
              ListTile(
                title: Text('Precio (peor a mejor)'),
                onTap: () {
                  setState(() {
                    _filter = 'cost_asc';
                  });
                  Navigator.pop(context);
                  _filterProfessionals();
                },
              ),
              ListTile(
                title: Text('Mejor votados'),
                onTap: () {
                  setState(() {
                    _filter = 'best_rated';
                  });
                  Navigator.pop(context);
                  _filterProfessionals();
                },
              ),
              ListTile(
                title: Text('Con más trabajos'),
                onTap: () {
                  setState(() {
                    _filter = 'most_jobs';
                  });
                  Navigator.pop(context);
                  _filterProfessionals();
                },
              ),
              ListTile(
                title: Text('Distancia (1-5 km)'),
                trailing: Slider(
                  value: _sliderValue,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: '$_sliderValue km',
                  onChanged: (double value) {
                    setState(() {
                      _sliderValue = value;
                    });
                  },
                  onChangeEnd: (double value) {
                    _filterProfessionals();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            // Scroll to top functionality can be implemented here
          },
          child: Text('Tasky'),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Open menu
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Open search filter
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar profesionales...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: _showFilterMenu,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _professionals.length,
              itemBuilder: (context, index) {
                var professional = _professionals[index];
                return GlassEffectContainer(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(professional.profileImage),
                    ),
                    title: Text(professional.businessName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Categoría: ${professional.category}'),
                        Text('Subcategoría: ${professional.subCategories}'),
                        Text(
                            'Trabajos completados: ${professional.jobsCompleted}'),
                        Text('Distancia: ${(Geolocator.distanceBetween(
                              currentLocation!.latitude,
                              currentLocation!.longitude,
                              professional.latitude,
                              professional.longitude,
                            ) / 1000).toStringAsFixed(2)} km'),
                      ],
                    ),
                    trailing: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.yellow),
                            Text(professional.generalRating.toString()),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.attach_money, color: Colors.green),
                            Text(professional.cost.toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Contratos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mi perfil',
          ),
        ],
      ),
    );
  }
}

class GlassEffectContainer extends StatelessWidget {
  final Widget child;

  const GlassEffectContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
