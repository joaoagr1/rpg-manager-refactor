package rpg.manager.refactor.api;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity(name="subraces")
@Table(name = "subraces")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Subrace {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int subraceId;

    private String subraceName;

    @ManyToOne
    @JoinColumn(name = "race_id")
    private Race race;

    private String subraceDescription;

}