import 'dart:io';

class ImageModel {
  final String? imageUrl;
  final File? file;
  final String? caption;

  ImageModel({
    this.imageUrl,
    this.file,
    this.caption,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imageUrl: json['imageUrl'],
      file: json['file'] != null ? File(json['file']) : null,
      caption: json['caption'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'imageUrl': imageUrl,
      'file': file != null ? file!.path : null,
      'caption': caption,
    };
    return data;
  }
}

class ImageAndCaptionModel {
  final ImageModel image;
  final String caption;

  ImageAndCaptionModel({
    required this.image,
    required this.caption,
  });

  factory ImageAndCaptionModel.fromJson(Map<String, dynamic> json) {
    return ImageAndCaptionModel(
      image: ImageModel.fromJson(json['image']),
      caption: json['caption'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image.toJson(),
      'caption': caption,
    };
  }
}
