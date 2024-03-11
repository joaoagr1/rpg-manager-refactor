package rpg.manager.refactor.api;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity(name = "characters")
@Table(name = "characters")
@EqualsAndHashCode(of = "characterId")
public class Character {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long characterId;

    private String characterName;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private String alignment;

    @ManyToOne
    @JoinColumn(name = "race_id")
    private Race race;

    @ManyToOne
    @JoinColumn(name = "class_id")
    private Character_Class characterClass;

    @OneToMany(mappedBy = "character", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Item> items;

    private String characterJournal;

    private String characterImage;

    private Integer proficiencyBonus;

    private Integer currentLife;

    private Integer maxLife;

    private Boolean inspiration;

    private String backstory;

    private Integer movement;

    private String background;

}
