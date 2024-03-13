package rpg.manager.refactor.api;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity(name = "characters")
@Table(name = "characters")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Character_ {
    @Id
    @JsonIgnore
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long characterId;
    private String characterName;
    private String alignment;
    private String characterJournal;
    private String characterImage;
    private int proficiencyBonus;
    private int currentLife;
    private int maxLife;
    private boolean inspiration;
    private String backstory;
    private int movement;
    private String background;

    @ManyToOne
    @JoinColumn(name = "class_id")
    private Classe classe;

    @ManyToOne
    @JoinColumn(name = "subclass_id")
    private Subclass subclass;


}
