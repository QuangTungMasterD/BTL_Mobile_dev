import 'package:flutter/material.dart';

class PlayingPage extends StatelessWidget {
  final String imageUrl;

  const PlayingPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        const SizedBox(height: 60),

        /// ALBUM
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(height: 40),

        const Text(
          "Anh Thanh Niên",
          style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        const Text(
          "HuyR",
          style: TextStyle(
              fontSize: 16,
              color: Colors.white70),
        ),

        const SizedBox(height: 20),

        const Icon(Icons.favorite,
            color: Colors.purple, size: 30),

        const Spacer(),

        /// CONTROL
        
      ],
    );
  }
}