from fastapi import APIRouter
from app.api.v1.routes.system import router as system_router
from app.api.v1.routes.auth import router as auth_router

router_v1 = APIRouter(prefix="/api/v1")

router_v1.include_router(system_router)
router_v1.include_router(auth_router)