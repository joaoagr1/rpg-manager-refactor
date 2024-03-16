package rpg.manager.refactor.api;

public record CharacterFeatureDAO(
        Integer id,
        Integer characterId,
        String name,
        String description,
        Integer level,
        String type,
        String source
) {
}
