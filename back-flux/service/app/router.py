from fastapi import APIRouter
from app.api.v1.routes.system import router as system_router
from app.api.v1.routes.auth import router as auth_router
from app.api.v1.routes.session import router as session_router
from app.api.v1.routes.sync import router as sync_router
from app.api.v1.routes.note_link import router as note_link_router
from app.api.v1.routes.user import router as user_router

router_v1 = APIRouter(prefix="/api/v1")

router_v1.include_router(system_router)
router_v1.include_router(auth_router)
router_v1.include_router(session_router)
router_v1.include_router(sync_router)
router_v1.include_router(note_link_router)
router_v1.include_router(user_router)