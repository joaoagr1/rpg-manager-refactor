package rpg.manager.refactor.api;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SubclassRepository extends JpaRepository <Subclass,Integer> {
}
