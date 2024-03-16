package rpg.manager.refactor.api;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CharacterRepository extends JpaRepository <Character_,Integer> {

    @Query(value = "SELECT name, description, level, type " +
            "FROM (" +
            "    SELECT rt.racial_trait_name AS name, rt.racial_trait_description AS description, rt.racial_trait_level AS level, rt.type AS type " +
            "    FROM characters ch " +
            "    INNER JOIN races ra ON ch.race_id = ra.race_id " +
            "    INNER JOIN racial_traits rt ON rt.race_id = ra.race_id " +
            "    WHERE ch.character_id = :characterId " +
            "    UNION ALL " +
            "    SELECT st.subracial_traits_name AS name, st.subracial_trait_description AS description, st.subracial_trait_level AS level, st.type AS type " +
            "    FROM characters ch " +
            "    INNER JOIN subraces sb ON ch.subrace_id = sb.subrace_id " +
            "    INNER JOIN subracial_traits st ON st.subrace_id = sb.subrace_id " +
            "    WHERE ch.character_id = :characterId " +
            "    UNION ALL " +
            "    SELECT cf.class_feature_name AS name, cf.class_feature_description AS description, cf.level AS level, cf.type AS type " +
            "    FROM characters ch " +
            "    INNER JOIN classes c ON c.class_id = ch.class_id " +
            "    INNER JOIN class_features cf ON cf.class_id = ch.class_id " +
            "    WHERE ch.character_id = :characterId " +
            "    UNION ALL " +
            "    SELECT sf.subclass_feature_name AS name, sf.subclass_feature_description AS description, sf.level AS level, sf.type AS type " +
            "    FROM characters ch " +
            "    INNER JOIN subclasses sb ON sb.subclass_id = ch.subclass_id " +
            "    INNER JOIN subclass_features sf ON sf.subclass_id = ch.subclass_id " +
            "    WHERE ch.character_id = :characterId " +
            ") AS all_results " +
            "WHERE level <= :currentLevel ", nativeQuery = true)
    List<?> findCharacterFeatures(@Param("characterId") Integer characterId, @Param("currentLevel") Integer currentLevel);

}

