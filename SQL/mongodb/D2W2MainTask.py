import requests
import pymongo

client = pymongo.MongoClient()
db = client['StarWars']


def fetch_swapi_data():
    """ Fetches data from swapi """
    url = f"https://swapi.info/api/starships"
    try:
        response = requests.get(url)
        response.raise_for_status()
        data = response.json()
        return data

    except Exception as e:
        print(f"Error: {e}")
        return []


def save_starships():
    starships_raw = fetch_swapi_data()
    if starships_raw:
            collection = db['starships']
            collection.insert_many(starships_raw)
            print("Successfully saved starships")



class Starships:
    def __init__(self):
        self.starships = db['starships']
        self.characters = db['characters']

    def get_pilot_id(self):
        """ Getter for pilot id """
        return self.starships.distinct('pilot_id')

    def replace_pilots(self):
        """ Replaces pilot urls with new ObjectIds from characters """
        transformed_ships = []

        for document in self.starships.find({"pilot_id": {"$exists": True}}):
            ship = dict(document)
            pilot_url = ship.get('pilot_id')

            character = self.characters.find_one({"url": pilot_url})

            if character:
                ship['pilot_id'] = character['_id']
                transformed_ships.append(ship)

        return transformed_ships


    # add transformed data to your mongo database
    def add_transformed_data(self, updated_starships):
        """ Adds new data to database """
        count = 0
        for ship in updated_starships:
            if 'pilot_id' in ship:
                self.starships.update_one(
                    {"_id": ship['_id']},
                    {"$set": {"pilot_id": ship['pilot_id']}}
                )
                count += 1
        return True


# - Use functions
# - Add basic testing
# - Bring in other collections from the api and implement referencing for them (species, vehicles etc.)
# - Do the same for another API (e.g. pokemon api or similar)

if __name__ == '__main__':
    save_starships()
    test = Starships()
    modified_data = test.replace_pilots()
    test.add_transformed_data(modified_data)
    print(test.get_pilot_id())
