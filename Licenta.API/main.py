import sqlite3
from typing import Any

from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware

from repository.PlantRepo import PlantRepo

from service.PlantService import PlantService

from model.AverageParametersPerDay import AverageParametersPerDay
from model.IdealParametersObject import IdealParametersObject
from model.PlantDTO import PlantDTO
from model.RealParametersObject import RealParametersObject

db_connection = sqlite3.connect('plantMonitoring.db')

app = FastAPI()

# routes for plant
plant_repo = PlantRepo(db_connection)
plant_service = PlantService(plant_repo)

# 192.168.136.100 - hotspot
# 192.168.0.102 - acasa
origins = ['http://localhost:8000','http://192.168.240.100:80']

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/real_parameters/", response_model=RealParametersObject)
async def get_real_parameters() -> RealParametersObject:
    return plant_service.get_real_parameters()

@app.get("/plants/", response_model=list[PlantDTO])
async def get_plants() -> Any:
    return plant_service.get_plants()

@app.get("/plants/{species}", response_model=IdealParametersObject)
async def get_ideal_parameters(species: str) -> IdealParametersObject:
    return plant_service.get_ideal_parameters(species)

@app.get("/average_parameters_per_week/", response_model=list[AverageParametersPerDay])
async def get_average_parameters_per_week() -> list[AverageParametersPerDay]:
    return plant_service.calculate_average_parameters_per_week()

@app.on_event("shutdown")
async def shutdown():
    db_connection.close()
