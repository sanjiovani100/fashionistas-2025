-- Sample Ticket Types
INSERT INTO ticket_types (event_id, name, description, price, is_vip, is_early_bird, features, is_recommended) VALUES
(1, 'General Admission', 'Essential fashion experience', 100000, FALSE, FALSE, ARRAY['Standard seating', 'Event access', 'Complimentary drinks', 'Digital program'], FALSE),
(1, 'Premium Experience', 'Enhanced fashion access', 250000, TRUE, FALSE, ARRAY['Priority seating', 'VIP lounge access', 'Welcome champagne', 'Event gift bag', 'Reserved parking'], TRUE),
(1, 'VIP Elite Package', 'Ultimate luxury access', 800000, TRUE, FALSE, ARRAY['Front row seating', 'Exclusive lounge access', 'Designer meet & greets', 'Luxury gift bag', 'Complimentary valet parking'], FALSE),
(2, 'Standard Entry', 'Basic access to the showcase', 25000, FALSE, FALSE, ARRAY['Event entry', 'Welcome drink', 'Digital lookbook'], FALSE),
(2, 'VIP Experience', 'Premium showcase experience', 50000, TRUE, FALSE, ARRAY['Front row seating', 'Open bar', 'Swag bag', 'Designer meet & greet'], TRUE),
(3, 'Conference Pass', 'Full conference access', 15000, FALSE, TRUE, ARRAY['All sessions', 'Lunch included', 'Conference materials'], TRUE),
(3, 'Workshop Bundle', 'Conference plus hands-on workshops', 30000, FALSE, FALSE, ARRAY['All sessions', 'All workshops', 'Lunch and refreshments', 'Sustainable fashion toolkit'], FALSE);