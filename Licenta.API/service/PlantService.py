import serial.tools.list_ports
import datetime

from model.AverageParametersPerDay import AverageParametersPerDay
from model.IdealParametersObject import IdealParametersObject
from model.PlantDTO import PlantDTO
from model.RealParametersObject import RealParametersObject


class PlantService:
    def __init__(self, plant_repo):
        self.__plant_repo = plant_repo
        self.__serialPort = serial.Serial('COM4', 9600)

    def __read_from_arduino(self):
        try:
            data = self.__serialPort.readline().decode().strip()
            return tuple(map(float, data.split(',')))
        except Exception as arduinoException:
            raise Exception("[Arduino exception] ", str(arduinoException))

    def get_real_parameters(self) -> RealParametersObject:
        temperature, lightLevel, airMoisture, soilMoisture = self.__read_from_arduino()
        self.__plant_repo.insert_real_parameters(temperature, lightLevel, airMoisture, soilMoisture)
        #self.__plant_repo.insert_real_parameters(27, 60.2, 53, 40.5)
        return self.__plant_repo.get_real_parameters()

    def get_plants(self) -> list[PlantDTO]:
        return self.__plant_repo.get_plants()

    def get_ideal_parameters(self, species) -> IdealParametersObject:
        return self.__plant_repo.get_ideal_parameters(species)

    def __get_real_parameters_per_day(self, day) -> list[RealParametersObject]:
        currentTime = (datetime.datetime.today() - datetime.timedelta(days=day)).strftime("%Y-%m-%d")
        return self.__plant_repo.get_real_parameters_per_day(currentTime)

    def __calculate_average_per_day(self, day):
        real_parameters_per_day = self.__get_real_parameters_per_day(day)
        length = len(real_parameters_per_day)
        if length == 0:
            return 0.0, 0.0, 0.0, 0.0
        sum_temperatures = 0
        sum_air_moistures = 0
        sum_light_levels = 0
        sum_soil_moistures = 0
        for parameters_tuple in real_parameters_per_day:
            sum_temperatures = sum_temperatures + parameters_tuple.real_temperature
            sum_light_levels = sum_light_levels + parameters_tuple.real_light_level
            sum_air_moistures = sum_air_moistures + parameters_tuple.real_air_moisture
            sum_soil_moistures = sum_soil_moistures + parameters_tuple.real_soil_moisture
        return round(sum_temperatures / length, 2), round(sum_light_levels / length, 2), \
               round(sum_air_moistures / length, 2), round(sum_soil_moistures / length, 2)

    def calculate_average_parameters_per_week(self) -> list[AverageParametersPerDay]:
        avg_parameters_per_week = []
        for day in range(0, 7):
            avg_temperature, avg_light_level,\
            avg_air_moisture, avg_soil_moisture = self.__calculate_average_per_day(day)
            avg_parameters_per_day = AverageParametersPerDay(average_temperature=avg_temperature,
                                                             average_light_level=avg_light_level,
                                                             average_air_moisture=avg_air_moisture,
                                                             average_soil_moisture=avg_soil_moisture
                                                             )
            avg_parameters_per_week.append(avg_parameters_per_day)
        return avg_parameters_per_week
