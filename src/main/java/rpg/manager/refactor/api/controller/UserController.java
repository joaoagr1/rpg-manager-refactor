package rpg.manager.refactor.api.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import rpg.manager.refactor.api.User;
import rpg.manager.refactor.api.UserRepository;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api")
public class UserController {

    @Autowired
    UserRepository userRepository;

    @GetMapping("/user")
    public ResponseEntity<List<User>> getAllUsers() {
        return ResponseEntity.ok().body(userRepository.findAll());
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<Optional<User>> getUserById(@PathVariable Integer userId) {
        return ResponseEntity.ok().body(userRepository.findById(userId));
    }

    @DeleteMapping("user/{userId}")
    public ResponseEntity<?> deleteUser(@PathVariable Integer userId){
            userRepository.deleteById(userId);
            return ResponseEntity.noContent().build();}


    @PostMapping("user")
    public ResponseEntity<User> createUser(@RequestBody User newUser){
        userRepository.save(newUser);
        return ResponseEntity.ok().body(newUser);

    }
}
