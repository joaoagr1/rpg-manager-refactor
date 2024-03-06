package rpg.manager.refactor.api.controller;

import org.apache.velocity.exception.ResourceNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import rpg.manager.refactor.api.Character;
import rpg.manager.refactor.api.CharacterRepository;
import rpg.manager.refactor.api.CharacterUpdateDTO;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api")
public class CharacterController {

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

        // Atualiza os campos do personagem com os valores fornecidos no CharacterUpdate
        if (characterUpdate.characterName() != null) {
            character.setCharacterName(characterUpdate.characterName());
        }
        if (characterUpdate.alignment() != null) {
            character.setAlignment(characterUpdate.alignment());
        }
        // Atualize os demais campos conforme necessário

        // Salva o personagem atualizado no banco de dados
        characterRepository.save(character);

        return ResponseEntity.ok(character);
    }

}
