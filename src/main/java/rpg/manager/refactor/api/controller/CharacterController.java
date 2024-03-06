package rpg.manager.refactor.api.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;


    @RestController
    public class CharacterController {

        @GetMapping("/hello")
        public String helloWorld() {
            return "Hello, world!";
        }
    }


