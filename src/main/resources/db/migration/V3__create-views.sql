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


    CREATE VIEW character_features_view AS
    SELECT
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id,
        ch.character_id,
        rt.racial_trait_name AS name,
        rt.racial_trait_description AS description,
        rt.racial_trait_level AS level,
        rt.type AS type,
        'racial_trait' AS source
    FROM characters ch
    INNER JOIN races ra ON ch.race_id = ra.race_id
    INNER JOIN racial_traits rt ON rt.race_id = ra.race_id
    UNION ALL
    SELECT
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id,
        ch.character_id,
        st.subracial_traits_name AS name,
        st.subracial_trait_description AS description,
        st.subracial_trait_level AS level,
        st.type AS type,
        'subracial_trait' AS source
    FROM characters ch
    INNER JOIN subraces sb ON ch.subrace_id = sb.subrace_id
    INNER JOIN subracial_traits st ON st.subrace_id = sb.subrace_id
    UNION ALL
    SELECT
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id,
        ch.character_id,
        cf.class_feature_name AS name,
        cf.class_feature_description AS description,
        cf.level AS level,
        cf.type AS type,
        'class_feature' AS source
    FROM characters ch
    INNER JOIN classes c ON c.class_id = ch.class_id
    INNER JOIN class_features cf ON cf.class_id = ch.class_id
    UNION ALL
    SELECT
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id,
        ch.character_id,
        sf.subclass_feature_name AS name,
        sf.subclass_feature_description AS description,
        sf.level AS level,
        sf.type AS type,
        'subclass_feature' AS source
    FROM characters ch
    INNER JOIN subclasses sb ON sb.subclass_id = ch.subclass_id
    INNER JOIN subclass_features sf ON sf.subclass_id = ch.subclass_id;
