"""
This is a node made specifically for writing to json
{
         "id":"Holden Hall",
         "image":"https://lh3.googleusercontent.com/tpBMFN5os8K-qXIHiAX5SZEmN5fCzIGrj9FdJtbZPUkC91ookSoY520NYn7fK5yqmh1L1m3F2SJA58v6Qps3JusdrxoFSwk6Ajv2K88",
         "lat":33.58550,
         "lng":-101.87325,
         "description":"Holden Hall Entrance",
         "type":"Entrance"
 
     }
"""

class NodeJson:
    def __init__(self, id, image, lat, lng, description, type):
        self.id = id
        self.image = image
        self.lat = lat
        self.lng = lng
        self.description = description
        self.type = type

    
    def get_coordinates(self):
        return (self.latitude, self.longitude)
    def get_lat(self):
        return self.latitude
    def get_long(self):
        return self.longitude
    def get_name(self):
        return self.name
    def toString(self):
        return str(self.latitude) + ", " + str(self.longitude) + ", " + self.name