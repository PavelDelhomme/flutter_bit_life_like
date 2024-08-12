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

def update_data(input_file, output_file, exotic=False):
    with open(input_file, 'r', encoding='utf-8') as file:
        data = json.load(file)

    key = 'real_estate_exotique' if exotic else 'real_estate'

    for real_estate in data[key]:
        # Ensure 'valeur' is a float
        if 'valeur' in real_estate:
            try:
                real_estate['valeur'] = float(real_estate['valeur'])
            except ValueError:
                real_estate['valeur'] = 0.0

        # Ensure 'monthly_maintenance_cost' is a float
        if 'monthly_maintenance_cost' in real_estate:
            try:
                real_estate['monthly_maintenance_cost'] = float(real_estate['monthly_maintenance_cost'])
            except ValueError:
                real_estate['monthly_maintenance_cost'] = 0.0

        # Update 'condition' to a percentage for exotic estates
        if exotic:
            condition_mapping = {
                "New": 100.0,
                "Excellent": 90.0,
                "Good": 75.0
            }
            condition_str = real_estate.get('condition', 'Unknown')
            real_estate['condition'] = condition_mapping.get(condition_str, 50.0)
        else:
            # Ensure 'condition' is a float
            if 'condition' in real_estate:
                try:
                    real_estate['condition'] = float(real_estate['condition'])
                except ValueError:
                    real_estate['condition'] = 100.0

        # Set default capacity if not present
        if 'capacity' not in real_estate:
            real_estate['capacity'] = determine_capacity(real_estate.get('type', 'Unknown'))

    with open(output_file, 'w', encoding='utf-8') as file:
        json.dump(data, file, ensure_ascii=False, indent=2)

# Usage
update_data('real_estate.json', 'updated_real_estate.json')
update_data('real_estate_exotic.json', 'updated_real_estate_exotic.json', exotic=True)
