from fastapi import APIRouter
from app.api.v1.routes.system import router as system_router

router_v1 = APIRouter(prefix="/api/v1")

router_v1.include_router(system_router)