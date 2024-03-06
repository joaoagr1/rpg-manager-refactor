package rpg.manager.refactor.api;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface CharacterRepository extends JpaRepository<Character,Integer> {

    @Query("SELECT c FROM character c WHERE c.user.userId = :userId")
    List<Character> findAllCharactersByUserId(@Param("userId") Integer userId);
}
