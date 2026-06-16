from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import (
    BigInteger,
    Boolean,
    DateTime,
    ForeignKey,
    Index,
    Integer,
    String,
    Text,
    func,
)
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db import Base


# v1 Users
class User(Base):
    __tablename__ = "users"

    user_id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    name: Mapped[str | None] = mapped_column(String(64), nullable=True)
    phone: Mapped[str | None] = mapped_column(Text, unique=True, nullable=True)
    email: Mapped[str | None] = mapped_column(Text, unique=True, nullable=True)
    img: Mapped[str | None] = mapped_column(Text, nullable=True)
    status: Mapped[str | None] = mapped_column(Text, nullable=True)

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
    )

    registration_sessions: Mapped[list["RegistrationSession"]] = relationship(
        back_populates="user",
        cascade="all, delete-orphan",
    )

    notes: Mapped[list["Note"]] = relationship(
        back_populates="user",
        cascade="all, delete-orphan",
    )

    reminders: Mapped[list["Reminder"]] = relationship(
        back_populates="user",
        cascade="all, delete-orphan",
    )

    sync_queue: Mapped[list["SyncQueue"]] = relationship(
        back_populates="user",
        cascade="all, delete-orphan",
    )

    sync_states: Mapped[list["SyncState"]] = relationship(
        back_populates="user",
        cascade="all, delete-orphan",
    )


Index("ix_users_phone", User.phone)


# v2 Providers
class Provider(Base):
    __tablename__ = "providers"

    code: Mapped[str] = mapped_column(String(20), primary_key=True)
    name: Mapped[str] = mapped_column(String(50), unique=True, nullable=False)


# v3 Registration sessions
class RegistrationSession(Base):
    __tablename__ = "registration_sessions"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)

    device_id: Mapped[str] = mapped_column(String(255), nullable=False)

    user_id: Mapped[int] = mapped_column(
        ForeignKey("users.user_id", ondelete="CASCADE"),
        nullable=False,
    )

    session_token_hash: Mapped[str] = mapped_column(Text, unique=True, nullable=False)
    refresh_token_hash: Mapped[str | None] = mapped_column(Text, nullable=True)

    language: Mapped[str | None] = mapped_column(String(8), nullable=True)

    provider: Mapped[str | None] = mapped_column(
        ForeignKey("providers.code", ondelete="CASCADE"),
        nullable=True,
    )

    app_version: Mapped[str | None] = mapped_column(String(32), nullable=True)
    device_name: Mapped[str | None] = mapped_column(String(64), nullable=True)
    platform: Mapped[str | None] = mapped_column(String(16), nullable=True)

    is_verified: Mapped[bool] = mapped_column(Boolean, default=False)
    revoked: Mapped[bool] = mapped_column(Boolean, default=False)

    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    revoked_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
    )

    user: Mapped["User"] = relationship(back_populates="registration_sessions")

    notes: Mapped[list["Note"]] = relationship(back_populates="last_session")


Index("ix_sessions_user_id", RegistrationSession.user_id)
Index("ix_sessions_device_id", RegistrationSession.device_id)
Index("ix_sessions_token", RegistrationSession.session_token_hash)
Index("ix_sessions_expires_at", RegistrationSession.expires_at)
Index("ix_sessions_provider", RegistrationSession.provider)

Index(
    "ix_sessions_active",
    RegistrationSession.user_id,
    postgresql_where=RegistrationSession.revoked_at.is_(None),
)


# v4 Notes
class Note(Base):
    __tablename__ = "notes"

    note_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
    )

    user_id: Mapped[int] = mapped_column(
        ForeignKey("users.user_id", ondelete="CASCADE"),
        nullable=False,
    )

    title: Mapped[str | None] = mapped_column(Text, nullable=True)
    content: Mapped[str | None] = mapped_column(Text, nullable=True)

    version: Mapped[int] = mapped_column(Integer, default=0, nullable=False)

    deleted: Mapped[bool] = mapped_column(Boolean, default=False)
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    last_session_id: Mapped[int | None] = mapped_column(
        ForeignKey("registration_sessions.id"),
        nullable=True,
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
    )

    user: Mapped["User"] = relationship(back_populates="notes")

    last_session: Mapped["RegistrationSession | None"] = relationship(back_populates="notes")


