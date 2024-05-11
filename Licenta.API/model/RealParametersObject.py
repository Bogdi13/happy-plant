from pydantic import BaseModel


class RealParametersObject(BaseModel):
    id: int
    real_temperature: float
    real_light_level: float
    real_air_moisture: float
    real_soil_moisture: float
