-- Development-only seed data.
-- Every example user has the password: Password123!

BEGIN;

INSERT INTO users (id, name, email, password_hash, role, is_active, created_at) VALUES
  ('10000000-0000-4000-8000-000000000001', 'Kiss Anna', 'anna.kiss@example.com', '$2b$12$lVraO5qPwdYqO7f8WOUa..a2ld0yhr9n9blCLq9GfQ8VWc64FSDb6', 'USER', TRUE, CURRENT_TIMESTAMP - INTERVAL '120 days'),
  ('10000000-0000-4000-8000-000000000002', 'Nagy Bence', 'bence.nagy@example.com', '$2b$12$lVraO5qPwdYqO7f8WOUa..a2ld0yhr9n9blCLq9GfQ8VWc64FSDb6', 'USER', TRUE, CURRENT_TIMESTAMP - INTERVAL '95 days'),
  ('10000000-0000-4000-8000-000000000003', 'Tóth Csaba', 'csaba.toth@example.com', '$2b$12$lVraO5qPwdYqO7f8WOUa..a2ld0yhr9n9blCLq9GfQ8VWc64FSDb6', 'TECHNICIAN', TRUE, CURRENT_TIMESTAMP - INTERVAL '200 days'),
  ('10000000-0000-4000-8000-000000000004', 'Szabó Dóra', 'dora.szabo@example.com', '$2b$12$lVraO5qPwdYqO7f8WOUa..a2ld0yhr9n9blCLq9GfQ8VWc64FSDb6', 'TECHNICIAN', TRUE, CURRENT_TIMESTAMP - INTERVAL '180 days'),
  ('10000000-0000-4000-8000-000000000005', 'Varga Emese', 'emese.varga@example.com', '$2b$12$lVraO5qPwdYqO7f8WOUa..a2ld0yhr9n9blCLq9GfQ8VWc64FSDb6', 'ADMIN', TRUE, CURRENT_TIMESTAMP - INTERVAL '365 days'),
  ('10000000-0000-4000-8000-000000000006', 'Farkas Gábor', 'gabor.farkas@example.com', '$2b$12$lVraO5qPwdYqO7f8WOUa..a2ld0yhr9n9blCLq9GfQ8VWc64FSDb6', 'USER', FALSE, CURRENT_TIMESTAMP - INTERVAL '300 days')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  email = EXCLUDED.email,
  password_hash = EXCLUDED.password_hash,
  role = EXCLUDED.role,
  is_active = EXCLUDED.is_active;

INSERT INTO assets (id, hostname, type, serial_number, owner_id, status, created_at) VALUES
  ('a0000000-0000-4000-8000-000000000001', 'anna-laptop', 'LAPTOP', 'LT-2026-0001', '10000000-0000-4000-8000-000000000001', 'ACTIVE', CURRENT_TIMESTAMP - INTERVAL '110 days'),
  ('a0000000-0000-4000-8000-000000000002', 'bence-desktop', 'DESKTOP', 'DT-2025-0042', '10000000-0000-4000-8000-000000000002', 'REPAIR', CURRENT_TIMESTAMP - INTERVAL '90 days'),
  ('a0000000-0000-4000-8000-000000000003', 'meeting-room-printer', 'PRINTER', 'PR-2024-0017', NULL, 'ACTIVE', CURRENT_TIMESTAMP - INTERVAL '500 days'),
  ('a0000000-0000-4000-8000-000000000004', 'warehouse-scanner', 'SCANNER', 'SC-2023-0008', NULL, 'RETIRED', CURRENT_TIMESTAMP - INTERVAL '800 days'),
  ('a0000000-0000-4000-8000-000000000005', 'gabor-phone', 'PHONE', 'PH-2025-0031', '10000000-0000-4000-8000-000000000006', 'ACTIVE', CURRENT_TIMESTAMP - INTERVAL '250 days')
ON CONFLICT (id) DO UPDATE SET
  hostname = EXCLUDED.hostname,
  type = EXCLUDED.type,
  serial_number = EXCLUDED.serial_number,
  owner_id = EXCLUDED.owner_id,
  status = EXCLUDED.status;

