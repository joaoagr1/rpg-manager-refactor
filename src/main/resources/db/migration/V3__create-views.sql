CREATE VIEW character_details AS
SELECT
    c.character_id,
    c.character_name,
    c.alignment,
    c.character_journal,
    c.character_image,
    c.proficiency_bonus,
    c.max_life,
    c.current_life,
    u.username AS user_name,
    r.race_name,
    r.race_description,
    cls.class_name,
    cls.class_description,
    ap.STR,
    ap.DEX,
    ap.CON,
    ap.INT_,
    ap.WIS,
    ap.CHA
FROM
    characters c
JOIN
    users u ON c.user_id = u.user_id
JOIN
    races r ON c.race_id = r.race_id
JOIN
    classes cls ON c.class_id = cls.class_id
JOIN
    attribute_points ap ON c.character_id = ap.character_id;