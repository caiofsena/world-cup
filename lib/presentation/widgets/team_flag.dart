import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TeamFlag extends StatelessWidget {
  final String flagCode;
  final double size;
  final String? teamName;

  const TeamFlag({
    required this.flagCode,
    this.size = 24,
    this.teamName,
  });

  @override
  Widget build(BuildContext context) {
    final url = 'https://flagcdn.com/w80/${flagCode.toLowerCase()}.png';
    return Tooltip(
      message: teamName ?? flagCode.toUpperCase(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: CachedNetworkImage(
          imageUrl: url,
          width: size,
          height: size * 0.67,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            width: size,
            height: size * 0.67,
            color: Colors.grey[300],
            child: const Icon(Icons.flag, size: 16),
          ),
          errorWidget: (_, __, ___) => Container(
            width: size,
            height: size * 0.67,
            color: Colors.grey[300],
            child: Text(
              flagCode.toUpperCase(),
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