INSERT INTO tickets (
  id, title, description, status, priority, created_by_id,
  assigned_to_id, asset_id, created_at, updated_at, closed_at
) VALUES
  (
    '20000000-0000-4000-8000-000000000001',
    'A laptop nem csatlakozik a Wi-Fihez',
    'Az irodai Wi-Fi hálózat a mai reggel óta nem jelenik meg a laptopon.',
    'OPEN', 'HIGH',
    '10000000-0000-4000-8000-000000000001', NULL,
    'a0000000-0000-4000-8000-000000000001',
    CURRENT_TIMESTAMP - INTERVAL '2 hours', CURRENT_TIMESTAMP - INTERVAL '2 hours', NULL
  ),
  (
    '20000000-0000-4000-8000-000000000002',
    'A munkaállomás váratlanul újraindul',
    'Nagyobb Excel-fájlok megnyitásakor a számítógép figyelmeztetés nélkül újraindul.',
    'IN_PROGRESS', 'CRITICAL',
    '10000000-0000-4000-8000-000000000002',
    '10000000-0000-4000-8000-000000000003',
    'a0000000-0000-4000-8000-000000000002',
    CURRENT_TIMESTAMP - INTERVAL '1 day', CURRENT_TIMESTAMP - INTERVAL '3 hours', NULL
  ),
  (
    '20000000-0000-4000-8000-000000000003',
    'A tárgyaló nyomtatója csíkosan nyomtat',
    'A nyomatokon ismétlődő fekete csíkok láthatók.',
    'RESOLVED', 'MEDIUM',
    '10000000-0000-4000-8000-000000000001',
    '10000000-0000-4000-8000-000000000004',
    'a0000000-0000-4000-8000-000000000003',
    CURRENT_TIMESTAMP - INTERVAL '4 days', CURRENT_TIMESTAMP - INTERVAL '1 day', NULL
  ),
  (
    '20000000-0000-4000-8000-000000000004',
    'VPN-hozzáférés igénylése',
    'Otthoni munkavégzéshez VPN-hozzáférésre van szükségem.',
    'CLOSED', 'LOW',
    '10000000-0000-4000-8000-000000000002',
    '10000000-0000-4000-8000-000000000003', NULL,
    CURRENT_TIMESTAMP - INTERVAL '10 days', CURRENT_TIMESTAMP - INTERVAL '8 days', CURRENT_TIMESTAMP - INTERVAL '8 days'
  ),
  (
    '20000000-0000-4000-8000-000000000005',
    'Elfelejtett jelszó',
    'Több sikertelen bejelentkezés után a fiókom zárolásra került.',
    'IN_PROGRESS', 'HIGH',
    '10000000-0000-4000-8000-000000000001',
    '10000000-0000-4000-8000-000000000004', NULL,
    CURRENT_TIMESTAMP - INTERVAL '5 hours', CURRENT_TIMESTAMP - INTERVAL '1 hour', NULL
  ),
  (
    '20000000-0000-4000-8000-000000000006',
    'Raktári szkenner selejtezése',
    'A régi vonalkódolvasó már nem javítható, kérem a selejtezés rögzítését.',
    'CLOSED', 'LOW',
    '10000000-0000-4000-8000-000000000005',
    '10000000-0000-4000-8000-000000000003',
    'a0000000-0000-4000-8000-000000000004',
    CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP - INTERVAL '25 days', CURRENT_TIMESTAMP - INTERVAL '25 days'
  )
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  status = EXCLUDED.status,
  priority = EXCLUDED.priority,
  created_by_id = EXCLUDED.created_by_id,
  assigned_to_id = EXCLUDED.assigned_to_id,
  asset_id = EXCLUDED.asset_id,
  updated_at = EXCLUDED.updated_at,
  closed_at = EXCLUDED.closed_at;

INSERT INTO comments (id, ticket_id, author_id, body, created_at) VALUES
  ('30000000-0000-4000-8000-000000000001', '20000000-0000-4000-8000-000000000001', '10000000-0000-4000-8000-000000000001', 'A telefon ugyanazon a hálózaton megfelelően működik.', CURRENT_TIMESTAMP - INTERVAL '110 minutes'),
  ('30000000-0000-4000-8000-000000000002', '20000000-0000-4000-8000-000000000002', '10000000-0000-4000-8000-000000000003', 'Megkezdtem a hardverdiagnosztikát, valószínűleg memóriahiba okozza.', CURRENT_TIMESTAMP - INTERVAL '22 hours'),
  ('30000000-0000-4000-8000-000000000003', '20000000-0000-4000-8000-000000000002', '10000000-0000-4000-8000-000000000002', 'A diagnosztika idejére kaptam cseregépet.', CURRENT_TIMESTAMP - INTERVAL '20 hours'),
  ('30000000-0000-4000-8000-000000000004', '20000000-0000-4000-8000-000000000003', '10000000-0000-4000-8000-000000000004', 'A hengert megtisztítottam és tesztoldalt nyomtattam.', CURRENT_TIMESTAMP - INTERVAL '30 hours'),
  ('30000000-0000-4000-8000-000000000005', '20000000-0000-4000-8000-000000000003', '10000000-0000-4000-8000-000000000001', 'A tesztoldal megfelelő, köszönöm.', CURRENT_TIMESTAMP - INTERVAL '25 hours'),
  ('30000000-0000-4000-8000-000000000006', '20000000-0000-4000-8000-000000000004', '10000000-0000-4000-8000-000000000003', 'A VPN-profilt elkészítettem és elküldtem a beállítási útmutatót.', CURRENT_TIMESTAMP - INTERVAL '9 days'),
  ('30000000-0000-4000-8000-000000000007', '20000000-0000-4000-8000-000000000005', '10000000-0000-4000-8000-000000000004', 'A fiók feloldva, ideiglenes jelszót küldtem.', CURRENT_TIMESTAMP - INTERVAL '2 hours'),
  ('30000000-0000-4000-8000-000000000008', '20000000-0000-4000-8000-000000000006', '10000000-0000-4000-8000-000000000005', 'A selejtezést jóváhagytam.', CURRENT_TIMESTAMP - INTERVAL '26 days')
ON CONFLICT (id) DO UPDATE SET
  ticket_id = EXCLUDED.ticket_id,
  author_id = EXCLUDED.author_id,
  body = EXCLUDED.body;

COMMIT;
