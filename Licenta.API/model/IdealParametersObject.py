from pydantic import BaseModel


class IdealParametersObject(BaseModel):
    id: int
    species: str
    lowest_temperature: float
    highest_temperature: float
    highest_light_level: float
    highest_soil_moisture: float
    lowest_soil_moisture: float
    highest_air_moisture: float
    lowest_air_moisture: float
