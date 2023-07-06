// import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatonym/Models/group_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart';

import '../../../../Backend/Cloud_Service/Group_Service/group_service.dart';
import '../../../../utils/functions/file_pick.dart';

class EditGroup extends ConsumerStatefulWidget {
  const EditGroup({required this.group, super.key});
  final Group group;
  @override
  ConsumerState<EditGroup> createState() => _EditGroupState();
}

class _EditGroupState extends ConsumerState<EditGroup> {
  FilePickerResult? _banner;
  FilePickerResult? _profile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.group.name,
    );
    _descriptionController = TextEditingController(
      text: widget.group.description,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void saveUpdatedGroup() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Group'),
          content: Text(
            'Updating Group ${_nameController.text}\nPlease wait ...',
          ),
        );
      },
    );
    if (kIsWeb) {
      ref
          .read(groupServiceProvider)
          .updateGroup(
            group: widget.group,
            name: _nameController.text,
            desc: _descriptionController.text,
            webBanner: _banner != null ? _banner!.files.first.bytes! : null,
            webProfile: _profile != null ? _profile!.files.first.bytes! : null,
            context: context,
          )
          .then((value) {
        Navigator.pop(context);
        if (value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Group Updated!')));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            // else show the snackbar with failed message
            const SnackBar(
              content: Text('Failed to Update Group'),
            ),
          );
        }
      });
    } else {
      ref
          .read(groupServiceProvider)
          .updateGroup(
            group: widget.group,
            name: _nameController.text,
            desc: _descriptionController.text,
            mobileBanner:
                _banner != null ? File(_banner!.files.first.path!) : null,
            mobileProfile:
                _profile != null ? File(_profile!.files.first.path!) : null,
            context: context,
          )
          .then((value) {
        Navigator.pop(context);
        if (value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Group Updated!')));
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            // else show the snackbar with failed message
            const SnackBar(
              content: Text('Failed to Update Group'),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 75),
                        child: Container(
                          color: Colors.deepPurple[100],
                          height: 200,
                          width: size.width,
                          child: _banner != null
                              ? kIsWeb
                                  ? Image.memory(
                                      _banner!.files.first.bytes!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(_banner!.files.first.path!),
                                      fit: BoxFit.cover,
                                    )
                              : widget.group.banner != null
                                  ? CachedNetworkImage(
                                      imageUrl: widget.group.banner!,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: Colors.deepPurple[50],
                                      child: const Icon(
                                        Icons.group,
                                        size: 50,
                                      ),
                                    ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          _banner = await pickFiles();
                          setState(() {});
                        },
                        child: Container(
                          height: size.height * 0.2,
                          width: size.width,
                          color: Colors.black26,
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    top: 160,
                    left: size.width / 2 - 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: _profile != null
                            ? kIsWeb
                                ? Image.memory(
                                    _profile!.files.first.bytes!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(_profile!.files.first.path!),
                                    fit: BoxFit.cover,
                                  )
                            : widget.group.profile != null
                                ? CachedNetworkImage(
                                    imageUrl: widget.group.profile!,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: Colors.deepPurple[50],
                                    child: const Icon(
                                      Icons.group,
                                      size: 50,
                                    ),
                                  ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 160,
                    left: size.width / 2 - 50,
                    child: InkWell(
                      onTap: () async {
                        _profile = await pickFiles();
                        setState(() {});
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Colors.black26,
                          height: 100,
                          width: 100,
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black54),
                        shape: MaterialStateProperty.all(const CircleBorder()),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              // NAME
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    maxLength: 30,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              // DESCRIPTION
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  maxLength: 500,
                  maxLines: 5,
                ),
              ),
              // SAVE BUTTON
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      saveUpdatedGroup();
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
