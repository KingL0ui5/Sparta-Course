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
    else:
        print("Failed to save starships")



class Starships:
    def __init__(self):
        self.starships = db['starships']

    def get_pilot_id(self):
        """ Getter for pilot id """
        return db.self.starships.distinct('pilot_id')

    # replace pilots and insert ids
    def replace_pilots(self):
        """ Replaces pilot ids with new ids """
        db.self.starships.find_one_and_replace(
            {'pilot_id': {'$in': self.get_pilot_id()}}, )

    # add transformed data to your mongo database
    def add_transfomred_data(self):
        """ Adds new data to database """
        pass


# - Use functions
# - Add basic testing
# - Bring in other collections from the api and implement referencing for them (species, vehicles etc.)
# - Do the same for another API (e.g. pokemon api or similar)

if __name__ == '__main__':
    test = Starships()
    test.get_pilot_id()
