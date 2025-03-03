-- Connect Events to Designers
INSERT INTO event_to_designer (event_id, designer_id, is_headliner, presentation_order) VALUES
(1, 1, TRUE, 1),
(1, 2, FALSE, 2),
(2, 1, TRUE, 1),
(3, 2, TRUE, 1),
(3, 3, FALSE, 2);