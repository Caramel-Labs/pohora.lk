import 'package:flutter/material.dart';

class SearchBar_Custom extends StatelessWidget {
  const SearchBar_Custom({
    super.key,
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: 'Search Crops',
      controller: _searchController,
      leading: Icon(Icons.search),
      elevation: WidgetStatePropertyAll(2.0),
    );
  }
}
