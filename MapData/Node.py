class Node:
    def __init__(self, latitude, longitude, name):
        self.latitude = latitude
        self.longitude = longitude
        self.name = name

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