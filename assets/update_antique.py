#!/usr/bin/env python3

import json

def determine_capacity(building_type):
    capacity_mapping = {
        "Immeuble": 100,
        "Gratte-ciel": 500,
        "Immeuble commercial": 150,
        "Immeuble mixte": 120,
        "Appartement": 80,
    }
    return capacity_mapping.get(building_type, 0)

def update_real_estate(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as file:
        data = json.load(file)
    for real_estate in data['real_estate']:
        if 'condition' in real_estate:
            real_estate['condition'] = 100
        if 'capacity' in real_estate:
            real_estate['capacity'] = determine_capacity(real_estate.get('type', 'Unknown'))
    #for antique in data['antiques']:
        # Set default values for 'rarete' and 'epoque'
        #if 'rarete' not in antique:
        #    antique['rarete'] = "Common"
        #if 'epoque' not in antique:
        #    antique['epoque'] = "Unknown"

        # Remove 'age' field if it exists
        #antique.pop('age', None)
        
        # Convert 'valeur' to float
        #if 'valeur' in antique:
        #    try:
        #        antique['valeur'] = float(antique['valeur'])
        #    except (ValueError, TypeError):
        #        antique['valeur'] = 0.0  # Default to 0.0 if conversion fails
    # Add new buildings for businesses
    new_buildings = [
        {
            "nom": "Tour de bureaux moderne",
            "age": 5,
            "valeur": 8000000,
            "type": "Immeuble commercial",
            "condition": 100,
            "monthly_maintenance_cost": 7000,
            "capacity": determine_capacity("Immeuble commercial")
        },
        {
            "nom": "Centre d'affaires multiprise",
            "age": 8,
            "valeur": 15000000,
            "type": "Immeuble",
            "condition": 100,
            "monthly_maintenance_cost": 10000,
            "capacity": determine_capacity("Immeuble")
        },
        {
            "nom": "Complexe de bureaux de luxe",
            "age": 12,
            "valeur": 20000000,
            "type": "Immeuble mixte",
            "condition": 100,
            "monthly_maintenance_cost": 15000,
            "capacity": determine_capacity("Immeuble mixte")
        },
        {
            "nom": "Gratte-ciel ultra moderne",
            "age": 3,
            "valeur": 50000000,
            "type": "Gratte-ciel",
            "condition": 100,
            "monthly_maintenance_cost": 25000,
            "capacity": determine_capacity("Gratte-ciel")
        },
        {
            "nom": "Parc technologique avancé",
            "age": 15,
            "valeur": 30000000,
            "type": "Immeuble commercial",
            "condition": 100,
            "monthly_maintenance_cost": 12000,
            "capacity": determine_capacity("Immeuble commercial")
        }
    ]

    data['real_estate'].extend(new_buildings)

    with open(output_file, 'w', encoding='utf-8') as file:
        json.dump(data, file, ensure_ascii=False, indent=2)

# Usage
#update_antiques('antiques.json', 'updated_antiques.json')
update_real_estate('real_estate.json', 'updated_real_estate.json')
