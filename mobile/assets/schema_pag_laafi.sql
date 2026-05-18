CREATE TABLE IF NOT EXISTS question (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    ordre           INTEGER NOT NULL UNIQUE,
    type_reponse    TEXT NOT NULL DEFAULT 'choix_multiple',
    poids_max       INTEGER NOT NULL DEFAULT 3,
    enonce_fr       TEXT NOT NULL,
    enonce_moore    TEXT,
    enonce_dioula   TEXT,
    enonce_fulfude  TEXT,
    audio_fr        TEXT,
    audio_moore     TEXT,
    audio_dioula    TEXT,
    audio_fulfude   TEXT,
    options         TEXT
);