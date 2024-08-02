import 'package:bit_life_like/Classes/objects/real_estate.dart';
import 'package:bit_life_like/services/real_estate/real_estate.dart';

abstract class RealEstateSeller {
  String sellerType;
  RealEstateService service;

  RealEstateSeller(this.sellerType, this.service);

  Future<List<RealEstate>> getProperties();
}

class VillaSeller extends RealEstateSeller {
  VillaSeller(RealEstateService service) : super("Villa", service);

  @override
  Future<List<RealEstate>> getProperties() {
    return service.getPropertiesByType("Villa");
  }
}

class ApartmentSeller extends RealEstateSeller {
  ApartmentSeller(RealEstateService service) : super("Apartment", service);

  @override
  Future<List<RealEstate>> getProperties() {
    return service.getPropertiesByType("Apartment");
  }
}

class ExoticEstateSeller extends RealEstateSeller {
  ExoticEstateSeller(RealEstateService service) : super("Exotic", service);

  @override
  Future<List<RealEstate>> getProperties() {
    return service.getPropertiesByType("Exotic");
  }
}
