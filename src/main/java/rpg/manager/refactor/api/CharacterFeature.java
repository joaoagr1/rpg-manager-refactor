package rpg.manager.refactor.api;


import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "character_features_view")
@NoArgsConstructor
@AllArgsConstructor
@Data
public class CharacterFeature {

    @Id
    private Integer id;

    private Integer characterId;
    private String name;
    private String description;
    private Integer level;
    private String type;
    private String source;

    private CharacterFeature(CharacterFeatureDAO characterFeatureDAO) {
        this.id = characterFeatureDAO.id();
        this.characterId = characterFeatureDAO.characterId();
        this.name = characterFeatureDAO.name();
        this.description = characterFeatureDAO.description();
        this.level = characterFeatureDAO.level();
        this.type = characterFeatureDAO.type();
        this.source = characterFeatureDAO.source();

    }

}

