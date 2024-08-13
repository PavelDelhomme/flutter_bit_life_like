import json

# Charger les données du fichier JSON
with open('real_estate.json', 'r', encoding='utf-8') as f:
    real_estate_data = json.load(f)

# Ajouter le champ "style" avec la valeur "Classic" si absent
for estate in real_estate_data.get("real_estate", []):
    if 'style' not in estate:
        estate['style'] = "Classic"

# Sauvegarder les modifications dans le fichier JSON
with open('real_estate.json', 'w', encoding='utf-8') as f:
    json.dump(real_estate_data, f, ensure_ascii=False, indent=4)

print("Mise à jour du fichier JSON terminée.")
