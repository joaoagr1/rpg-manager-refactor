package rpg.manager.refactor.api;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Data;

@Entity
@Data
public class CharacterTrait {

    @Id
    private Long id;

    private String nome;
    private String descrição;
    private int nível;
    private String tipo;
}