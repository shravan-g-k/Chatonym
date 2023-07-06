import 'dart:io';
import 'package:chatonym/Backend/Cloud_Service/Group_Service/group_service.dart';
import 'package:chatonym/utils/widgets/error_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';

import '../../../utils/functions/file_pick.dart';

// Contains the Banner Selection, Profile Selection,
// 2 textfield for name & description and create button
class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key, required this.web});
  final bool web;

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  late TextEditingController _groupNameController;
  late TextEditingController _groupDescriptionController;
  late GlobalKey<FormState> _formKey;
  FilePickerResult? _bannerResult;
  FilePickerResult? _profileResult;
  bool isLocationEnabled = false;
  dynamic _geoFirePoint;
  @override
  void initState() {
    super.initState();
    _groupNameController = TextEditingController();
    _groupDescriptionController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _groupDescriptionController.dispose();
    super.dispose();
  }

  void callCreateGroup(WidgetRef ref, BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Group'),
          content: Text(
            'Creating Group ${_groupNameController.text}\nPlease wait ...',
          ),
        );
      },
    );
    if (kIsWeb) {
      // If the platform is web then use the bytes from the file
      // call the create group function from the group service provider
      ref
          .read(groupServiceProvider)
          .createGroup(
              name: _groupNameController.text,
              desc: _groupDescriptionController.text.isEmpty
                  ? 'No Description'
                  : _groupDescriptionController.text,
              geoPoint: _geoFirePoint,
              webBanner: _bannerResult!.files.first.bytes,
              webProfile: _profileResult!.files.first.bytes,
              context: context)
          .then(
        (value) {
          Navigator.pop(context);
          return value // the value will be true if success and false if failed
              // if the group is created then show the snackbar and pop the context
              ? {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Group Created!'))),
                  Navigator.pop(context),
                }
              : ScaffoldMessenger.of(context).showSnackBar(
                  // else show the snackbar with failed message
                  const SnackBar(
                    content: Text('Failed to Create Group'),
                  ),
                );
        },
      );
    } else {
      ref
          .read(groupServiceProvider)
          .createGroup(
              name: _groupNameController.text,
              desc: _groupDescriptionController.text.isEmpty
                  ? 'No Description'
                  : _groupDescriptionController.text,
              geoPoint: _geoFirePoint,
              // if the platform is mobile then use the file from the file picker
              mobileBanner: _bannerResult != null
                  // if the file is selected then get the path from the file picker
                  ? File(_bannerResult!.files.first.path!)
                  // else null
                  : null,
              // same for the profile
              mobileProfile: _profileResult != null
                  // if the file is selected then get the path from the file picker
                  ? File(_profileResult!.files.first.path!)
                  // else null
                  : null,
              context: context)
          .then(
        (value) {
          Navigator.pop(context);
          return value
              // the value will be true if success and false if failed
              ? {
                  ScaffoldMessenger.of(context).showSnackBar(
                      // if the group is created then show the snackbar and pop the context
                      const SnackBar(content: Text('Group Created!'))),
                  Navigator.pop(context)
                }
              : ScaffoldMessenger.of(context).showSnackBar(
                  // else show the snackbar with failed message
                  const SnackBar(
                    content: Text('Failed to Create Group'),
                  ),
                );
        },
      );
    }
  }

  void groupLocationEnableDisable(bool enable) async {
    // if the location based enabled
    // Get the location permission and enable the location
    // if location based is disabled set isLocationEnabled to false

    if (!enable) {
      // if the location based is disabled then set the isLocationEnabled to false
      setState(() {
        isLocationEnabled = false;
      });
      return;
    }
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
          setState(() {
            isLocationEnabled = true;
          });
        }
        return value;
      });
      // get the geofirepoint from the position
      _geoFirePoint = GeoFlutterFire()
          .point(latitude: position.latitude, longitude: position.longitude)
          .data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.web
          ? AppBar(
              title: const Text('Create Group'),
            )
          : null,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            // Main Column containing all the widgets
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                // DRAG HANDLE
                widget.web
                    ? const SizedBox()
                    : const Icon(Icons.drag_handle_rounded),
                // CREATE GROUP Text
                widget.web
                    ? const SizedBox()
                    : const Text(
                        'Create Group',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                // SPACE
                const SizedBox(
                  height: 10,
                ),
                // BANNER & PROFILE SELCTION
                Stack(
                  children: [
                    // BANNER SELECTION
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: InkWell(
                        onTap: () async {
                          _bannerResult = await pickFiles();
                          if (_bannerResult != null) {
                            setState(() {});
                          }
                        },
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _bannerResult != null
                              ? kIsWeb
                                  ? Image.memory(
                                      _bannerResult!.files.first.bytes!,
                                      fit: BoxFit.fitHeight,
                                    )
                                  : Image.file(
                                      File(_bannerResult!.files.first.path!),
                                      fit: BoxFit.fitHeight,
                                    )
                              : const Icon(
                                  Icons.image,
                                  size: 50,
                                ),
                        ),
                      ),
                    ),
                    // PROFILE SELECTION
                    Positioned(
                      // positioned to bottom left
                      bottom: 0,
                      left: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                          onTap: () async {
                            _profileResult = await pickFiles();
                            if (_profileResult != null) {
                              setState(
                                () {},
                              );
                            }
                          },
                          //  PROFILE IMAGE
                          child: CircleAvatar(
                            radius: 30,
                            child: _profileResult != null
                                ? kIsWeb
                                    ? Image.memory(
                                        _profileResult!.files.first.bytes!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(_profileResult!.files.first.path!),
                                        fit: BoxFit.cover,
                                      )
                                : const Icon(
                                    Icons.photo,
                                    size: 30,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                // LOCATION BASED SWITCH BUTTON
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      const Text('Location Based'),
                      Switch(
                        value: isLocationEnabled,
                        onChanged: (value) {
                          groupLocationEnableDisable(value);
                        },
                      ),
                    ],
                  ),
                ),
                // FORM FOR NAME
                Form(
                  key: _formKey,
                  // TEXT FORM FIELD FOR NAME
                  child: TextFormField(
                    maxLength: 30,
                    controller: _groupNameController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      labelText: 'Group Name',
                    ),
                    // VALIDATION if empty
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // TEXT FIELD FOR DESCRIPTION
                TextField(
                  controller: _groupDescriptionController,
                  maxLength: 500,
                  maxLines: 5,
                  minLines: 1,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    labelText: 'Group Description',
                  ),
                ),
                // CREATE BUTTON
                Consumer(
                  builder: (context, ref, child) => OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        callCreateGroup(ref, context);
                        FocusScope.of(context).unfocus();
                      }
                    },
                    child: const Text('Create'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
