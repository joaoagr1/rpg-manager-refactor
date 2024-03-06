package rpg.manager.refactor.api;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;

@Entity(name="races")
@Table(name = "races")
public class Race {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int raceId;

    @NotEmpty
    private String raceName;
    @NotEmpty
    private String raceDescription;

}