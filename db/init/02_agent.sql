CREATE TABLE urunler (
    urun_kodu    TEXT PRIMARY KEY,
    urun_adi     TEXT NOT NULL,
    kategori     TEXT,
    birim_fiyat  NUMERIC(12,2) NOT NULL,
    birim        TEXT DEFAULT 'adet'
);

CREATE TABLE stok (
    urun_kodu      TEXT PRIMARY KEY REFERENCES urunler(urun_kodu),
    miktar         INTEGER NOT NULL,
    kritik_seviye  INTEGER NOT NULL
);

CREATE TABLE sss (
    sss_id    SERIAL PRIMARY KEY,
    kategori  TEXT NOT NULL,
    soru      TEXT NOT NULL,
    cevap     TEXT NOT NULL
);

INSERT INTO urunler VALUES
('RLM-6204',   'Rulman 6204 2RS',               'Rulman',   42.50,   'adet'),
('RLM-6305',   'Rulman 6305 ZZ',                'Rulman',   68.00,   'adet'),
('CVT-M8x40',  'Cıvata M8x40 (100 adetlik paket)','Bağlantı', 95.00,  'paket'),
('FLT-HID-10', 'Hidrolik Filtre 10µ',           'Filtre',   310.00,  'adet'),
('FLT-HAVA-A2','Hava Filtresi A2',              'Filtre',   185.00,  'adet'),
('CNT-NBR-50', 'NBR Conta 50mm',                'Conta',    12.75,   'adet'),
('CNT-VIT-80', 'Viton Conta 80mm',              'Conta',    29.90,   'adet'),
('KBL-3x1.5',  'Kablo 3x1.5 (100m)',            'Kablo',    1450.00, 'makara'),
('PNM-SIL-32', 'Pnömatik Silindir 32mm',        'Pnömatik', 760.00,  'adet'),
('HID-POM-01', 'Hidrolik Pompa 1.5kW',          'Hidrolik', 5200.00, 'adet'),
('YAG-SNT-20', 'Sentetik Yağ 20L',              'Yağ',      1280.00, 'bidon'),
('EMN-KSK-L',  'İş Eldiveni (12 çift)',         'İSG',      230.00,  'paket');

INSERT INTO stok VALUES
('RLM-6204', 500, 100), ('RLM-6305', 240, 80), ('CVT-M8x40', 90, 30),
('FLT-HID-10', 120, 50), ('FLT-HAVA-A2', 0, 40), ('CNT-NBR-50', 800, 200),
('CNT-VIT-80', 15, 30), ('KBL-3x1.5', 40, 10), ('PNM-SIL-32', 25, 10),
('HID-POM-01', 6, 3), ('YAG-SNT-20', 60, 20), ('EMN-KSK-L', 300, 50);

INSERT INTO sss (kategori, soru, cevap) VALUES
('kargo',   'Siparişim ne zaman sevk edilir?', 'Onaylanan siparişler 3-5 iş günü içinde sevk edilir. Sevk sonrası kargo takip numarası e-posta ile paylaşılır.'),
('kargo',   'Kargo ücreti nasıl hesaplanır?', '10.000 TL üzeri siparişlerde kargo ücretsizdir. Altındaki siparişlerde desi bazlı ücret uygulanır.'),
('iade',    'İade koşulları nelerdir?', 'Kullanılmamış ürünler teslimattan itibaren 14 gün içinde iade edilebilir. Hasarlı ürünlerde fotoğraf ile bildirim gerekir.'),
('odeme',   'Hangi ödeme yöntemleri kabul ediliyor?', 'Havale/EFT, kredi kartı ve vadeli ödeme (onaylı müşteriler için 30/60 gün).'),
('fatura',  'Faturamı nasıl talep ederim?', 'E-faturalar sevk günü kayıtlı e-posta adresine gönderilir. Düzeltme için sipariş numarası ile muhasebeye yazın.'),
('teklif',  'Teklif talebi nasıl yapılır?', 'Ürün kodu, miktar ve istenen teslim tarihini belirten bir e-posta yeterlidir. Teklif 1 iş günü içinde hazırlanır.'),
('teklif',  'Toplu alımlarda indirim var mı?', '500 adet üzeri alımlarda kademeli indirim uygulanır, oran müşteri segmentine göre satış ekibi tarafından belirlenir.'),
('garanti', 'Ürün garanti süresi nedir?', 'Ürünler teslim tarihinden itibaren 12 ay üretim hatalarına karşı garantilidir.');

-- En az yetki: agent yalnızca ürün/stok/SSS okuyabilir, müşteri ve sipariş verisini göremez
REVOKE ALL ON musteriler, siparisler FROM agent_readonly;
GRANT SELECT ON urunler, stok, sss TO agent_readonly;
ALTER ROLE agent_readonly SET statement_timeout = '5s';
ALTER ROLE agent_readonly CONNECTION LIMIT 3;

