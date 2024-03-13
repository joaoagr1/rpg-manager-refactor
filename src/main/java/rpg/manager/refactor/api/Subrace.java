package rpg.manager.refactor.api;

import com.fasterxml.jackson.annotation.JsonIgnore;
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
    @JsonIgnore
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int subraceId;

    private String subraceName;

    @JsonIgnore
    @ManyToOne
    @JoinColumn(name = "race_id")
    private Race race;

    private String subraceDescription;
}
