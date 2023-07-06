import 'package:chatonym/utils/widgets/error_widget.dart';
import 'package:chatonym/utils/widgets/join_group_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Backend/Cloud_Service/Group_Service/group_service.dart';
import '../../../Models/group_model.dart';
import '../../../utils/widgets/loading_widget.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({required this.web, super.key});
  final bool web;

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late TextEditingController _searchController;
  bool _isSearching = false;
  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  Future<List<Group>> _searchFuture(String query) async {
    return ref.read(groupServiceProvider).searchGroups(query);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(15),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              labelText: 'Search for Groups',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    if (_searchController.text.isNotEmpty) {
                      _isSearching = true;
                    }
                  });
                },
                icon: const Icon(Icons.arrow_forward),
              ),
            ),
            onSubmitted: (value) {
              setState(() {
                if (_searchController.text.isNotEmpty) {
                  _isSearching = true;
                }
              });
            },
          ),
          const SizedBox(height: 10),
          _isSearching
              ? FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/nothing_found.png',
                                height: 300,
                              ),
                              const Text(
                                'No Groups Found',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return JoinGroupList(data: snapshot.data!);
                    } else if (snapshot.hasError) {
                      return const ErrorScreen();
                    } else {
                      return const Center(
                        child: Loading(),
                      );
                    }
                  },
                  future: _searchFuture(_searchController.text),
                )
              : Column(
                  children: [
                    Image.asset(
                      'assets/images/search.png',
                      height: 300,
                    ),
                    const Text(
                      'Search for Groups',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
        ],
      ),
    );
    if (widget.web) {
      return Expanded(child: child);
    }
    return child;
  }
}
