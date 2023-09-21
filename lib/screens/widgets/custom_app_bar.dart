import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key, required this.imageUrl, required this.title})
      : super(key: key);
  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Image(
        image: AssetImage(
          'assets/images/background.jpg',
        ),
        fit: BoxFit.cover,
      ),
      toolbarHeight: 125,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Builder(
        builder: (context) => CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          child: TextButton(
            child: const Text(''),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      centerTitle: true,
      title: Text(title),
    );
  }
}
