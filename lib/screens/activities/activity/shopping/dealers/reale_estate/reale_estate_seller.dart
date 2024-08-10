import 'package:bit_life_like/Classes/objects/real_estate.dart';
import 'package:bit_life_like/services/real_estate/real_estate.dart';

abstract class RealEstateSeller {
  String sellerType;
  String style;
  RealEstateService service;

  RealEstateSeller(this.sellerType, this.style, this.service);

  Future<List<RealEstate>> getProperties();
}

class VillaSeller extends RealEstateSeller {
  VillaSeller(RealEstateService service) : super("Villa", "Classic", service);

  @override
  Future<List<RealEstate>> getProperties() {
    return service.getPropertiesByTypeAndStyle(sellerType, style);
  }
}

class ApartmentSeller extends RealEstateSeller {
  ApartmentSeller(RealEstateService service) : super("Apartment", "Classic", service);

  @override
  Future<List<RealEstate>> getProperties() {
    return service.getPropertiesByTypeAndStyle(sellerType, style);
  }
}

class ExoticEstateSeller extends RealEstateSeller {
  ExoticEstateSeller(RealEstateService service) : super("Exotic", "Exotic", service);

  @override
  Future<List<RealEstate>> getProperties() {
    return service.getPropertiesByTypeAndStyle(sellerType, style);
  }
}