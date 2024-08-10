#!/usr/bin/env python3

import json

def update_antiques(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as file:
        data = json.load(file)
    
    for antique in data['antiques']:
        # Set default values for 'rarete' and 'epoque'
        if 'rarete' not in antique:
            antique['rarete'] = "Common"
        if 'epoque' not in antique:
            antique['epoque'] = "Unknown"

        # Remove 'age' field if it exists
        antique.pop('age', None)
        
        # Convert 'valeur' to float
        if 'valeur' in antique:
            try:
                antique['valeur'] = float(antique['valeur'])
            except (ValueError, TypeError):
                antique['valeur'] = 0.0  # Default to 0.0 if conversion fails

    with open(output_file, 'w', encoding='utf-8') as file:
        json.dump(data, file, ensure_ascii=False, indent=2)

# Usage
update_antiques('antiques.json', 'updated_antiques.json')

