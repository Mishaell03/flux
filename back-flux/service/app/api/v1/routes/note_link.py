from fastapi import APIRouter, Depends, Request
from sqlalchemy.orm import Session

from app.db import get_db
from app.core.session import get_current_session
from app.db.models import NoteLink, RegistrationSession
from app.api.v1.schemas.note_link import (
    NoteLinksPushRequest,
    NoteLinksGetResponse,
    NoteLinksItemResponse,
)
from app.core.user_event_logs import user_event_logs

router = APIRouter(prefix="/note-links", tags=["Note Links"])

@router.get("", response_model=NoteLinksGetResponse)
async def get_links(
    request: Request,
    session: RegistrationSession = Depends(get_current_session),
    db: Session = Depends(get_db),
):
    rows = (
        db.query(NoteLink)
        .join(NoteLink.from_note)
        .filter(NoteLink.from_note.has(user_id=session.user_id))
        .all()
    )

    user_event_logs(
        db=db,
        request=request,
        event="NOTE_LINKS_GET",
        user_id=session.user_id,
        session_id=session.id,
        device_id=session.device_id,
        platform=session.platform,
    )

    return NoteLinksGetResponse(
        links=[
            NoteLinksItemResponse(
                from_note_id=r.from_note_id,
                to_note_id=r.to_note_id,
                weight=r.weight,
                created_at=r.created_at,
            )
            for r in rows
        ]
    )

@router.get("/{note_id}", response_model=NoteLinksGetResponse)
async def get_note_links(
    note_id: str,
    request: Request,
    session: RegistrationSession = Depends(get_current_session),
    db: Session = Depends(get_db),
):
    rows = (
        db.query(NoteLink)
        .filter(
            NoteLink.from_note_id == note_id
        )
        .all()
    )

    return NoteLinksGetResponse(
        links=[
            NoteLinksItemResponse(
                from_note_id=r.from_note_id,
                to_note_id=r.to_note_id,
                weight=r.weight,
                created_at=r.created_at,
            )
            for r in rows
        ]
    )

@router.post("/push")
async def push_links(
    request: Request,
    data: NoteLinksPushRequest,
    session: RegistrationSession = Depends(get_current_session),
    db: Session = Depends(get_db),
):
    # 1. удалить старые связи
    db.query(NoteLink).filter(
        NoteLink.from_note_id == data.from_note_id
    ).delete()

    # 2. вставить новые
    for link in data.links:
        db.add(
            NoteLink(
                from_note_id=data.from_note_id,
                to_note_id=link.to_note_id,
                weight=link.weight,
            )
        )

    db.commit()

    user_event_logs(
        db=db,
        request=request,
        event="NOTE_LINKS_PUSH",
        user_id=session.user_id,
        session_id=session.id,
        device_id=session.device_id,
        platform=session.platform,
    )

    return {"success": True}

