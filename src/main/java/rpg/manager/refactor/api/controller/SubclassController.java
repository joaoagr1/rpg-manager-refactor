package rpg.manager.refactor.api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import rpg.manager.refactor.api.Subclass;
import rpg.manager.refactor.api.SubclassRepository;

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
    public ResponseEntity<Optional<Subclass>> getSublassById(@PathVariable Integer subclassId){
        Optional<Subclass> subclasses = subclassRepository.findById(subclassId);
        return ResponseEntity.ok().body(subclasses);
    }

    @PostMapping("/subclasses")
    public ResponseEntity<Subclass> createNewSubclass(@RequestBody Subclass newSubclass){
        subclassRepository.save(newSubclass);
        return ResponseEntity.ok().body(newSubclass);
    }

    @DeleteMapping("/subclasses/{subclassesId}")
    public ResponseEntity<?> deleteSublass(@PathVariable Integer subClassId){
        subclassRepository.deleteById(subClassId);
        return ResponseEntity.noContent().build();
    }


}
