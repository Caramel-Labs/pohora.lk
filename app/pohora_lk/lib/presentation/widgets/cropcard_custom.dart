import 'package:flutter/material.dart';
import 'package:pohora_lk/routes.dart';

class CropCard_Custom extends StatelessWidget {
  const CropCard_Custom({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.apple),
        title: Text('Crop 1'),
        subtitle: Text('Some data about crop'),
        trailing: Icon(Icons.arrow_forward_ios_rounded),
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.cropDetails);
        },
      ),
    );
  }
}
