package rpg.manager.refactor.api.controller;

import org.apache.velocity.exception.ResourceNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import rpg.manager.refactor.api.*;
import rpg.manager.refactor.api.Character;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api")
public class CharacterController {

    @Autowired
    private SubclassRepository subclassRepository;

    @Autowired
    private CharacterRepository characterRepository;

    @GetMapping("/character")
    public ResponseEntity<List<Character>> getAllCharacters() {
        List<Character> characters = characterRepository.findAll();
        return ResponseEntity.ok().body(characters);
    }

    @GetMapping("/character/{characterId}")
    public ResponseEntity<Optional<Character>> getCharacterById(@PathVariable Integer characterId) {
        Optional<Character> character = characterRepository.findById(characterId);
        return ResponseEntity.ok().body(character);
    }

    @GetMapping("/character/user/{userId}")
    public ResponseEntity<List<Character>> getCharactersByUser(@PathVariable Integer userId) {
        List<Character> character = characterRepository.findAllCharactersByUserId(userId);
        return ResponseEntity.ok().body(character);
    }

    @DeleteMapping("/character/{characterId}")
    public ResponseEntity<?> deleteCharacterById(@PathVariable Integer characterId) {
        characterRepository.deleteById(characterId);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/character/{characterId}")
    public ResponseEntity<Character> updateCharacterById(
            @PathVariable Integer characterId,
            @RequestBody CharacterUpdateDTO characterUpdate) {

        Character character = characterRepository.findById(characterId)
                .orElseThrow(() -> new ResourceNotFoundException("Character not found with id: " + characterId));



        if (characterUpdate.characterName() != null) {
            character.setCharacterName(characterUpdate.characterName());
        }
        if (characterUpdate.alignment() != null) {
            character.setAlignment(characterUpdate.alignment());
        }
        if (characterUpdate.characterJournal() != null) {
            character.setCharacterJournal(characterUpdate.characterJournal());
        }
        if (characterUpdate.characterImage() != null) {
            character.setCharacterImage(characterUpdate.characterImage());
        }
        if (characterUpdate.proficiencyBonus() != null) {
            character.setProficiencyBonus(characterUpdate.proficiencyBonus());
        }
        if (characterUpdate.currentLife() != null) {
            character.setCurrentLife(characterUpdate.currentLife());
        }
        if (characterUpdate.maxLife() != null) {
            character.setMaxLife(characterUpdate.maxLife());
        }
        if (characterUpdate.inspiration() != null) {
            character.setInspiration(characterUpdate.inspiration());
        }
        if (characterUpdate.backstory() != null) {
            character.setBackstory(characterUpdate.backstory());
        }
        if (characterUpdate.movement() != null) {
            character.setMovement(characterUpdate.movement());
        }
        if (characterUpdate.background() != null) {
            character.setBackground(characterUpdate.background());
        }


        characterRepository.save(character);

        return ResponseEntity.ok(character);
    }


}
