package rpg.manager.refactor.api;

import jakarta.persistence.*;

@Entity
@Table(name = "subrace")
public class Subrace {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long subraceId;

    private String subraceName;
    private String subraceDescription;

    @OneToOne
    private Race race;

}