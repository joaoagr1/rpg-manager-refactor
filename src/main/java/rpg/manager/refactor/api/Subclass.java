package rpg.manager.refactor.api;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "subclasses")
@NoArgsConstructor
@AllArgsConstructor
@Data
public class Subclass {
    @Id
    @JsonIgnore
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long subclassId;
    private String subclassName;
    private String subclassDescription;

    @ManyToOne
    @JsonIgnore
    @JoinColumn(name = "class_id")
    private Classe classe;


}