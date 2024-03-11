package rpg.manager.refactor.api;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "race")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "raceId")
public class Race {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long raceId;

    private String raceName;
    private String raceDescription;

    @OneToOne(mappedBy = "race")
    private Character character;

    @OneToOne(mappedBy = "race")
    private Subrace subrace;
}
