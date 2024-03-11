package rpg.manager.refactor.api;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity(name = "character_class")
@Table(name = "character_class")
@EqualsAndHashCode(of = "classId" )
public class Character_Class {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long classId;

    private String className;
    private String classDescription;

    @OneToOne(mappedBy = "characterClass")
    private Character character;

    @OneToOne
    @JoinColumn(name = "subclass_id")
    private Subclass subclass;

}
