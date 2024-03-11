package rpg.manager.refactor.api;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity(name = "subclass")
@Table(name = "subclass")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Subclass {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long subclassId;

    private String subclassName;
    private String subclassDescription;

    @OneToOne(mappedBy = "subclass")
    private Character_Class characterClass;

}