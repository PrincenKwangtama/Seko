class CarModel {
  final String carId;
  final int? bags;
  final String? carClass;
  final String? carImage;
  final String? carName;
  final String? carPower;
  final double? carPrice;
  final double? carRating;
  final int? people;
  final bool? isRotated;

  CarModel({
    required this.carId,
    this.bags,
    this.carClass,
    this.carImage,
    this.carName,
    this.carPower,
    this.carPrice,
    this.carRating,
    this.people,
    this.isRotated,
  });
}
