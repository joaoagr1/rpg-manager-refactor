package rpg.manager.refactor.api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import rpg.manager.refactor.api.Race;
import rpg.manager.refactor.api.RaceRepository;

import java.util.List;

@RestController
@RequestMapping("/api")
public class RaceController {

    @Autowired
    private RaceRepository raceRepository;

    @GetMapping("/races")
    public ResponseEntity<List<Race>> getAllRaces() {
        List<Race> races = raceRepository.findAll();
        return ResponseEntity.ok().body(races);
    }

    @PostMapping("/races")
    public ResponseEntity<Race> createRace(@RequestBody Race newRace){
        raceRepository.save(newRace);
        return ResponseEntity.ok(newRace);

    }


}
