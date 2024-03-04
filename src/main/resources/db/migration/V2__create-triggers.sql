DELIMITER //

CREATE TRIGGER add_attributes_after_insert_character
AFTER INSERT ON characters
FOR EACH ROW
BEGIN
    INSERT INTO attribute_points (character_id, STR, DEX, CON, INT_, WIS, CHA)
    VALUES (NEW.character_id, 0, 0, 0, 0, 0, 0);
END;
//

DELIMITER ;