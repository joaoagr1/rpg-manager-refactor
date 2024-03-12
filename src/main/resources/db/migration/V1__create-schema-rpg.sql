-- Criando Tabelas
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    INDEX idx_username (username)
);

CREATE TABLE IF NOT EXISTS races (
    race_id INT AUTO_INCREMENT PRIMARY KEY,
    race_name VARCHAR(255) NOT NULL,
    race_description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS racial_traits (
    racial_trait_id INT AUTO_INCREMENT PRIMARY KEY,
    race_id INT,
    FOREIGN KEY (race_id) REFERENCES races(race_id),
    racial_trait_level INT,
    racial_trait_description TEXT,
    racial_trait_name varchar(255),
    type varchar(255) DEFAULT 'Racial',
    INDEX idx_race_id (race_id)
);

CREATE TABLE IF NOT EXISTS subraces (
	subrace_id INT AUTO_INCREMENT PRIMARY KEY,
    subrace_name VARCHAR(255) NOT NULL,
    race_id INT,
    FOREIGN KEY (race_id) REFERENCES races(race_id),
    subrace_description TEXT NOT NULL

    );



CREATE TABLE IF NOT EXISTS subracial_traits (
    subracial_trait_id INT AUTO_INCREMENT PRIMARY KEY,
    subrace_id INT,
    FOREIGN KEY (subrace_id) REFERENCES subraces(subrace_id),
    subracial_trait_level INT,
    subracial_traits_name VARCHAR(50),
    subracial_trait_description TEXT,
    INDEX idx_subrace_id (subrace_id)
);


CREATE TABLE IF NOT EXISTS classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL,
    class_description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS class_features (
    class_feature_id INT AUTO_INCREMENT PRIMARY KEY,
    class_id INT,
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    level INT,
    class_feature_name VARCHAR(50) NOT NULL,
    class_feature_description TEXT NOT NULL,
    type varchar(255) DEFAULT 'Class',
    INDEX idx_class_id (class_id)
);


CREATE TABLE IF NOT EXISTS subclasses (
subclass_id INT AUTO_INCREMENT PRIMARY KEY,
class_id INT,
FOREIGN KEY (class_id) REFERENCES classes(class_id),
subclass_name VARCHAR(50) NOT NULL,
subclass_description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS subclass_features (
	subclass_feature_id INT AUTO_INCREMENT PRIMARY KEY,
    subclass_id INT,
    FOREIGN KEY (subclass_id) REFERENCES subclasses(subclass_id),
    level INT,
    subclass_feature_name VARCHAR(50) NOT NULL,
    subclass_feature_description TEXT NOT NULL,
    INDEX idx_subclass_id (subclass_id)
);


CREATE TABLE IF NOT EXISTS characters (
    character_id INT AUTO_INCREMENT PRIMARY KEY,
    character_name VARCHAR(50) NOT NULL,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    alignment VARCHAR(50),
    race_id INT,
    FOREIGN KEY (race_id) REFERENCES races(race_id),
    subrace_id INT,
    FOREIGN KEY (subrace_id) REFERENCES subraces(subrace_id),
    class_id INT,
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
 	character_journal TEXT,
    character_image VARCHAR(255),
    proficiency_bonus INT,
    current_life INT DEFAULT 0,
    max_life INT,
    inspiration BOOL DEFAULT false,
    backstory TEXT,
    movement INT DEFAULT 0,
    background Varchar(20),
    INDEX idx_user_id (user_id),
    INDEX idx_race_id (race_id),
    INDEX idx_class_id (class_id)
);



CREATE TABLE IF NOT EXISTS spells (
    spell_id INT AUTO_INCREMENT PRIMARY KEY,
    spell_name VARCHAR(50) NOT NULL,
    spell_description TEXT
);

CREATE TABLE IF NOT EXISTS character_spells (
    character_id INT,
    FOREIGN KEY (character_id) REFERENCES characters(character_id) on delete cascade,
    spell_id INT,
    FOREIGN KEY (spell_id) REFERENCES spells(spell_id),
    PRIMARY KEY (character_id, spell_id),
    INDEX idx_character_id (character_id),
    INDEX idx_spell_id (spell_id)
);



CREATE TABLE IF NOT EXISTS items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(50) NOT NULL,
    item_description TEXT
);

CREATE TABLE IF NOT EXISTS character_items (
    character_id INT,
    FOREIGN KEY (character_id) REFERENCES characters(character_id) on delete cascade,
    item_id INT,
    amount INT,
    FOREIGN KEY (item_id) REFERENCES items(item_id),
    PRIMARY KEY (character_id, item_id),
    INDEX idx_character_id (character_id),
    INDEX idx_item_id (item_id)
);



CREATE TABLE IF NOT EXISTS attribute_points (
    character_id INT,
    FOREIGN KEY (character_id) REFERENCES characters(character_id) on delete cascade,
    STR INT,
    DEX INT,
    CON INT,
    INT_ INT,
    WIS INT,
    CHA INT,
    PRIMARY KEY (character_id)
);


CREATE TABLE IF NOT EXISTS features (
    feature_id INT AUTO_INCREMENT PRIMARY KEY,
    feature_name VARCHAR(50) NOT NULL,
    feature_description TEXT
);


CREATE TABLE IF NOT EXISTS character_features (
    character_id INT,
    FOREIGN KEY (character_id) REFERENCES characters(character_id) on delete cascade,
    feature_id INT,
    FOREIGN KEY (feature_id) REFERENCES features(feature_id),
    PRIMARY KEY (character_id, feature_id),
    INDEX idx_character_id (character_id),
    INDEX idx_feature_id (feature_id)
);



CREATE TABLE IF NOT EXISTS skills (
    character_id INT,
    FOREIGN KEY (character_id) REFERENCES characters(character_id) on delete cascade,
    acrobatics INT,
    animal_handling INT,
    arcana INT,
    athletics INT,
    deception INT,
    history INT,
    insight INT,
    intimidation INT,
    investigation INT,
    medicine INT,
    nature INT,
    perception INT,
    performance INT,
    persuasion INT,
    religion INT,
    sleight_of_hand INT,
    stealth INT,
    survival INT
);