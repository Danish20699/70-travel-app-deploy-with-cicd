-- ==============================================================
-- Jannat-e-Kashmir Travel Packages & Bookings Schema
-- ==============================================================

-- 1. Create Destinations Table
CREATE TABLE IF NOT EXISTS destinations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    tagline VARCHAR(150),
    description TEXT,
    price_inr NUMERIC(10, 2) NOT NULL,
    duration_days INT DEFAULT 3,
    rating NUMERIC(2, 1) DEFAULT 4.8,
    image_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Create Bookings Table
CREATE TABLE IF NOT EXISTS bookings (
    id SERIAL PRIMARY KEY,
    destination_id INT REFERENCES destinations(id) ON DELETE CASCADE,
    customer_name VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100) NOT NULL,
    travel_date DATE NOT NULL,
    guests INT DEFAULT 1,
    booking_status VARCHAR(20) DEFAULT 'CONFIRMED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Seed Kashmir Travel Packages
INSERT INTO destinations (name, tagline, description, price_inr, duration_days, rating, image_url) VALUES
('Gulmarg Meadow of Flowers', 'Skiing & World-Famous Gondola Ride', 'Experience high-altitude snow peaks, alpine meadows, and the world-renowned Gulmarg Gondola riding up to Mt. Apharwat.', 14999.00, 4, 4.9, 'https://images.unsplash.com/photo-1548013146-72479768bada?auto=format&fit=crop&w=1000&q=80'),
('Pahalgam Valley of Shepherds', 'Lidder River & Pine Covered Valleys', 'Nestled along the rushing Lidder River, featuring Betaab Valley, Aru Valley, and scenic pine-covered hill trails.', 12499.00, 3, 4.8, 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1000&q=80'),
('Sonamarg Meadow of Gold', 'Gateway to Thajiwas Glacier', 'Pristine mountain passes, sparkling glacial streams, and horse treks leading up to the historic Thajiwas Glacier.', 11999.00, 3, 4.7, 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&w=1000&q=80'),
('Doodhpathri Valley of Milk', 'Untouched Emerald Meadows & Shaliganga', 'A hidden paradise of velvety green grass, snow-fed crystal streams, and tranquil pine forests away from commercial crowds.', 9999.00, 2, 4.8, 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=80')
ON CONFLICT DO NOTHING;

