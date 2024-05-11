from pydantic import BaseModel


class PlantDTO(BaseModel):
    id: int
    species: str
