package rpg.manager.refactor.api;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "feature")
public class Feature {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long featureId;
    private int level;
    private String featureName;
    private String featureDescription;
    private String type;

    @ManyToOne
    @JoinColumn(name = "subclass_id")
    private Subclass subclass;

    @ManyToOne
    @JoinColumn(name = "class_id")
    private Classe classe;
}