Index("ix_notes_user_id", Note.user_id)
Index("ix_notes_updated_at", Note.updated_at)
Index("ix_notes_deleted", Note.deleted)


# GIN indexes (FTS)
Index(
    "ix_notes_title_gin",
    func.to_tsvector("simple", Note.title),
    postgresql_using="gin",
)

Index(
    "ix_notes_content_gin",
    func.to_tsvector("simple", Note.content),
    postgresql_using="gin",
)


# v5 Reminders
class Reminder(Base):
    __tablename__ = "reminders"

    reminder_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
    )

    user_id: Mapped[int] = mapped_column(
        ForeignKey("users.user_id", ondelete="CASCADE"),
        nullable=False,
    )

    note_id: Mapped[uuid.UUID | None] = mapped_column(
        ForeignKey("notes.note_id", ondelete="CASCADE"),
        nullable=True,
    )

    title: Mapped[str | None] = mapped_column(Text, nullable=True)

    remind_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)

    repeat_rule: Mapped[dict | None] = mapped_column(JSONB, nullable=True)

    is_done: Mapped[bool] = mapped_column(Boolean, default=False)
    deleted: Mapped[bool] = mapped_column(Boolean, default=False)

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
    )

    user: Mapped["User"] = relationship(back_populates="reminders")


Index("ix_reminders_user_id", Reminder.user_id)
Index("ix_reminders_remind_at", Reminder.remind_at)
Index("ix_reminders_note_id", Reminder.note_id)
Index("ix_reminders_active", Reminder.user_id, Reminder.remind_at, Reminder.is_done)


# v6 Note links
class NoteLink(Base):
    __tablename__ = "note_links"

    link_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)

    from_note_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("notes.note_id", ondelete="CASCADE"),
        nullable=False,
    )

    to_note_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("notes.note_id", ondelete="CASCADE"),
        nullable=False,
    )

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


Index("ix_links_from", NoteLink.from_note_id)
Index("ix_links_to", NoteLink.to_note_id)
Index("uq_note_links_pair", NoteLink.from_note_id, NoteLink.to_note_id, unique=True)


# v7 Sync queue
class SyncQueue(Base):
    __tablename__ = "sync_queue"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)

    user_id: Mapped[int] = mapped_column(ForeignKey("users.user_id"), nullable=False)

    session_id: Mapped[int | None] = mapped_column(
        ForeignKey("registration_sessions.id"),
        nullable=True,
    )

    entity_type: Mapped[str] = mapped_column(Text, nullable=False)
    entity_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), nullable=False)
    operation: Mapped[str] = mapped_column(Text, nullable=False)

    payload: Mapped[dict | None] = mapped_column(JSONB, nullable=True)

    status: Mapped[str] = mapped_column(Text, default="pending")
    retry_count: Mapped[int] = mapped_column(Integer, default=0)

    last_error: Mapped[str | None] = mapped_column(Text, nullable=True)

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    user: Mapped["User"] = relationship(back_populates="sync_queue")


Index("ix_sync_user", SyncQueue.user_id)
Index("ix_sync_status", SyncQueue.status)
Index("ix_sync_session", SyncQueue.session_id)
Index("ix_sync_created", SyncQueue.created_at)


# v8 Sync state
class SyncState(Base):
    __tablename__ = "sync_state"

    user_id: Mapped[int] = mapped_column(ForeignKey("users.user_id"), primary_key=True)
    session_id: Mapped[int] = mapped_column(ForeignKey("registration_sessions.id"), primary_key=True)

    last_sync_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    last_version: Mapped[int] = mapped_column(Integer, default=0)

    user: Mapped["User"] = relationship(back_populates="sync_states")