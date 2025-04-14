import 'package:bitlife_like/models/marketplace.dart';

import 'market.dart';

class ComponentMarket extends Market {
  ComponentMarket(String location)
    : super(
    location: location,
    availableCategories: [MarketplaceCategory.components],
    priceMultiplier: 1.0,
  );
}