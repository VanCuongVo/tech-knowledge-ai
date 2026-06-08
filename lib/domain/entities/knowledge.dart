import 'package:equatable/equatable.dart';

class Knowledge extends Equatable {
  final int id;
  final String category;
  final String name;
  final String description;
  final List<String> keywords;
  final String rawData;
  final String imageUrl;

  const Knowledge({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.keywords,
    required this.rawData,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    category,
    name,
    description,
    keywords,
    rawData,
    imageUrl,
  ];
}
