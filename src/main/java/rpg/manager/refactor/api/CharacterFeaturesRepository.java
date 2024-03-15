package rpg.manager.refactor.api;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface CharacterFeaturesRepository extends JpaRepository<CharacterTrait, Integer>{
    @Query(value = "SELECT Nome, Descrição, Nível, Tipo " +
            "FROM (" +
            "    SELECT rt.racial_trait_name AS Nome, rt.racial_trait_description AS Descrição, rt.racial_trait_level AS Nível, rt.type AS Tipo " +
            "    FROM characters ch " +
            "    INNER JOIN races ra ON ch.race_id = ra.race_id " +
            "    INNER JOIN racial_traits rt ON rt.race_id = ra.race_id " +
            "    WHERE ch.character_id = :characterId " +
            "    UNION ALL " +
            "    SELECT st.subracial_traits_name AS Nome, st.subracial_trait_description AS Descrição, st.subracial_trait_level AS Nível, st.type AS Tipo " +
            "    FROM characters ch " +
            "    INNER JOIN subraces sb ON ch.subrace_id = sb.subrace_id " +
            "    INNER JOIN subracial_traits st ON st.subrace_id = sb.subrace_id " +
            "    WHERE ch.character_id = :characterId " +
            "    UNION ALL " +
            "    SELECT cf.class_feature_name AS Nome, cf.class_feature_description AS Descrição, cf.level AS Nível, cf.type AS Tipo " +
            "    FROM characters ch " +
            "    INNER JOIN classes c ON c.class_id = ch.class_id " +
            "    INNER JOIN class_features cf ON cf.class_id = ch.class_id " +
            "    WHERE ch.character_id = :characterId " +
            "    UNION ALL " +
            "    SELECT sf.subclass_feature_name AS Nome, sf.subclass_feature_description AS Descrição, sf.level AS Nível, sf.type AS Tipo " +
            "    FROM characters ch " +
            "    INNER JOIN subclasses sb ON sb.subclass_id = ch.subclass_id " +
            "    INNER JOIN subclass_features sf ON sf.subclass_id = ch.subclass_id " +
            "    WHERE ch.character_id = :characterId " +
            ") AS all_results " +
            "WHERE Nível <= :currentLevel ", nativeQuery = true)
    List<CharacterTrait> findCharacterTraits(@Param("characterId") Integer characterId, @Param("currentLevel") Integer currentLevel);

}
