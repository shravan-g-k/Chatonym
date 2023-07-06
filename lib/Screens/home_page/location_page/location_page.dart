import 'package:chatonym/Backend/Cloud_Service/Group_Service/group_service.dart';
import 'package:chatonym/Constants/class_consts.dart';
import 'package:chatonym/utils/widgets/join_group_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import '../../../utils/widgets/error_widget.dart';
import '../../../utils/widgets/loading_widget.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key, required this.web});
  final bool web;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  double _value = 1;
  Locate? locate;

  void _searchGroups() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // if the location is disabled then show the error dialog
      if (context.mounted) {
        errorDialog(
          context,
          'Location Disabled',
          'Enable Location from the Settings',
        );
      }
      return;
    }
    // Get the location permission
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // if the location permission is denied then show the snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location Permission Denied')));
      }
    } else if (permission == LocationPermission.deniedForever) {
      // if the location permission is denied forever then show the error dialog
      if (context.mounted) {
        errorDialog(context, 'Location Denied',
            'Enable Location Permission from Settings');
      }
    } else {
      if (context.mounted) {
        // if the location permission is granted then show the dialog
        // to indicate the process has started
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text('Getting Location'),
                  content: Text('This may take a while...'),
                ));
      }
      // get the current location
      final Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best)
          .then((value) {
        if (context.mounted) {
          // if the context is mounted then pop the alert dialog
          // and set the isLocationEnabled to true
          Navigator.pop(context);
        }
        return value;
      });
      // get the geofirepoint from the position
      GeoFirePoint center = GeoFlutterFire()
          .point(latitude: position.latitude, longitude: position.longitude);
      // set the locate object
      setState(() {
        locate = Locate(center: center, radius: _value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TEXT
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            'Select the distance:',
            style: TextStyle(fontSize: 20),
          ),
        ),
        // SLIDER to select the distance
        Slider(
          min: 1,
          label: '$_value km',
          max: 20,
          divisions: 10,
          value: _value,
          onChanged: (value) {
            setState(() {
              _value = value.roundToDouble();
              locate = locate != null
                  ? Locate(center: locate!.center, radius: _value)
                  : null;
            });
          },
        ),
        // TEXT Groups near you
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            'Groups near you:',
            style: TextStyle(fontSize: 20),
          ),
        ),
        // Check of users location is enabled
        locate != null
            // if the location is enabled then show the groups
            // CONSUMER to get the nearby groups
            ? Consumer(builder: (context, ref, child) {
                final groups = ref.watch(nearbyGroupsProvider(locate!));
                return groups.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/nothing_found.png',
                              height: 300,
                            ),
                            const Text(
                              'No Groups Found',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      );
                    }
                    return JoinGroupList(data: data);
                  },
                  loading: () => const Expanded(
                    child: Center(
                      child: Loading(),
                    ),
                  ),
                  error: (error, stackTrace) {
                    return const ErrorScreen();
                  },
                );
              })
            // if the location is not enabled then show the button
            // BUTTON to get the location
            : Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/location_search.png',
                        height: 300,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _searchGroups();
                        },
                        child: const Text('Search'),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
    if (widget.web) {
      return Expanded(child: child);
    }
    return child;
  }
}
