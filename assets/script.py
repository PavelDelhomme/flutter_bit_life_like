import json

def func(filename):
    try:
        with open(filename, 'r', encoding='utf-8') as file:
            data = json.load(file)

        if "real_estate_exotique" in data:
            for estate in data["real_estate_exotique"]:
                if "style" not in estate:
                    estate["style"] = "Exotic"
                    print(f"Added 'style': 'Exotic' to {estate['nom']}")
                else:
                    print(f"'style' already present in {estate['nom']}")

        with open(filename, 'w', encoding='utf-8') as file:
            json.dump(data, file, ensure_ascii=False, indent=2)

        print("Updated real estate data successfully.")

    except FileNotFoundError:
        print(f"File {filename} not found.")
    except json.JSONDecodeError:
        print("Error decoding JSON from the file.")
    except Exception as e:
        print(f"An error occured : {e}")

func('/home/pavel/StudioProjects/bit_life_like/assets/real_estate_exotic.json')
