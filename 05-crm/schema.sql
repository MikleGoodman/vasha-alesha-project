-- ============================================================
-- TRAVEL AGENT CRM — SQL Schema Initialization
-- SQLite-compatible schema for travel agency knowledge base
-- ============================================================

-- 1. CLIENTS: профили клиентов и их предпочтения
CREATE TABLE IF NOT EXISTS clients (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    name          TEXT    NOT NULL,
    phone         TEXT,
    email         TEXT,
    messenger     TEXT,
    passport_country TEXT DEFAULT 'Россия',
    budget_segment TEXT CHECK(budget_segment IN ('бюджет','средний','комфорт','премиум','люкс')),
    travel_style  TEXT,
    restrictions  TEXT,
    preferences   TEXT,
    blacklisted   TEXT,
    created_at    TEXT    DEFAULT (datetime('now')),
    notes         TEXT
);

-- 2. DESTINATIONS: справочник направлений
CREATE TABLE IF NOT EXISTS destinations (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    country           TEXT    NOT NULL,
    city              TEXT,
    region            TEXT,
    best_season_from  INTEGER,
    best_season_to    INTEGER,
    shoulder_months   TEXT,
    visa_required     INTEGER DEFAULT 0,
    visa_type         TEXT,
    visa_notes        TEXT,
    avg_flight_time   TEXT,
    safety_level      INTEGER CHECK(safety_level BETWEEN 1 AND 10),
    currency          TEXT,
    language          TEXT,
    weather_summary   TEXT,
    my_notes          TEXT,
    last_updated      TEXT    DEFAULT (datetime('now'))
);

-- 3. HOTELS: база знаний об отелях
CREATE TABLE IF NOT EXISTS hotels (
    id                 INTEGER PRIMARY KEY AUTOINCREMENT,
    name               TEXT    NOT NULL,
    destination_id     INTEGER REFERENCES destinations(id),
    country            TEXT,
    city               TEXT,
    address            TEXT,
    category           TEXT,
    latitude           REAL,
    longitude          REAL,
    beach_type         TEXT CHECK(beach_type IN ('песок','мелкий песок','галька','кораллы','платформа','нет')),
    beach_distance_m   INTEGER,
    beach_private      INTEGER DEFAULT 0,
    beach_entry        TEXT,
    board_type         TEXT CHECK(board_type IN ('BB','HB','FB','AI','UAI','RO')),
    food_quality       INTEGER CHECK(food_quality BETWEEN 1 AND 10),
    year_built         INTEGER,
    year_renovated     INTEGER,
    avg_room_size_m2   INTEGER,
    soundproof         INTEGER DEFAULT 0,
    pool_count         INTEGER DEFAULT 0,
    pool_heated        INTEGER DEFAULT 0,
    kids_club          INTEGER DEFAULT 0,
    kids_waterpark     INTEGER DEFAULT 0,
    spa                INTEGER DEFAULT 0,
    gym                INTEGER DEFAULT 0,
    wifi_free          INTEGER DEFAULT 1,
    adults_only        INTEGER DEFAULT 0,
    pet_friendly       INTEGER DEFAULT 0,
    airport_distance_km REAL,
    airport_code       TEXT,
    public_rating      REAL,
    my_score           INTEGER CHECK(my_score BETWEEN 1 AND 10),
    red_flags          TEXT,
    best_for           TEXT,
    avoid_for          TEXT,
    price_low_season   INTEGER,
    price_high_season  INTEGER,
    price_currency     TEXT DEFAULT 'USD',
    notes              TEXT,
    last_updated       TEXT    DEFAULT (datetime('now'))
);

-- 4. REQUESTS: запросы клиентов
CREATE TABLE IF NOT EXISTS requests (
    id                 INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id          INTEGER NOT NULL REFERENCES clients(id),
    status             TEXT    DEFAULT 'новый'
        CHECK(status IN ('новый','уточнение','в подборе','предложен','бронирование','завершён','отменён')),
    destination        TEXT,
    dates_from         TEXT,
    dates_to           TEXT,
    dates_flexible     INTEGER DEFAULT 0,
    travelers_adults   INTEGER DEFAULT 2,
    travelers_children INTEGER DEFAULT 0,
    children_ages      TEXT,
    budget_total       INTEGER,
    budget_currency    TEXT DEFAULT 'USD',
    budget_per_person  INTEGER,
    purpose            TEXT,
    purpose_details    TEXT,
    my_analysis        TEXT,
    urgency            TEXT CHECK(urgency IN ('низкая','средняя','высокая','горящий')),
    source             TEXT,
    created_at         TEXT    DEFAULT (datetime('now')),
    updated_at         TEXT    DEFAULT (datetime('now')),
    closed_at          TEXT,
    result_summary     TEXT
);

-- 5. REQUEST_HOTELS: связь запроса с подобранными вариантами
CREATE TABLE IF NOT EXISTS request_hotels (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    request_id      INTEGER NOT NULL REFERENCES requests(id),
    hotel_id        INTEGER NOT NULL REFERENCES hotels(id),
    variant_type    TEXT CHECK(variant_type IN ('A_Ideal','B_Smart','C_Budget','D_Wildcard','E_Upgrade')),
    price_quote     INTEGER,
    price_currency  TEXT,
    includes        TEXT,
    excludes        TEXT,
    flight_info     TEXT,
    transfer_info   TEXT,
    insurance_info  TEXT,
    my_comment      TEXT,
    client_choice   TEXT CHECK(client_choice IN ('да','нет','обдумывает','ожидает')),
    booked          INTEGER DEFAULT 0,
    created_at      TEXT    DEFAULT (datetime('now'))
);

-- 6. FEEDBACK: пост-поездочные отзывы
CREATE TABLE IF NOT EXISTS feedback (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    request_id       INTEGER REFERENCES requests(id),
    hotel_id         INTEGER REFERENCES hotels(id),
    client_id        INTEGER REFERENCES clients(id),
    date_returned    TEXT,
    client_rating    INTEGER CHECK(client_rating BETWEEN 1 AND 10),
    my_rating        INTEGER CHECK(my_rating BETWEEN 1 AND 10),
    pros             TEXT,
    cons             TEXT,
    surprises        TEXT,
    would_return     INTEGER DEFAULT 0,
    would_recommend  INTEGER DEFAULT 0,
    photos_shared    INTEGER DEFAULT 0,
    updated_hotel_notes TEXT,
    created_at       TEXT    DEFAULT (datetime('now'))
);

-- 7. SESSION_MEMORY: быстрые заметки по текущей сессии
CREATE TABLE IF NOT EXISTS session_memory (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id   INTEGER,
    key         TEXT    NOT NULL,
    value       TEXT,
    created_at  TEXT    DEFAULT (datetime('now'))
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_requests_client ON requests(client_id);
CREATE INDEX IF NOT EXISTS idx_requests_status  ON requests(status);
CREATE INDEX IF NOT EXISTS idx_hotels_country   ON hotels(country);
CREATE INDEX IF NOT EXISTS idx_hotels_city      ON hotels(city);
CREATE INDEX IF NOT EXISTS idx_hotels_score     ON hotels(my_score DESC);
CREATE INDEX IF NOT EXISTS idx_reqhotels_req    ON request_hotels(request_id);
CREATE INDEX IF NOT EXISTS idx_feedback_hotel   ON feedback(hotel_id);
