package rpg.manager.refactor.api;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity(name="subclasses")
@Table(name = "subclasses")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Subclass {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer subclassId;

    @ManyToOne
    @JoinColumn(name = "class_id")
    private CharacterClass characterClass;


    private String subclassName;
    private String subclassDescription;


    public Subclass(SubclassCreateDTO newSubclass) {
        this.subclassName = newSubclass.subClassName();
        this.subclassDescription = newSubclass.subClassDescription();
    }
}