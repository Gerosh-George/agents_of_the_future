import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_management_agentic_ai/screen/Gmos.dart';
import 'package:crowd_management_agentic_ai/screen/customAppBar.dart';
import 'package:crowd_management_agentic_ai/screen/graphs.dart';
import 'package:crowd_management_agentic_ai/screen/login.dart';
import 'package:crowd_management_agentic_ai/screen/paymentBroker.dart';
import 'package:crowd_management_agentic_ai/screen/profile.dart';
import 'package:crowd_management_agentic_ai/screen/sideNavigator.dart';
import 'package:crowd_management_agentic_ai/service/notifi_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_earth/flutter_earth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marquee/marquee.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



var badgeNotification = 10;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Google Maps Controller
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  // Default camera position (you can change this to your preferred location)
  static const CameraPosition _defaultCameraPosition = CameraPosition(
    target: LatLng(13.0625, 77.4748), // Bengaluru coordinates
    zoom: 4.0,
  );

  // Static notification data
  List<List<String>> notifications = [
    ['Payment Balance 521 Rs. Pending, Click here to initiate a GPAY!!','200Rs. To be sent to Madhu', 'Net 1232Rs Spent on Ed Sheeran Concert'],
    ['Patient Admitted to Manipal Hospital', 'Wallet Missing on Mr.Vishal was stolen by Rohith', '6 year old kid Gerosh missing, Found near Zone 4D'],
    ['Zone 4c - 252 is having their 1st Checkpoint call at 9:45am', 'BIEC forcated at 23° C', 'Agents of the future Team has been shortlisted to the top 15 teams']
  ];


  int current = 0;
  int current1 = 0;
  var currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadAlertsOnMap();
  }

  // Load alerts and create markers for the map
  void _loadAlertsOnMap() {
    getAlertsStream().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _updateMapMarkers(snapshot.docs);
      }
    });
  }
  // Update map markers based on alerts
  void _updateMapMarkers(List<QueryDocumentSnapshot> alerts) {
    final activeAlerts = _filterActiveAlerts(alerts);
    Set<Marker> newMarkers = {};

    for (int i = 0; i < activeAlerts.length; i++) {
      final alert = activeAlerts[i];
      final data = alert.data() as Map<String, dynamic>;

      if (data['coordinates'] != null) {
        final geoPoint = data['coordinates'] as GeoPoint;
        final severity = (data['severity'] ?? 'Low').toString().toLowerCase();

        newMarkers.add(
          Marker(
            markerId: MarkerId(alert.id),
            position: LatLng(geoPoint.latitude, geoPoint.longitude),
            icon: _getMarkerIcon(severity),
            infoWindow: InfoWindow(
              title: '${data['severity'] ?? 'Unknown'} Alert',
              snippet: data['message'] ?? 'No message',
              onTap: () => _showAlertDetailsWithEarth(_createAlertMap(alert)),
            ),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _markers = newMarkers;
      });
    }
  }

  // Get marker icon based on severity
  BitmapDescriptor _getMarkerIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'medium':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      default:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    }
  }

  // Create alert map from document snapshot
  Map<String, dynamic> _createAlertMap(QueryDocumentSnapshot alert) {
    final data = alert.data() as Map<String, dynamic>;
    final geoPoint = data['coordinates'] as GeoPoint?;
    final latitude = geoPoint?.latitude ?? 0.0;
    final longitude = geoPoint?.longitude ?? 0.0;
    final zoom = (data['zoom'] as num?)?.toInt() ?? 15;
    final tileCoords = _latLngToTileCoords(latitude, longitude, zoom);

    return {
      'id': alert.id,
      'message': data['message'] ?? 'No message',
      'timestamp': data['timestamp'] as Timestamp?,
      'severity': (data['severity'] ?? 'Low').toString(),
      'status': data['status'] ?? 'open',
      'latitude': latitude,
      'longitude': longitude,
      'x': tileCoords['x']!,
      'y': tileCoords['y']!,
      'z': zoom,
    };
  }

  // SIMPLIFIED: Get all alerts without complex filtering
  Stream<QuerySnapshot> getAlertsStream() {
    return FirebaseFirestore.instance
        .collection('alerts')
        .orderBy('timestamp', descending: true)
        .limit(50) // Limit to prevent too much data
        .snapshots();
  }

  // SIMPLIFIED: Filter alerts in memory instead of in query
  List<QueryDocumentSnapshot> _filterActiveAlerts(List<QueryDocumentSnapshot> allAlerts) {
    return allAlerts.where((alert) {
      final data = alert.data() as Map<String, dynamic>;
      final status = (data['status'] ?? '').toString().toLowerCase();
      return status != 'resolved' && status != 'closed';
    }).toList();
  }

  // Helper method to convert lat/lng to tile coordinates
  Map<String, int> _latLngToTileCoords(double lat, double lng, int zoom) {
    double latRad = lat * (3.14159265359 / 180.0);
    int n = (1 << zoom).toInt();
    int x = ((lng + 180.0) / 360.0 * n).floor();
    int y = ((1.0 -  log((tan(latRad) + (1 / cos(latRad)))) / 3.14159265359) / 2.0 * n).floor();
    return {'x': x, 'y': y};
  }

  // SIMPLIFIED: Group alerts by severity
  Map<String, List<Map<String, dynamic>>> _groupAlertsBySeverity(List<QueryDocumentSnapshot> alerts) {
    Map<String, List<Map<String, dynamic>>> grouped = {
      'High': [],
      'Medium': [],
      'Low': [],
    };

    for (var alert in alerts) {
      final data = alert.data() as Map<String, dynamic>;
      final rawSeverity = (data['severity'] ?? 'Low').toString().toLowerCase().trim();

      String normalizedSeverity = 'Low'; // Default
      if (rawSeverity.contains('high')) {
        normalizedSeverity = 'High';
      } else if (rawSeverity.contains('med')) {
        normalizedSeverity = 'Medium';
      }

      // Extract coordinates from GeoPoint
      double latitude = 0.0;
      double longitude = 0.0;
      int zoom = 15; // Default zoom level

      if (data['coordinates'] != null) {
        final geoPoint = data['coordinates'] as GeoPoint;
        latitude = geoPoint.latitude;
        longitude = geoPoint.longitude;
      }

      if (data['zoom'] != null) {
        zoom = (data['zoom'] as num).toInt();
      }

      // Convert to tile coordinates
      final tileCoords = _latLngToTileCoords(latitude, longitude, zoom);

      grouped[normalizedSeverity]!.add({
        'id': alert.id,
        'message': data['message'] ?? 'No message',
        'timestamp': data['timestamp'] as Timestamp?,
        'severity': normalizedSeverity,
        'status': data['status'] ?? 'open',
        'latitude': latitude,
        'longitude': longitude,
        'x': tileCoords['x']!,
        'y': tileCoords['y']!,
        'z': zoom,
      });
    }

    return grouped;
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high': return Colors.red;
      case 'medium': return Colors.orange;
      default: return Colors.blue;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'high': return Icons.error;
      case 'medium': return Icons.warning;
      default: return Icons.info;
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    return DateFormat('MMM dd, HH:mm').format(dateTime);
  }

  // Method to focus map on specific alert location
  void _focusOnAlert(Map<String, dynamic> alert) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(alert['latitude'], alert['longitude']),
            zoom: 16.0,
          ),
        ),
      );
    }
  }

  // New method to show alert details with Earth view
  void _showAlertDetailsWithEarth(Map<String, dynamic> alert) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Alert Details',
                        style: GoogleFonts.albertSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _focusOnAlert(alert),
                          icon: const Icon(Icons.my_location),
                          tooltip: 'Focus on map',
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Alert Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(alert['severity']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getSeverityColor(alert['severity']),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getSeverityIcon(alert['severity']),
                            color: _getSeverityColor(alert['severity']),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getSeverityColor(alert['severity']),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              alert['severity'].toUpperCase(),
                              style: GoogleFonts.albertSans(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        alert['message'],
                        style: GoogleFonts.albertSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (alert['timestamp'] != null)
                        Text(
                          'Time: ${_formatTimestamp(alert['timestamp'])}',
                          style: GoogleFonts.albertSans(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        'Location: ${alert['latitude'].toStringAsFixed(6)}, ${alert['longitude'].toStringAsFixed(6)}',
                        style: GoogleFonts.albertSans(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tile Coords: X: ${alert['x']}, Y: ${alert['y']}, Z: ${alert['z']}',
                        style: GoogleFonts.albertSans(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Earth View
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FlutterEarth(
                        url: 'http://mt0.google.com/vt/lyrs=y&hl=en&x=${alert['x']}&y=${alert['y']}&z=${alert['z']}',
                        radius: 180,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(35, 35, 33, 91),
      drawer: const NavigationDrawerWidget(),
      appBar: customAppBar(badgeNotification, context),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: const AssetImage('assets/bg.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              // Real-time alerts marquee
              _buildMarquee(),

              // Google Maps Section
              _buildGoogleMapsSection(),

              // Dynamic Alerts Section
              _buildAlertsSection(),

              // Notifications Section
              _buildNotificationsSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildMarquee() {
    return Container(
      height: 30.0,
      color: const Color(0xFFd81e29),
      child: StreamBuilder<QuerySnapshot>(
        stream: getAlertsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading alerts',
                style: GoogleFonts.albertSans(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'Loading alerts...',
                style: GoogleFonts.albertSans(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            );
          }

          final allAlerts = snapshot.data!.docs;
          final activeAlerts = _filterActiveAlerts(allAlerts);

          String marqueeText = 'No active alerts';
          if (activeAlerts.isNotEmpty) {
            marqueeText = activeAlerts.take(5).map((alert) {
              final data = alert.data() as Map<String, dynamic>;
              return '${data['severity'] ?? 'Unknown'}: ${data['message'] ?? 'No message'}';
            }).join(' || ');
          }

          return Marquee(
            text: marqueeText,
            style: GoogleFonts.albertSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            blankSpace: 20.0,
            velocity: 75.0,
          );
        },
      ),
    );
  }

  Widget _buildGoogleMapsSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 4),
      child: Container(
        width: 400,
        decoration: const BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Column(
          children: [
            GridView.count(
              primary: false,
              crossAxisCount: 1,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 400, // Set a fixed height for the map
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _defaultCameraPosition,
                        markers: _markers,
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                        },
                        zoomControlsEnabled: true,
                        compassEnabled: true,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        mapToolbarEnabled: true,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, Color color, bool isUp) {
    return Row(
      children: [
        Text(title, style: GoogleFonts.albertSans(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(
          ' ${isUp ? '\u{25B2}' : '\u{25BC}'} $value',
          style: GoogleFonts.albertSans(fontSize: 17, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildAlertsSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: const Color.fromARGB(232, 249, 241, 226),
        child: ExpansionTile(
          leading: const Icon(Icons.arrow_drop_down),
          trailing: const Icon(Icons.warning_amber_rounded),
          title: Text(
            'All Active Alerts',
            style: GoogleFonts.albertSans(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          children: [
            Container(
              width: 400,
              height: 400,
              margin: const EdgeInsets.all(5),
              child: StreamBuilder<QuerySnapshot>(
                stream: getAlertsStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final allAlerts = snapshot.data!.docs;
                  final activeAlerts = _filterActiveAlerts(allAlerts);

                  if (activeAlerts.isEmpty) {
                    return Center(
                      child: Text(
                        'No active alerts found',
                        style: GoogleFonts.albertSans(fontSize: 16, color: Colors.grey[600]),
                      ),
                    );
                  }

                  final groupedAlerts = _groupAlertsBySeverity(activeAlerts);
                  final severityList = ['High', 'Medium', 'Low'];

                  return Column(
                    children: [
                      // Severity tabs
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: severityList.length,
                          itemBuilder: (context, index) {
                            final severity = severityList[index];
                            final alertCount = groupedAlerts[severity]?.length ?? 0;

                            return GestureDetector(
                              onTap: () => setState(() => current = index),
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                width: 100,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: current == index
                                      ? _getSeverityColor(severity).withOpacity(0.3)
                                      : Colors.white54,
                                  borderRadius: BorderRadius.circular(current == index ? 15 : 10),
                                  border: current == index
                                      ? Border.all(color: _getSeverityColor(severity), width: 2)
                                      : null,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(severity, style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: current == index ? _getSeverityColor(severity) : Colors.grey,
                                      )),
                                      Text('($alertCount)', style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        color: current == index ? _getSeverityColor(severity) : Colors.grey,
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Alerts list
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final selectedSeverity = severityList[current];
                            final selectedAlerts = groupedAlerts[selectedSeverity] ?? [];

                            if (selectedAlerts.isEmpty) {
                              return Center(
                                child: Text('No $selectedSeverity alerts',
                                    style: GoogleFonts.albertSans(fontSize: 14, color: Colors.grey[600])),
                              );
                            }

                            return ListView.builder(
                              itemCount: selectedAlerts.length,
                              itemBuilder: (context, alertIndex) {
                                final alert = selectedAlerts[alertIndex];
                                final timestamp = alert['timestamp'] as Timestamp?;
                                final formattedTime = timestamp != null
                                    ? _formatTimestamp(timestamp)
                                    : 'Unknown time';

                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  child: ListTile(
                                    leading: Icon(
                                      _getSeverityIcon(selectedSeverity),
                                      color: _getSeverityColor(selectedSeverity),
                                    ),
                                    title: Text(
                                      alert['message'],
                                      style: GoogleFonts.albertSans(fontSize: 14, fontWeight: FontWeight.w600),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(formattedTime,
                                            style: GoogleFonts.albertSans(fontSize: 12, color: Colors.grey[600])),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                                            const SizedBox(width: 2),
                                            Expanded(
                                              child: Text(
                                                'Lat: ${alert['latitude']?.toStringAsFixed(4) ?? 'N/A'}, Lng: ${alert['longitude']?.toStringAsFixed(4) ?? 'N/A'}',
                                                style: GoogleFonts.albertSans(fontSize: 10, color: Colors.grey[600]),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                          decoration: BoxDecoration(
                                            color: _getSeverityColor(selectedSeverity).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            selectedSeverity.toUpperCase(),
                                            style: GoogleFonts.albertSans(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: _getSeverityColor(selectedSeverity),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        GestureDetector(
                                          onTap: () => _focusOnAlert(alert),
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Icon(
                                              Icons.location_searching,
                                              size: 16,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        GestureDetector(
                                          onTap: () => _showAlertDetailsWithEarth(alert),
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Icon(
                                              Icons.public,
                                              size: 16,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    isThreeLine: true,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: const Color.fromARGB(232, 249, 241, 226),
        child: ExpansionTile(
          leading: const Icon(Icons.arrow_drop_down),
          trailing: const Icon(Icons.notification_important_rounded),
          title: Text('Notifications', style: GoogleFonts.albertSans(fontSize: 22, fontWeight: FontWeight.bold)),
          children: [
            Container(
              width: 400,
              height: 200,
              margin: const EdgeInsets.all(5),
              child: Column(
                children: [
                  // Notification tabs
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        final items = ["Payment", "Incident", "Events"];
                        return GestureDetector(
                          onTap: () => setState(() => current1 = index),
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            width: 80,
                            height: 45,
                            decoration: BoxDecoration(
                              color: current1 == index ? Colors.white70 : Colors.white54,
                              borderRadius: BorderRadius.circular(current1 == index ? 15 : 10),
                              border: current1 == index ? Border.all(color: Colors.black, width: 2) : null,
                            ),
                            child: Center(
                              child: Text(
                                items[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: current1 == index ? Colors.black : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: CarouselSlider(
                      items: List.generate(3, (i) => ListTile(
                        leading: const Icon(Icons.notifications_sharp),
                        title: Text(notifications[current1][i]),
                        subtitle: Text(['Payment', 'Incident', 'Events'][i]),
                      )),
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        autoPlay: true,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: const Duration(milliseconds: 3000),
                        viewportFraction: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home_rounded, color: Colors.black),
          backgroundColor: Color.fromRGBO(205, 19, 0, 1),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(Icons.account_circle_sharp, color: Colors.black),
          backgroundColor: Color.fromRGBO(205, 19, 0, 1),
        ),
      ],
      onTap: (index) {
        if (index == 1) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Profile()));
        }
      },
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFFb40404),
      onPressed: () => _showSOSDialog(context),
      child: const Icon(Icons.sos), // Use Icons.sos for the SOS icon (Flutter 3.10+)
    );
  }
  void _showSOSDialog(BuildContext context) {
    final TextEditingController _descController = TextEditingController();

    Future<void> _sendIncident(String type, String description) async {
      Position position;
      try {
        LocationPermission permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied. Incident not sent.')),
          );
          return;
        }

        position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not get location: $e')));
        return;
      }

      DateTime date = DateTime.now();
      // Format as ISO 8601 without milliseconds with a Z at the end
      String isoString = DateFormat("yyyy-MM-ddTHH:mm:ss'Z'").format(date.toUtc());

      final url = Uri.parse('https://8080-firebase-smart-dispatch-agent-1753509688965.cluster-a6zx3cwnb5hnuwbgyxmofxpkfe.cloudworkstations.dev/dispatch');
      final headers = {
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'timestamp': isoString,
        'incident_type': type,
        'description':  description,
        'coordinates': [position.latitude, position.longitude],
      });

      try {
        final response = await http.post(url, headers: headers, body: body);
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incident reported!')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to report incident: ${response.statusCode}')));
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to report incident: $e')));
      }
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Emergency Assistance'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select the type of help you need:'),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description (optional)',
                  hintText: 'Enter incident description',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _sendIncident('Medical', _descController.text.trim());
              },
              child: const Text('Medical Help'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _sendIncident('Police', _descController.text.trim());
              },
              child: const Text('Police Help'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _sendIncident('Fire', _descController.text.trim());
              },
              child: const Text('Fire Help'),
            ),
          ],
        );
      },
    );
  }



}