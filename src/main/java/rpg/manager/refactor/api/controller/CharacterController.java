package rpg.manager.refactor.api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import rpg.manager.refactor.api.Character;
import rpg.manager.refactor.api.CharacterRepository;

import java.util.Optional;


@RestController
    public class CharacterController {

        @Autowired
    CharacterRepository characterRepository;

        @GetMapping("/hello")
        public Optional<Character> helloWorld() {
            return characterRepository.findById(1);
        }
    }


