package rpg.manager.refactor.api;

import org.springframework.data.jpa.repository.JpaRepository;

public interface CharacterRepository extends JpaRepository<Character,Integer> {
}
