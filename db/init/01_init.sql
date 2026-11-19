-- Sahte ERP: tüm firmalar ve kişiler uydurmadır
CREATE TABLE musteriler (
    musteri_id  SERIAL PRIMARY KEY,
    firma_adi   TEXT NOT NULL,
    yetkili     TEXT,
    email       TEXT UNIQUE NOT NULL,
    segment     TEXT DEFAULT 'standart'
);

CREATE TABLE siparisler (
    siparis_no      TEXT PRIMARY KEY,
    musteri_id      INTEGER NOT NULL REFERENCES musteriler(musteri_id),
    siparis_tarihi  DATE NOT NULL,
    durum           TEXT NOT NULL CHECK (durum IN ('Onay Bekliyor','Hazirlaniyor','Sevk Edildi','Teslim Edildi','Iptal')),
    tahmini_sevk    DATE,
    kargo_takip_no  TEXT,
    toplam_tutar    NUMERIC(14,2)
);

-- Agent'ın çalışma kaydı (ileride n8n yazacak)
CREATE TABLE islem_loglari (
    log_id         SERIAL PRIMARY KEY,
    zaman          TIMESTAMP DEFAULT NOW(),
    mail_id        TEXT UNIQUE,
    gonderen       TEXT,
    konu           TEXT,
    kategori       TEXT,
    aciliyet       TEXT,
    guven          NUMERIC(3,2),
    aksiyon        TEXT,
    insan_inceleme BOOLEAN DEFAULT FALSE,
    sure_ms        INTEGER,
    tokens_in      INTEGER,
    tokens_out     INTEGER,
    hata           TEXT
);

INSERT INTO musteriler (firma_adi, yetkili, email, segment) VALUES
('Anadolu Makina A.Ş.',  'Ahmet Yılmaz', 'ahmet.yilmaz@anadolumakina.example.com', 'gold'),
('Ege Plastik A.Ş.',     'Elif Demir',   'elif.demir@egeplastik.example.com',      'standart'),
('Marmara Otomotiv A.Ş.','Burak Arslan', 'burak.arslan@marmaraotomotiv.example.com','stratejik'),
('Başkent Elektrik A.Ş.','Selin Koç',    'selin.koc@baskentelektrik.example.com',  'standart'),
('Atlas Kablo A.Ş.',     'Deniz Polat',  'deniz.polat@atlaskablo.example.com',     'gold');

INSERT INTO siparisler (siparis_no, musteri_id, siparis_tarihi, durum, tahmini_sevk, kargo_takip_no, toplam_tutar) VALUES
('SIP-1015', 4, '2026-10-20', 'Teslim Edildi', '2026-10-25', 'TRK7712034561', 18450.00),
('SIP-1023', 1, '2026-10-28', 'Teslim Edildi', '2026-11-02', 'TRK5530981274', 9200.50),
('SIP-1032', 5, '2026-11-12', 'Hazirlaniyor',  '2026-11-24', NULL,            41300.00),
('SIP-1040', 3, '2026-11-14', 'Sevk Edildi',   '2026-11-17', 'TRK4821907365', 27800.00),
('SIP-1041', 2, '2026-11-17', 'Onay Bekliyor', NULL,         NULL,            6150.00),
('SIP-1042', 3, '2026-11-05', 'Iptal',         NULL,         NULL,            3300.00),
('SIP-1043', 5, '2026-11-13', 'Sevk Edildi',   '2026-11-18', 'TRK9904418820', 15720.00),
('SIP-1044', 1, '2026-11-16', 'Hazirlaniyor',  '2026-11-22', NULL,            22100.00);

-- Agent için salt okunur kullanıcı (ileride AI Agent bununla bağlanacak)
CREATE ROLE agent_readonly LOGIN PASSWORD 'readonly_demo';
GRANT CONNECT ON DATABASE erp TO agent_readonly;
GRANT USAGE ON SCHEMA public TO agent_readonly;
GRANT SELECT ON musteriler, siparisler TO agent_readonly;

CREATE TABLE sikayetler (
    sikayet_id SERIAL PRIMARY KEY,
    zaman      TIMESTAMP DEFAULT NOW(),
    mail_id    TEXT,
    gonderen   TEXT,
    siparis_no TEXT,
    ozet       TEXT,
    aciliyet   TEXT,
    durum      TEXT DEFAULT 'Acik'
);

CREATE TABLE fatura_talepleri (
    fatura_talep_id SERIAL PRIMARY KEY,
    zaman           TIMESTAMP DEFAULT NOW(),
    mail_id         TEXT UNIQUE,
    gonderen        TEXT,
    siparis_no      TEXT,
    ozet            TEXT,
    aciliyet        TEXT,
    durum           TEXT DEFAULT 'Acik'
);