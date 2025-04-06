import 'package:flutter/material.dart';
import 'package:pohora_lk/presentation/widgets/cropcard_custom.dart';
import 'package:pohora_lk/presentation/widgets/searchbar_custom.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Farm')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SearchBar_Custom(searchController: _searchController),
              SizedBox(height: 16),
              ListView.builder(
                itemCount: 2,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return CropCard_Custom();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
