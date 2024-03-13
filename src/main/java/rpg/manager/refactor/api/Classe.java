package rpg.manager.refactor.api;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;


@Entity
@Table(name = "classes")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Classe {
    @Id
    @JsonIgnore
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long classId;
    private String className;
    private String classDescription;

    @OneToMany(mappedBy = "classe", cascade = CascadeType.ALL)
    private List<Feature> classFeatures;

}