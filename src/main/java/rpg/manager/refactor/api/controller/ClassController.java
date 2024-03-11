package rpg.manager.refactor.api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import rpg.manager.refactor.api.CharacterClass;
import rpg.manager.refactor.api.CharacterClassRepository;

import java.util.List;

@RestController
@RequestMapping("/api")
public class ClassController {

    @Autowired
    CharacterClassRepository characterClassRepository;

    @GetMapping("/classes")
    public ResponseEntity<List<CharacterClass>> getAllCharacters() {
        List<CharacterClass> classes = characterClassRepository.findAll();
        return ResponseEntity.ok().body(classes);
    }


    @PostMapping("/classes")
    public ResponseEntity<CharacterClass> createNewClass(@RequestBody CharacterClass newClass){
        characterClassRepository.save(newClass);
        return ResponseEntity.ok().body(newClass);
    }

    @DeleteMapping("/classes/{classId}")
    public ResponseEntity<?> deleteClass(@PathVariable Integer classId){
        characterClassRepository.deleteById(classId);
        return ResponseEntity.noContent().build();
    }

}
