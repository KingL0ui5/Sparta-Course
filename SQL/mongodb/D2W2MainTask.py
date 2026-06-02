import requests
import pymongo

client = pymongo.MongoClient()
db = client['StarWars']

class Starships:
    def __init__():
        starships = db['StarShips']

    # get pilot ids from mongodb
    def get_pilot_id():
        return db.starships.distinct('pilot_id')

    # replace pilots and insert ids
    def replace_pilots():
        pass

    # add transformed data to your mongo database
    def add_transfomred_data():
        pass


# - Use functions
# - Add basic testing
# - Bring in other collections from the api and implement referencing for them (species, vehicles etc.)
# - Do the same for another API (e.g. pokemon api or similar)

if __name__ == '__main__':
    pilot_ids = get_pilot_id()
    print(pilot_ids)
