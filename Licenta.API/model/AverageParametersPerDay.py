from pydantic import BaseModel

class AverageParametersPerDay(BaseModel):
    average_temperature: float
    average_light_level: float
    average_air_moisture: float
    average_soil_moisture: float