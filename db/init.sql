-- ==============================================================
-- Jannat-e-Kashmir Travel Packages & Bookings Schema
-- ==============================================================

-- 1. Create Destinations Table
CREATE TABLE IF NOT EXISTS destinations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) DEFAULT 'Adventure',
    location VARCHAR(100) DEFAULT 'Kashmir, India',
    tagline VARCHAR(150),
    description TEXT,
    price NUMERIC(10, 2) NOT NULL,
    price_inr NUMERIC(10, 2),
    duration VARCHAR(50) DEFAULT '4 Days / 3 Nights',
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
    email VARCHAR(100) NOT NULL,
    customer_email VARCHAR(100),
    phone VARCHAR(50),
    travel_date DATE NOT NULL,
    num_travelers INT DEFAULT 1,
    guests INT DEFAULT 1,
    booking_status VARCHAR(20) DEFAULT 'CONFIRMED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Seed Kashmir Travel Packages
INSERT INTO destinations (id, name, category, location, tagline, description, price, price_inr, duration, duration_days, rating, image_url) VALUES
(1, 'Gulmarg Meadow of Flowers', 'Winter Sports', 'Gulmarg, Kashmir', 'Skiing & World-Famous Gondola Ride', 'Experience high-altitude snow peaks, alpine meadows, and the world-renowned Gulmarg Gondola riding up to Mt. Apharwat.', 14999.00, 14999.00, '4 Days / 3 Nights', 4, 4.9, 'https://images.unsplash.com/photo-1548013146-72479768bada?auto=format&fit=crop&w=1000&q=80'),
(2, 'Dal Lake Heritage Houseboat', 'Lakes & Houseboats', 'Srinagar, Kashmir', 'Cedar Houseboats & Shikara Sunset', 'Stay in handcrafted carved-cedar houseboats on Dal Lake with morning floating markets and peaceful evening Shikara rides.', 16499.00, 16499.00, '3 Days / 2 Nights', 3, 4.9, 'https://images.unsplash.com/photo-1595815771614-ade9d652a65d?auto=format&fit=crop&w=1000&q=80'),
(3, 'Pahalgam Valley of Shepherds', 'Valleys & Meadows', 'Pahalgam, Kashmir', 'Lidder River & Pine Covered Valleys', 'Nestled along the rushing Lidder River, featuring Betaab Valley, Aru Valley, and scenic pine-covered hill trails.', 12499.00, 12499.00, '3 Days / 2 Nights', 3, 4.8, 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1000&q=80'),
(4, 'Sonamarg Meadow of Gold', 'Valleys & Meadows', 'Sonamarg, Kashmir', 'Gateway to Thajiwas Glacier', 'Pristine mountain passes, sparkling glacial streams, and horse treks leading up to the historic Thajiwas Glacier.', 11999.00, 11999.00, '3 Days / 2 Nights', 3, 4.7, 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&w=1000&q=80'),
(5, 'Doodhpathri Valley of Milk', 'Offbeat Expeditions', 'Budgam, Kashmir', 'Untouched Emerald Meadows & Shaliganga', 'A hidden paradise of velvety green grass, snow-fed crystal streams, and tranquil pine forests away from commercial crowds.', 9999.00, 9999.00, '2 Days / 1 Night', 2, 4.8, 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=80'),
(6, 'Gurez Valley Frontier', 'Offbeat Expeditions', 'Bandipora, Kashmir', 'Habba Khatoon Peak & Kishanganga', 'Remote Himalayan valley along the Kishanganga river, guarded by the legendary pyramidal peak of Habba Khatoon.', 13999.00, 13999.00, '4 Days / 3 Nights', 4, 4.9, 'https://images.unsplash.com/photo-1517825738774-7de9363ef735?auto=format&fit=crop&w=1000&q=80'),
(7, 'Kashmir Great Lakes Trek', 'Alpine Treks', 'Sonamarg to Naranag', '7 High Altitude Glacial Lakes', 'India’s most iconic wilderness trek traversing through emerald tarns, alpine flower meadows, and high Himalayan passes.', 18999.00, 18999.00, '7 Days / 6 Nights', 7, 5.0, 'https://images.unsplash.com/photo-1598091383021-15ddea10925d?auto=format&fit=crop&w=1000&q=80')
ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    category = EXCLUDED.category,
    location = EXCLUDED.location,
    tagline = EXCLUDED.tagline,
    description = EXCLUDED.description,
    price = EXCLUDED.price,
    price_inr = EXCLUDED.price_inr,
    duration = EXCLUDED.duration,
    duration_days = EXCLUDED.duration_days,
    rating = EXCLUDED.rating,
    image_url = EXCLUDED.image_url;
