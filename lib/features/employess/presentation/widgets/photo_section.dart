import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PhotoSection extends StatelessWidget {
  final File? photoFile;
  final VoidCallback onTakePhoto;
  final VoidCallback onRemovePhoto;
  final String label;
  final String? photoUrl;

  const PhotoSection({
    super.key,
    required this.photoFile,
    required this.onTakePhoto,
    required this.onRemovePhoto,
    required this.label,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTakePhoto,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey, width: 2, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(10),
        ),
        child: photoFile != null || (photoUrl != null && photoUrl != '')
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: photoFile == null
                        ? CachedNetworkImage(
                            imageUrl: photoUrl!,
                            fit: BoxFit.cover,
                          )
                        : Image.file(photoFile!, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: onRemovePhoto,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            size: 20, color: Colors.red),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text(label, style: const TextStyle(color: Colors.grey)),
                ],
              ),
      ),
    );
  }
}
