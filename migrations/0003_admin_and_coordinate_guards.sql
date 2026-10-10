-- Enforce a single initial administrator even if two bootstrap requests race.
CREATE UNIQUE INDEX idx_users_single_admin ON users(role) WHERE role='admin';

CREATE TRIGGER centre_coordinates_insert
BEFORE INSERT ON exam_centres
WHEN (NEW.latitude IS NULL) != (NEW.longitude IS NULL)
  OR (NEW.latitude IS NOT NULL AND (NEW.latitude < -90 OR NEW.latitude > 90 OR NEW.longitude < -180 OR NEW.longitude > 180))
BEGIN SELECT RAISE(ABORT, 'invalid centre coordinates'); END;

CREATE TRIGGER centre_coordinates_update
BEFORE UPDATE OF latitude,longitude ON exam_centres
WHEN (NEW.latitude IS NULL) != (NEW.longitude IS NULL)
  OR (NEW.latitude IS NOT NULL AND (NEW.latitude < -90 OR NEW.latitude > 90 OR NEW.longitude < -180 OR NEW.longitude > 180))
BEGIN SELECT RAISE(ABORT, 'invalid centre coordinates'); END;

CREATE TRIGGER business_coordinates_insert
BEFORE INSERT ON businesses
WHEN (NEW.latitude IS NULL) != (NEW.longitude IS NULL)
  OR (NEW.latitude IS NOT NULL AND (NEW.latitude < -90 OR NEW.latitude > 90 OR NEW.longitude < -180 OR NEW.longitude > 180))
BEGIN SELECT RAISE(ABORT, 'invalid business coordinates'); END;

CREATE TRIGGER business_coordinates_update
BEFORE UPDATE OF latitude,longitude ON businesses
WHEN (NEW.latitude IS NULL) != (NEW.longitude IS NULL)
  OR (NEW.latitude IS NOT NULL AND (NEW.latitude < -90 OR NEW.latitude > 90 OR NEW.longitude < -180 OR NEW.longitude > 180))
BEGIN SELECT RAISE(ABORT, 'invalid business coordinates'); END;
