package rpg.manager.refactor.api;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CharacterFeatureRepository extends JpaRepository<CharacterFeature, Integer> {

    @Query(value = "SELECT * FROM character_features_view WHERE character_id = :characterId AND level <= :currentLevel", nativeQuery = true)
    List<CharacterFeature> findCharacterFeaturesByCharacterIdAndLevelLessThanEqual(@Param("characterId") Integer characterId, @Param("currentLevel") Integer currentLevel);
}
