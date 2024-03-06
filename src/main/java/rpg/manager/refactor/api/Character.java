package rpg.manager.refactor.api;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Entity(name="characters")
@Table(name = "characters")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Character {

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer characterId;

    @NotEmpty
    @Size(max = 50)
    private String characterName;

    @ManyToOne
    @NotEmpty
    @JoinColumn(name = "race_id")
    private Race race;

    @Size(max = 50)
    @NotEmpty
    private String alignment;

    @ManyToOne
    @JoinColumn(name = "subrace_id")
    private Subrace subrace;

    @ManyToOne
    @JoinColumn(name = "class_id")
    private CharacterClass characterClass;

    @ManyToOne
    @JoinColumn(name = "subclass_id")
    private Subclass subclass;

    @NotEmpty
    private String characterJournal;

    @NotEmpty
    private String characterImage;

    @NotEmpty
    private int proficiencyBonus;

    private int currentLife;

    @NotEmpty
    private int maxLife;

    private boolean inspiration;

    @NotEmpty
    private String backstory;

   // @NotEmpty
    private int movement;

    @Size(max = 10)
    private String background;

}

