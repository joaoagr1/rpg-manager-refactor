package rpg.manager.refactor.api;

import org.springframework.data.jpa.repository.JpaRepository;

public interface SpellRepository extends JpaRepository<Spell,Integer> {
}
