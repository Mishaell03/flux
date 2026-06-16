from fastapi import APIRouter

router = APIRouter(prefix="/health", tags=["Health"])

@router.get("/users-service")
async def health():
    return {"status": "ok"}