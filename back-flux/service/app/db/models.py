import uuid
from datetime import datetime

from sqlalchemy import (
    Boolean,
    DateTime,
    ForeignKey,
    Integer,
    String,
    Text,
    BigInteger,
    func,
    UniqueConstraint,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db import Base


# v1 PROVIDERS
class Provider(Base):
    __tablename__ = "providers"

    code: Mapped[str] = mapped_column(String(20), primary_key=True)
    name: Mapped[str] = mapped_column(String(50), unique=True, nullable=False)


# v2 USERS
class User(Base):
    __tablename__ = "users"

    user_id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    name: Mapped[str | None] = mapped_column(String(64))
    phone: Mapped[str | None] = mapped_column(String(50), unique=True, index=True)
    email: Mapped[str | None] = mapped_column(String(255), unique=True)
    img: Mapped[str | None] = mapped_column(Text)
    img_provider: Mapped[str | None] = mapped_column(
        String(20), ForeignKey("providers.code", ondelete="CASCADE"), index=True
    )
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )

    registration_sessions: Mapped[list["RegistrationSession"]] = relationship(
        back_populates="user", cascade="all, delete-orphan"
    )
    notes: Mapped[list["Note"]] = relationship(
        back_populates="user", cascade="all, delete-orphan"
    )
    reminders: Mapped[list["Reminder"]] = relationship(
        back_populates="user", cascade="all, delete-orphan"
    )
    event_logs: Mapped[list["UserEventLog"]] = relationship(
        back_populates="user", cascade="all, delete-orphan"
    )


# v3 REGISTRATION SESSIONS
class RegistrationSession(Base):
    __tablename__ = "registration_sessions"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    device_id: Mapped[str] = mapped_column(String(255), nullable=False, index=True)
    user_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey("users.user_id", ondelete="CASCADE"), nullable=False, index=True
    )
    session_token: Mapped[str | None] = mapped_column(String(255), unique=True, index=True)
    language: Mapped[str | None] = mapped_column(String(3))
    provider: Mapped[str | None] = mapped_column(
        String(20), ForeignKey("providers.code", ondelete="CASCADE"), index=True
    )
    app_version: Mapped[str | None] = mapped_column(String(32))
    device_name: Mapped[str | None] = mapped_column(String(32))
    platform: Mapped[str | None] = mapped_column(String(10))
    is_verified: Mapped[bool] = mapped_column(Boolean, default=False)
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False, index=True)
    revoked_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    user: Mapped["User"] = relationship(back_populates="registration_sessions")
    provider_rel: Mapped["Provider"] = relationship()


# v4 NOTES
class Note(Base):
    __tablename__ = "notes"

    note_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey("users.user_id", ondelete="CASCADE"), nullable=False, index=True
    )
    title: Mapped[str | None] = mapped_column(Text)
    content: Mapped[str | None] = mapped_column(Text)
    deleted: Mapped[bool] = mapped_column(Boolean, default=False, index=True)
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), index=True
    )

    user: Mapped["User"] = relationship(back_populates="notes")
    reminders: Mapped[list["Reminder"]] = relationship(back_populates="note", cascade="all, delete-orphan")
    from_links: Mapped[list["NoteLink"]] = relationship(
        foreign_keys="NoteLink.from_note_id", back_populates="from_note", cascade="all, delete-orphan"
    )
    to_links: Mapped[list["NoteLink"]] = relationship(
        foreign_keys="NoteLink.to_note_id", back_populates="to_note", cascade="all, delete-orphan"
    )


# v5 REMINDERS
class Reminder(Base):
    __tablename__ = "reminders"

    reminder_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey("users.user_id", ondelete="CASCADE"), nullable=False, index=True
    )
    note_id: Mapped[uuid.UUID | None] = mapped_column(
        ForeignKey("notes.note_id", ondelete="CASCADE"), index=True
    )
    remind_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False, index=True)
    repeat_rule: Mapped[str | None] = mapped_column(Text)
    is_done: Mapped[bool] = mapped_column(Boolean, default=False)
    deleted: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )

    user: Mapped["User"] = relationship(back_populates="reminders")
    note: Mapped["Note | None"] = relationship(back_populates="reminders")


# v6 NOTE LINKS
class NoteLink(Base):
    __tablename__ = "note_links"

    link_id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    from_note_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("notes.note_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    to_note_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("notes.note_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    weight: Mapped[int] = mapped_column(Integer, nullable=False, default=1)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now()
    )
    from_note: Mapped["Note"] = relationship(
        back_populates="from_links",
        foreign_keys=[from_note_id]
    )
    to_note: Mapped["Note"] = relationship(
        back_populates="to_links",
        foreign_keys=[to_note_id]
    )

    __table_args__ = (
        UniqueConstraint(
            "from_note_id",
            "to_note_id",
            name="uq_note_links_pair"
        ),
    )


# v7 YANDEX LOGIN SESSIONS
class YandexLoginSession(Base):
    __tablename__ = "yandex_login_sessions"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
    )

    device_id: Mapped[str] = mapped_column(String(64))
    platform: Mapped[str] = mapped_column(String(16))
    language: Mapped[str] = mapped_column(String(3))

    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    used_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))

    user_id: Mapped[int | None] = mapped_column(ForeignKey("users.user_id"))

    user: Mapped["User"] = relationship()


# v8 BACKEND ERRORS
class BackendError(Base):
    __tablename__ = "backend_errors"

    code: Mapped[str] = mapped_column(String(32), primary_key=True)
    http_status: Mapped[int] = mapped_column(Integer, nullable=False)

    localizations: Mapped[list["BackendErrorLocalization"]] = relationship(
        back_populates="error", cascade="all, delete-orphan"
    )


# v12 USER EVENT LOGS
class UserEventLog(Base):
    __tablename__ = "user_event_logs"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    user_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey("users.user_id", ondelete="SET NULL"), index=True
    )
    session_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey("registration_sessions.id", ondelete="SET NULL"), index=True
    )
    event: Mapped[str] = mapped_column(Text, nullable=False, index=True)
    request_method: Mapped[str | None] = mapped_column(String(10))
    request_path: Mapped[str | None] = mapped_column(Text)
    status_code: Mapped[int | None] = mapped_column(Integer)
    device_id: Mapped[str | None] = mapped_column(String(64))
    platform: Mapped[str | None] = mapped_column(String(16))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now(), index=True)

    user: Mapped["User | None"] = relationship(back_populates="event_logs")
    session: Mapped["RegistrationSession | None"] = relationship()


# v13 BACKEND ERRORS LOCALIZATION
class BackendErrorLocalization(Base):
    __tablename__ = "backend_errors_localization"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    code: Mapped[str] = mapped_column(
        String(32), ForeignKey("backend_errors.code", ondelete="CASCADE"), nullable=False, index=True
    )
    language: Mapped[str] = mapped_column(String(3), nullable=False)
    message: Mapped[str | None] = mapped_column(String(255))

    error: Mapped["BackendError"] = relationship(back_populates="localizations")

    __table_args__ = (
        UniqueConstraint("code", "language", name="uq_error_code_language"),
    )
