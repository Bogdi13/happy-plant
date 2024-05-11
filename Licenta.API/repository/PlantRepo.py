import datetime

from model.IdealParametersObject import IdealParametersObject
from model.PlantDTO import PlantDTO
from model.RealParametersObject import RealParametersObject


class PlantRepo:
    def __init__(self, connection):
        self.__connection = connection

    def insert_real_parameters(self, temperature, lightLevel, airMoisture, soilMoisture):
        try:
            cursor = self.__connection.cursor()
            currentTime = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            cursor.execute(
                'INSERT INTO RealParameters (Temperature, LightLevel, AirMoisture, SoilMoisture, CurrentTime) VALUES '
                '(?, ?, ?, ?, ?)',
                (temperature, lightLevel, airMoisture, soilMoisture, currentTime)
            )
            self.__connection.commit()
        except Exception as sqliteException:
            raise Exception("[DB exception] ", str(sqliteException))

    def get_real_parameters(self) -> RealParametersObject:
        try:
            cursor = self.__connection.cursor()
            cursor.execute('SELECT * FROM RealParameters ORDER BY Id DESC LIMIT 1')
            row = cursor.fetchall()
            real_parameters_object = RealParametersObject(id=row[0][0],
                                                              real_temperature=row[0][1],
                                                              real_light_level=row[0][2],
                                                              real_air_moisture=row[0][3],
                                                              real_soil_moisture=row[0][4]
                                                              )
            cursor.close()
            return real_parameters_object
        except Exception as sqliteException:
            raise Exception("[DB exception] ", str(sqliteException))

    def get_plants(self) -> list[PlantDTO]:
        try:
            cursor = self.__connection.cursor()
            cursor.execute('SELECT Id, Species FROM Plants')
            rows =  cursor.fetchall()
            plantsDTO = []
            for row in rows:
                plantDTO = PlantDTO(id=row[0], species=row[1])
                plantsDTO.append(plantDTO)
            cursor.close()
            return plantsDTO
        except Exception as sqliteException:
            raise Exception("[DB exception] ", str(sqliteException))

    def get_ideal_parameters(self, species):
        try:
            cursor = self.__connection.cursor()
            cursor.execute('SELECT * FROM Plants WHERE Species=?', (species,))
            row = cursor.fetchall()
            ideal_parameters_object = IdealParametersObject(id=row[0][0], species=row[0][1], lowest_temperature= row[0][2], highest_temperature=row[0][3], highest_light_level = row[0][4], lowest_soil_moisture = row[0][5], highest_soil_moisture = row[0][6], lowest_air_moisture = row[0][7], highest_air_moisture = row[0][8])
            cursor.close()
            return ideal_parameters_object
        except Exception as sqliteException:
            raise Exception("[DB exception] ", str(sqliteException))

    def get_real_parameters_per_day(self, currentTime) -> list[RealParametersObject]:
        try:
            cursor = self.__connection.cursor()
            cursor.execute('SELECT * FROM RealParameters WHERE CurrentTime LIKE ?', (f"{currentTime}%",))
            rows = cursor.fetchall()
            real_parameters_objects_per_day = []
            for row in rows:
                real_parameters_object = RealParametersObject(id=row[0],
                                                              real_temperature=row[1],
                                                              real_light_level=row[2],
                                                              real_air_moisture=row[3],
                                                              real_soil_moisture=row[4]
                                                              )
                real_parameters_objects_per_day.append(real_parameters_object)
            cursor.close()
            return real_parameters_objects_per_day
        except Exception as sqliteException:
            raise Exception("[DB exception] ", str(sqliteException))
