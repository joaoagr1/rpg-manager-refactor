package rpg.manager.refactor.api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import rpg.manager.refactor.api.CharacterRepository;
import rpg.manager.refactor.api.Character_;

import java.util.List;

@RestController
@RequestMapping("/api")
public class CharacterController {


    @Autowired
    private CharacterRepository characterRepository;

    @GetMapping("/character")
    public List<Character_> getAllCharacters() {
        return characterRepository.findAll();
    }



}
