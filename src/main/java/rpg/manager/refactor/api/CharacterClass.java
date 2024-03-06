package rpg.manager.refactor.api;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Entity(name="classes")
@Table(name = "classes")
@Data
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(of = "classId")
public class CharacterClass {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int classId;

    private String className;
    private String classDescription;

}