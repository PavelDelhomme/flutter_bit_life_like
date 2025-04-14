class CraftingRecipe {
  final String id;
  final String resultItemType; // Ex: 'weapon'
  final List<String> requiredComponentIds;
  final Map<String, int> quantities;
  final Map<String, double> requiredSkills;


  CraftingRecipe({
    required this.id,
    required this.resultItemType,
    required this.requiredComponentIds,
    required this.quantities,
    required this.requiredSkills,
  });
}
