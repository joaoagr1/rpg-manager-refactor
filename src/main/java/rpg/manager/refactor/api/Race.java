package rpg.manager.refactor.api;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Entity(name = "races")
@Table(name = "races")
@EqualsAndHashCode(of = "raceId")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Race {
    @JsonIgnore
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int raceId;

    @NotEmpty
    private String raceName;
    @NotEmpty
    private String raceDescription;

}