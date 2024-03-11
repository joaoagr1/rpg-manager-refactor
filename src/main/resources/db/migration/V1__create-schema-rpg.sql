CREATE TABLE user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    INDEX idx_username (username)
);

CREATE TABLE race (
    race_id INT AUTO_INCREMENT PRIMARY KEY,
    race_name VARCHAR(255),
    race_description TEXT
);

CREATE TABLE subrace (
    subrace_id INT AUTO_INCREMENT PRIMARY KEY,
    race_id INT,
    FOREIGN KEY (race_id) REFERENCES race(race_id)
);

CREATE TABLE character_class (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(255),
    class_description TEXT
);

CREATE TABLE subclass (
    subclass_id INT AUTO_INCREMENT PRIMARY KEY,
    subclass_name VARCHAR(255),
    subclass_description TEXT,
    class_id INT,
    FOREIGN KEY (class_id) REFERENCES character_class(class_id)
);

CREATE TABLE item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    description TEXT,
    quantity INT
);

CREATE TABLE characters (
    character_id INT AUTO_INCREMENT PRIMARY KEY,
    character_name VARCHAR(255),
    user_id INT,
    alignment VARCHAR(50),
    race_id INT,
    class_id INT,
    character_journal TEXT,
    character_image VARCHAR(255),
    proficiency_bonus INT,
    current_life INT,
    max_life INT,
    inspiration BOOLEAN,
    backstory TEXT,
    movement INT,
    background VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (race_id) REFERENCES race(race_id),
    FOREIGN KEY (class_id) REFERENCES character_class(class_id)
);
