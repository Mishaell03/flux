from fastapi import FastAPI
from app.router import router_v1
from app.core.config import settings
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="Flux",
    description="Flux API base URL: /api/v1",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(router_v1)

if __name__ == "__main__":
    import uvicorn

    uvicorn.run(
        "main:app",
        host=settings.api_host,
        port=settings.api_port,
        reload=settings.api_reload,
    )