package rpg.manager.refactor.api;

public record CharacterUpdateDTO( String characterName,
                                  String alignment,
                                  Integer subclass,
                                  String characterJournal,
                                  String characterImage,
                                  Integer proficiencyBonus,
                                  Integer currentLife,
                                  Integer maxLife,
                                  Boolean inspiration,
                                  String backstory,
                                  Integer movement,
                                  String background) {
}
