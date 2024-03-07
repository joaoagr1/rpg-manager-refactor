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
public class SubclassController {

    @Autowired
    private SubclassRepository subclassRepository;


    @GetMapping("/subclasses")
    public ResponseEntity<List<Subclass>> getAllSubclasses() {
        List<Subclass> subclasses = subclassRepository.findAll();
        return ResponseEntity.ok().body(subclasses);
    }


    @GetMapping("/subclasses/{subclassId}")
    public ResponseEntity<Optional<Subclass>> getSublassById(@PathVariable Integer subclassId) {
        Optional<Subclass> subclasses = subclassRepository.findById(subclassId);
        return ResponseEntity.ok().body(subclasses);
    }

    @PostMapping("/subclasses/{subclassId}")
    public ResponseEntity<Subclass> createNewSubclass(@RequestBody SubclassCreateDTO newSubclass) {

        CharacterClass characterClass = subclassRepository.findById(newSubclass.())


        if (characterUpdate.subclass() != null) {
            Subclass subclass = subclassRepository.findById(characterUpdate.subclass())
                    .orElseThrow(() -> new ResourceNotFoundException("Subclass not found with id: " + characterUpdate.subclass()));
            character.setSubclass(subclass);
            System.out.println(subclass);
        }



        characterRepository.save(character);

        return ResponseEntity.ok(character);
    }

    @DeleteMapping("/subclasses/{subclassesId}")
    public ResponseEntity<?> deleteSublass(@PathVariable Integer subClassId) {
        subclassRepository.deleteById(subClassId);
        return ResponseEntity.noContent().build();
    }


}
