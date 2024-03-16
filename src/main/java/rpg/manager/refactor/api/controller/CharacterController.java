package rpg.manager.refactor.api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import rpg.manager.refactor.api.CharacterFeaturesDAO;
import rpg.manager.refactor.api.CharacterRepository;
import rpg.manager.refactor.api.Character_;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api")
public class CharacterController {


    @Autowired
    private CharacterRepository characterRepository;

    @Autowired

    @GetMapping("/character")
    public List<Character_> getAllCharacters() {
        return characterRepository.findAll();
    }


    @GetMapping("/character/traits/{characterId}")
    public List<CharacterFeaturesDAO> getAllTraits(@PathVariable Integer characterId) {
     Optional<Character_> characterPicked = characterRepository.findById(characterId);
     Integer currentLevel = characterPicked.get().getLevel();
        return characterRepository.findCharacterFeatures(characterId,currentLevel);
    }


}
