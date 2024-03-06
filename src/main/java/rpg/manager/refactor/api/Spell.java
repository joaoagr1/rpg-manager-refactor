package rpg.manager.refactor.api;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import lombok.EqualsAndHashCode;

@Entity(name = "spells")
@Table(name = "spells")
@EqualsAndHashCode(of="spellId")
public class Spell {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer spellId;

    @Size(max = 50)
    @NotEmpty
    private String spellName;

    @NotEmpty
    private String spellDescription;

}