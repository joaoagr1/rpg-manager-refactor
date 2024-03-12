package rpg.manager.refactor.api;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Entity(name = "class")
@Table(name = "classes")
@EqualsAndHashCode(of = "classId")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class CharacterClass {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "class_id")
    private Integer classId;

    @Column(name = "class_name", nullable = false, length = 50)
    private String className;

    @Column(name = "class_description", nullable = false, columnDefinition = "TEXT")
    private String classDescription;

    @Transient
    private Subclass subclass;

}