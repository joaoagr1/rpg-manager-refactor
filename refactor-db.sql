DROP DATABASE IF EXISTS rpg;
-- Criando e usando Banco de dados rpg
CREATE DATABASE IF NOT EXISTS rpg;
USE rpg;


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
    race_description VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS racial_traits (
    racial_trait_id INT AUTO_INCREMENT PRIMARY KEY,
    race_id INT,
    FOREIGN KEY (race_id) REFERENCES races(race_id),
    racial_trait_level INT,
    racial_trait_description VARCHAR(255),
    racial_trait_name varchar(255),
    type varchar(255) DEFAULT 'Racial',
    INDEX idx_race_id (race_id)
);

CREATE TABLE IF NOT EXISTS subraces (
	subrace_id INT AUTO_INCREMENT PRIMARY KEY,
    subrace_name VARCHAR(255) NOT NULL,
    race_id INT,
    FOREIGN KEY (race_id) REFERENCES races(race_id),
    subrace_description VARCHAR(255) NOT NULL
    
    );
    


CREATE TABLE IF NOT EXISTS subracial_traits (
    subracial_trait_id INT AUTO_INCREMENT PRIMARY KEY,
    subrace_id INT,
    FOREIGN KEY (subrace_id) REFERENCES subraces(subrace_id),
    subracial_trait_level INT,
    subracial_traits_name VARCHAR(50),
    subracial_trait_description VARCHAR(255),
    INDEX idx_subrace_id (subrace_id)
);


CREATE TABLE IF NOT EXISTS classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL,
    class_description VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS class_features (
    class_feature_id INT AUTO_INCREMENT PRIMARY KEY,
    class_id INT,
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    level INT,
    class_feature_name VARCHAR(50) NOT NULL,
    class_feature_description VARCHAR(255) NOT NULL,
    type varchar(255) DEFAULT 'Class',
    INDEX idx_class_id (class_id)
);


CREATE TABLE IF NOT EXISTS subclasses (
subclass_id INT AUTO_INCREMENT PRIMARY KEY,
class_id INT,
FOREIGN KEY (class_id) REFERENCES classes(class_id),
subclass_name VARCHAR(50) NOT NULL,
subclass_description VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS subclass_features (
	subclass_feature_id INT AUTO_INCREMENT PRIMARY KEY,
    subclass_id INT,
    FOREIGN KEY (subclass_id) REFERENCES subclasses(subclass_id),
    level INT,
    subclass_feature_name VARCHAR(50) NOT NULL,
    subclass_feature_description VARCHAR(255) NOT NULL,
    INDEX idx_subclass_id (subclass_id)
);


CREATE TABLE IF NOT EXISTS characters (
    character_id INT AUTO_INCREMENT PRIMARY KEY,
    character_name VARCHAR(50) NOT NULL,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    alignment VARCHAR(50),
    race_id INT,
    FOREIGN KEY (race_id) REFERENCES races(race_id),
    subrace_id INT,
    FOREIGN KEY (subrace_id) REFERENCES subraces(subrace_id),
    class_id INT,
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    subclass_id INT,
    FOREIGN KEY (subclass_id) REFERENCES subclasses(subclass_id),
	character_journal TEXT,
    character_image VARCHAR(255),
    proficiency_bonus INT,
    current_life INT,
    max_life INT,
    inspiration BOOL,
    backstory TEXT,
    movement INT,
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

--Criando Triggers
DELIMITER //

CREATE TRIGGER add_attributes_after_insert_character
AFTER INSERT ON characters
FOR EACH ROW
BEGIN
    INSERT INTO attribute_points (character_id, STR, DEX, CON, INT_, WIS, CHA)
    VALUES (NEW.character_id, 0, 0, 0, 0, 0, 0);
END;
//

DELIMITER ;




-- Criando Views
CREATE VIEW character_details AS
SELECT 
    c.character_id,
    c.character_name,
    c.alignment,
    c.character_journal,
    c.character_image,
    c.proficiency_bonus,
    c.max_life,
    c.current_life,
    u.username AS user_name,
    r.race_name,
    r.race_description,
    cls.class_name,
    cls.class_description,
    ap.STR,
    ap.DEX,
    ap.CON,
    ap.INT_,
    ap.WIS,
    ap.CHA
FROM 
    characters c
JOIN 
    users u ON c.user_id = u.user_id
JOIN 
    races r ON c.race_id = r.race_id
JOIN 
    classes cls ON c.class_id = cls.class_id
JOIN 
    attribute_points ap ON c.character_id = ap.character_id;
    
    


-- Fazendo Inserts Padrões ------------------------------------------------------------------------------------
INSERT INTO races (race_name, race_description) VALUES 
('Humanos', 'Humanos em D&D são uma raça versátil e diversificada, conhecida por sua adaptabilidade e ambição. Seu espírito inquieto os leva a explorar todos os cantos do mundo, em busca de aventuras, poder e conhecimento.'),
('Elfos', 'Os elfos são seres graciosos e imortais, dotados de beleza e sabedoria. Vivendo em harmonia com a natureza, eles são guardiões das florestas e dos segredos antigos. Seus laços com a magia são profundos, e muitos elfos dominam os segredos das artes arcanas. No entanto, sua longa vida os torna cautelosos em relação aos assuntos dos mortais.'),
('Anões', 'Conhecidos por sua força e habilidade em trabalhar com metais e pedras, os anões são mestres artesãos e guerreiros destemidos. Profundamente ligados às montanhas e às cavernas, eles protegem seus lares com tenacidade e honra. Seu amor pelo trabalho duro é equiparado apenas pela sua paixão por festas e canções.'),
('Halflings', 'Os halflings são criaturas pequeninas, mas cheias de vida e aventura. Conhecidos por sua hospitalidade e alegria de viver, eles levam uma vida simples, desfrutando de boa comida, boa companhia e boas histórias. Apesar de seu tamanho diminuto, os halflings são conhecidos por sua coragem e habilidade em escapar de perigos.'),
('Meio-Elfos', 'Meio-humanos, meio-elfos, essa raça é o produto da união entre humanos e elfos. Eles herdaram a curiosidade dos humanos e a graça dos elfos, mas muitas vezes se sentem deslocados em ambas as sociedades. No entanto, essa dualidade lhes confere uma perspectiva única do mundo, tornando-os capazes de navegar por diferentes culturas com facilidade.'),
('Meio-Orcs', 'Nascidos da união entre humanos e orcs, os meio-orcs são frequentemente mal compreendidos e temidos pela sociedade. No entanto, sua força física e determinação os tornam guerreiros formidáveis. Apesar das adversidades que enfrentam, muitos meio-orcs encontram força em sua herança mista e lutam para provar seu valor ao mundo.'),
('Gnomos', 'Os gnomos são seres pequeninos e travessos, conhecidos por sua paixão pela invenção e pela descoberta. Vivendo em buracos de topos de colinas e em cavernas escondidas, eles são mestres em magia ilusória e engenhocas mecânicas. Apesar de seu tamanho diminuto, sua curiosidade os leva a explorar os mistérios do mundo e a enfrentar grandes desafios com um sorriso no rosto.'),
('Tieflings', 'Descendentes de humanos e seres infernais, os tieflings carregam marcas de sua herança demoníaca em suas feições e em suas almas. Muitas vezes ostracizados pela sociedade, eles lutam para encontrar seu lugar no mundo e para superar os estigmas do passado. No entanto, sua herança diabólica também lhes confere poderes sombrios e uma determinação inabalável.'),
('Dragonborns', 'Os dragonborns são descendentes dos dragões ancestrais, dotados de escamas resplandecentes e fôlego de fogo. Orgulhosos e nobres, eles carregam o legado de suas linhagens dragônicas, defendendo a honra e a justiça com garras afiadas e corações valentes. Seu vínculo com os dragões os torna poderosos aliados e temidos adversários.'),
('Aasimars', 'Nascidos da união entre humanos e seres celestiais, os aasimars são portadores de uma luz divina, destinados a realizar grandes feitos e a espalhar o bem pelo mundo. Dotados de asas de anjo e olhos radiantes, eles são mensageiros da esperança e da redenção, lutando contra as forças das trevas e protegendo os indefesos.');


INSERT INTO subraces (subrace_name, race_id, subrace_description) 
VALUES ('Elfo da floresta', 2, 'Os elfos da floresta são caçadores e exploradores habilidosos, que vivem em harmonia com a natureza. Eles são ágeis e furtivos, capazes de se mover silenciosamente pelas florestas e se camuflar entre as sombras. Os elfos da floresta valorizam a liberdade, a independência e a conexão com o mundo natural.'),
('Alto Elfo', 2, 'Os altos elfos são graciosos e eruditos, dotados de uma afinidade natural pela magia. Eles são conhecidos por sua cultura refinada, suas habilidades mágicas e sua longevidade. Altos elfos geralmente vivem em reinos élficos majestosos, onde praticam suas artes mágicas e estudam os segredos do mundo.'),
('Drow', 2, 'Os elfos negros, ou drows, são uma subraça de elfos que vivem nas profundezas do Subterrâneo, em reinos sinistros e reinos das trevas. Eles são conhecidos por sua habilidade em magia sombria, suas intrigas políticas e suas habilidades em combate. Os drows são muitas vezes vistos como malignos pelos outros povos, devido à sua associação com deuses sombrios e sua sociedade complexa e muitas vezes cruel.'),
('Anão da Montanha', 3, 'Os anões da montanha são robustos e resistentes, nascidos das profundezas das cadeias de montanhas mais altas. Eles são mestres artesãos e guerreiros formidáveis, conhecidos por sua habilidade em trabalhar com metais e sua determinação inabalável.'),
('Anão da Colina', 3, 'Os anões da colina são conhecidos por sua hospitalidade e sua forte conexão com a terra. Eles preferem viver em comunidades agrícolas e são habilidosos em cultivar a terra e criar gado. Apesar de sua estatura pequena, os anões da colina são tão resistentes quanto seus primos das montanhas.'),
('Halfling Pé Leve', 4, 'Os halflings pé leve são conhecidos por sua habilidade em se mover silenciosamente e evitar perigos. Eles são ágeis e furtivos, capazes de se esgueirar pelos cantos mais apertados e escapar de situações difíceis com facilidade.'),
('Halfling Forte da Terra', 4, 'Os halflings forte da terra são conhecidos por sua determinação e resistência. Eles são trabalhadores incansáveis e valorizam a estabilidade e a segurança de suas comunidades. Apesar de seu tamanho diminuto, os halflings forte da terra são tão corajosos e destemidos quanto qualquer outra raça.'),
('Gnomo da Floresta', 7, 'Os gnomos da floresta são criaturas curiosas e brincalhonas, que vivem em harmonia com a natureza. Eles são conhecidos por sua afinidade com animais e plantas, e muitas vezes servem como guardiões dos bosques e das florestas.'),
('Gnomo das Rochas', 7, 'Os gnomos das rochas são hábeis artesãos e engenheiros, que vivem nas profundezas das montanhas. Eles são conhecidos por suas habilidades em trabalhar com metais e pedras, e muitas vezes constroem elaboradas cidades subterrâneas onde realizam experimentos e invenções.');




INSERT INTO classes (class_name, class_description) VALUES 
('Barbarian', 'Os bárbaros são verdadeiros mestres da força bruta e da ira desenfreada. Eles são guerreiros ferozes, que canalizam sua raiva interior para desferir golpes devastadores contra seus inimigos. Suas habilidades em combate são tão formidáveis quanto sua determinação em proteger seus aliados e subjugar seus adversários.'),
('Bard', 'Os bardos são artistas, músicos e contadores de histórias versáteis e carismáticos. Eles usam sua criatividade e habilidades artísticas para inspirar seus aliados e confundir seus inimigos. Além de suas habilidades musicais, os bardos também dominam as artes da persuasão e da diplomacia, tornando-se figuras importantes em qualquer grupo de aventureiros.'),
('Cleric', 'Os clérigos são servos divinos, canalizadores de poderes divinos. Eles dedicam suas vidas ao serviço de seus deuses, utilizando sua fé e devoção para curar os feridos, proteger os inocentes e banir o mal. Além de suas habilidades de cura, os clérigos também são capazes de invocar a ira divina sobre seus inimigos, tornando-se poderosos combatentes em nome de sua fé.'),
('Druid', 'Os druidas são guardiões da natureza e transformadores de formas. Eles possuem uma profunda conexão com o mundo natural, sendo capazes de assumir a forma de animais e invocar os poderes dos elementos. Além de protegerem a vida selvagem, os druidas também são defensores da harmonia e do equilíbrio na natureza, lutando contra aqueles que desejam despojar a terra de sua beleza e vitalidade.'),
('Fighter', 'Os guerreiros são mestres em combate, hábeis com armas e armaduras. Eles são os heróis de batalha, liderando a linha de frente contra as forças do mal e protegendo os indefesos. Com treinamento e determinação, os guerreiros dominam uma variedade de estilos de luta e táticas de combate, tornando-se adversários formidáveis em qualquer campo de batalha.'),
('Monk', 'Os monges são mestres em artes marciais, buscadores da perfeição. Eles treinam seus corpos e mentes para atingir um estado de harmonia e equilíbrio, canalizando sua energia interna para realizar feitos sobre-humanos. Com habilidades acrobáticas e técnicas de combate incomparáveis, os monges são guerreiros formidáveis que buscam a excelência em todas as suas ações.'),
('Paladin', 'Os paladinos são cavaleiros divinos, defensores da justiça e da honra. Eles juram lealdade aos seus deuses e dedicam suas vidas ao serviço do bem e da retidão. Dotados de poderes divinos, os paladinos são guerreiros sagrados que lutam contra o mal onde quer que seja encontrado, protegendo os inocentes e punindo os culpados com a ira divina.'),
('Ranger', 'Os rangers são exploradores da natureza, hábeis rastreadores e caçadores. Eles percorrem as vastas terras selvagens em busca de aventuras e descobertas, protegendo a fronteira entre o mundo civilizado e as terras selvagens. Com suas habilidades de rastreamento e sua afinidade com a vida selvagem, os rangers são mestres em sobrevivência e caça, capazes de enfrentar os perigos mais extremos.'),
('Rogue', 'Os ladinos são furtivos e astutos, especialistas em engano e sabotagem. Eles vivem à margem da sociedade, operando nas sombras e usando sua habilidade para se infiltrar em lugares onde outros não se atreveriam a entrar. Com suas habilidades de furto e sua destreza em combate, os ladinos são mestres em resolver problemas de maneiras pouco convencionais.'),
('Sorcerer', 'Os feiticeiros são portadores de magia inata, moldadores de poder arcano. Eles nascem com um dom para a magia, canalizando sua energia interna para lançar feitiços e conjurar magias poderosas. Embora sua magia possa ser imprevisível e perigosa, os feiticeiros são capazes de moldar a realidade de acordo com sua vontade, tornando-se verdadeiros mestres do oculto.'),
('Warlock', 'Os pactuadores com entidades sobrenaturais, detentores de magia misteriosa. Os bruxos fazem pactos com seres de poderes além da compreensão humana, trocando sua alma por conhecimento proibido e poderes arcanos. Com seu pacto demoníaco ou pacto feérico, os bruxos são capazes de conjurar magias sombrias e realizar feitos sobrenaturais, mas sempre às custas de sua própria alma.'),
('Wizard', 'Os magos são estudiosos de magia arcana, manipuladores de energia mística. Eles passam anos estudando os segredos do universo, desvendando os mistérios da magia e experimentando com os elementos do cosmo. Com seus grimórios repletos de feitiços e sua compreensão profunda da magia, os magos são capazes de manipular a realidade e desencadear poderes inimagináveis.');



INSERT INTO spells (spell_name, spell_description) VALUES
('Fireball', 'A bola de fogo explode num raio de 20 pés. Causa 8d6 de dano de fogo em uma área de 20 pés de raio.'),
('Magic Missile', 'Três dardos mágicos voam em direção a alvos à sua escolha dentro do alcance. Cada dardo atinge automaticamente e causa 1d4+1 de dano de força.'),
('Cure Wounds', 'Uma criatura que você toca recupera uma quantidade de pontos de vida igual a 1d8 + seu modificador de habilidade de conjuração.'),
('Bless', 'Você abençoa até três criaturas à sua escolha dentro do alcance. Sempre que um alvo fizer uma jogada de ataque ou teste de resistência antes do feitiço terminar, o alvo pode jogar um d4 e adicionar o número jogado à jogada.'),
('Shield', 'Uma parede invisível de força mágica aparece e protege você. Até o início do seu próximo turno, você recebe um bônus de +5 na CA, incluindo contra o ataque que desencadeou essa reação.'),
('Detect Magic', 'Por até 10 minutos, você sente a presença de magia num raio de 30 pés ao seu redor. Se você sentir magia desta maneira, você pode usar sua ação para ver uma aura tênue ao redor de qualquer criatura ou objeto visível no alcance que carrega magia, e você aprende a escola de magia, se houver, de qualquer aura visível a você.'),
('Sleep', 'Essa magia envia criaturas para um sono profundo. Lance 5d8; a soma é quantos pontos de vida de criaturas essa magia pode afetar. Criaturas na área afetada pelo feitiço caem inconscientes até que o feitiço termine, o dano os desperte ou alguém os disperte.'),
('Thunderwave', 'Você cria uma onda de pressão sônica que irradia de você. Cada criatura em um cilindro de 15 pés centrado em você deve fazer um teste de resistência de Constituição. Na falha, uma criatura sofre 2d8 de dano trovejante e é empurrada para 10 pés longe de você. Na bem sucedida, a criatura sofre metade do dano e não é empurrada.'),
('Charm Person', 'Você tenta encantar uma criatura que você possa ver dentro do alcance. Ela deve fazer um teste de resistência de Sabedoria e fazer isso com vantagem se você ou seus companheiros são hostis a ela. Se ela falhar no teste, ela fica encantada por você até que o feitiço termine ou você ou seus companheiros a machuquem.'),
('Mage Armor', 'Você toca uma criatura voluntária que não esteja vestindo armadura e uma proteção mágica envolve-a até que o feitiço termine. A CA da criatura torna-se 13 + seu modificador de Destreza.'),
('Guiding Bolt', 'Faça um ataque à distância com magia contra uma criatura ou objeto alvo. No acerto, o alvo sofre 4d6 de dano radiante e a próxima jogada de ataque contra esse alvo tem vantagem, desde que seja feita antes do final do seu próximo turno.'),
('Magic Missile', 'Crie três dardos mágicos. Cada dardo atinge uma criatura à sua escolha que você possa ver dentro do alcance. Cada dardo causa 1d4 + 1 de dano de força.'),
('Burning Hands', 'Emanações de fogo sibilante explodem da sua palma. Cada criatura num cone de 15 pés deve fazer um teste de resistência de Destreza. Uma criatura sofre 3d6 de dano de fogo, ou metade do dano num sucesso no teste de resistência.'),
('Healing Word', 'Um aliado que você vê e pode ouvir ganha 1d4 + seu modificador de habilidade de cura pontos de vida. Isso não tem efeito em mortos-vivos ou construtos.'),
('Thunderbolt', 'Você cria uma linha de energia elétrica com 100 pés de comprimento e 5 pés de largura. Cada criatura na linha deve fazer um teste de resistência de Destreza. Uma criatura sofre 8d6 de dano de trovão num fracasso no teste de resistência, ou metade desse dano num sucesso.'),
('Fly', 'Você toca uma criatura. A criatura ganha um deslocamento de voo de 60 pés pelo período do feitiço.'),
('Polymorph', 'Você transforma uma criatura que você possa ver dentro do alcance numa nova forma. A nova forma pode ser qualquer criatura com um nível de desafio igual ou inferior ao nível do feitiço. O alvo assume as estatísticas da nova forma e volta a forma normal quando cair a 0 pontos de vida.'),
('Haste', 'Escolha uma criatura que você possa ver dentro do alcance. Até o feitiço terminar, a velocidade do alvo é dobrada, ele ganha um bônus de +2 na CA, tem vantagem em testes de resistência de Destreza e ganha uma ação adicional em cada um de seus turnos. A ação só pode ser usada para atacar (uma única arma de ataque apenas), disso, usar a ação para conjurar magias, ou usar a ação Derrubar.'),
('Dimension Door', 'Você teleporta a você mesmo de um local até outro local desocupado que você possa ver, até um alcance máximo igual a 500 pés.'),
('Dispel Magic', 'Escolha qualquer efeito mágico num alcance num raio de 120 pés ou de um objeto que você possa ver. Se o efeito for de um feitiço de 3º nível ou inferior, ele acaba. Se for de um feitiço de 4º nível ou superior, faça um teste de habilidade de conjuração contra a CD do feitiço.'),
('Hold Person', 'Escolha uma criatura que você possa ver dentro do alcance. O alvo deve ter sucesso num teste de resistência de Sabedoria ou ficará paralisado pelo feitiço por até 1 minuto. O alvo pode repetir o teste de resistência no final de cada um de seus turnos.'),
('Counterspell', 'Reaja a lançar um feitiço de 3º nível ou inferior que você vê sendo lançado dentro do alcance, ou se você estiver lançando o feitiço, faça um teste de habilidade de conjuração com CD igual a 10 + nível do feitiço oponente. Em caso de sucesso, o feitiço falha e tem efeito nenhum.'),
('Lightning Bolt', 'Um raio relampejante e brilhante é lançado numa linha reta, de 100 pés. Cada criatura na linha deve fazer um teste de resistência de Destreza. Uma criatura sofre 8d6 de dano de relâmpago num fracasso no teste de resistência, ou metade desse dano num sucesso.'),
('Mirror Image', 'Três imagens ilusórias de você aparecem na sua frente e duram pelo período do feitiço. Cada vez que uma criatura fizer um ataque corpo a corpo contra você, antes de fazer a jogada de ataque, você rola um d20 para determinar se o ataque o acerta, e não uma das suas imagens. Se você tem três imagens e rolar um 6 ou maior, o ataque o acerta uma das imagens.'),
('Hypnotic Pattern', 'Você cria um padrão hipnótico num cubo de 30 pés, dentro do alcance. A magia parece tão fascinante que cada criatura que termina o turno aliado ao cubo e vê a magia deve fazer um teste de resistência de Sabedoria. Num falha, a criatura fica encantada por até 1 minuto ou até sofrer dano.'),
('Darkness', 'Você cria uma esfera de escuridão mágica, um raio de 15 pés, centrado num ponto dentro do alcance. A escuridão se espalha em volta dos cantos e a escuridão é impenetrável, bloqueando a visão normal.'),
('Hold Monster', 'Escolha uma criatura que você possa ver dentro do alcance. O alvo deve ter sucesso num teste de resistência de Sabedoria ou ficará paralisado pelo feitiço por até 1 minuto. O alvo pode repetir o teste de resistência no final de cada um de seus turnos.'),
('Dominate Person', 'Você tenta hipnotizar uma criatura que você possa ver dentro do alcance. Ela deve fazer um teste de resistência de Sabedoria e fazê-lo com vantagem se você ou seus companheiros são hostis a ela. Se ela falhar no teste, ela fica encantada por você até que o feitiço termine ou você ou seus companheiros a machuquem.'),
('Teleportation Circle', 'Ao desenhar um círculo mágico com giz, tinta ou pó de gema, você cria um portal mágico que permanece aberto pelo período do feitiço. O portal liga a um círculo de destino em algum lugar em outro plano de existência.');


INSERT INTO racial_traits (race_id, racial_trait_level, racial_trait_name, racial_trait_description)
VALUES
(9, 1, 'Breath Weapon', 'Você pode usar sua ação para exalar energia destrutiva. Seu tipo de dano é determinado pela sua raça, como mostrado na tabela de traços raciais.'),
(9, 1, 'Damage Resistance', 'Você tem resistência ao tipo de dano associado à sua linhagem dracônica.'),
(9, 1, 'Draconic Ancestry', 'Você tem resistência ao tipo de dano associado à sua linhagem dracônica.'),
(1, 1, 'Extra Language', 'You can speak, read, and write one extra language of your choice.'),
(1, 1, 'Ability Score Increase', 'Two different ability scores of your choice increase by 1.'),
(1, 1, 'Feat', 'At 1st level, you gain one feat of your choice from those available to humans.'),
(2, 1, 'Ability Score Increase', 'Your Dexterity score increases by 2.'),
(2, 1, 'Darkvision', 'You can see in dim light within 60 feet of you as if it were bright light, and in darkness as if it were dim light.'),
(2, 1, 'Keen Senses', 'You have proficiency in the Perception skill.'),
(2, 1, 'Fey Ancestry', 'You have advantage on saving throws against being charmed, and magic cant put you to sleep.'),
(2, 1, 'Trance', 'Elves dont need to sleep. Instead, they meditate deeply, remaining semiconscious, for 4 hours a day. After resting in this way, you gain the same benefit that a human does from 8 hours of sleep.'),
(2, 1, 'Elf Weapon Training', 'You have proficiency with the longsword, shortsword, shortbow, and longbow.'),
(3, 1, 'Ability Score Increase', 'Your Constitution score increases by 2.'),
(3, 1, 'Darkvision', 'You can see in dim light within 60 feet of you as if it were bright light, and in darkness as if it were dim light.'),
(3, 1, 'Dwarven Resilience', 'You have advantage on saving throws against poison, and you have resistance against poison damage.'),
(3, 1, 'Dwarven Combat Training', 'You have proficiency with the battleaxe, handaxe, throwing hammer, and warhammer.'),
(3, 1, 'Tool Proficiency', 'You gain proficiency with the artisans tools of your choice: smiths tools, brewers supplies, or masons tools.'),
(3, 1, 'Stonecunning', 'Whenever you make an Intelligence (History) check related to the origin of stonework, you are considered proficient in the History skill and add double your proficiency bonus to the check, instead of your normal proficiency bonus.'),
(4, 1, 'Ability Score Increase', 'Your Dexterity score increases by 2.'),
(4, 1, 'Lucky', 'When you roll a 1 on an attack roll, ability check, or saving throw, you can reroll the die and must use the new roll.'),
(4, 1, 'Brave', 'You have advantage on saving throws against being frightened.'),
(4, 1, 'Halfling Nimbleness', 'You can move through the space of any creature that is of a size larger than yours.'),
(4, 1, 'Naturally Stealthy', 'You can attempt to hide even when you are obscured only by a creature that is at least one size larger than you.'),
(5, 1, 'Ability Score Increase', 'Your Charisma score increases by 2, and two other ability scores of your choice each increase by 1.'),
(5, 1, 'Size', 'Medium'),
(5, 1, 'Speed', 'Your base walking speed is 30 feet.'),
(5, 1, 'Darkvision', 'You can see in dim light within 60 feet of you as if it were bright light, and in darkness as if it were dim light.'),
(5, 1, 'Fey Ancestry', 'You have advantage on saving throws against being charmed, and magic can’t put you to sleep.'),
(5, 1, 'Skill Versatility', 'You gain proficiency in two skills of your choice.'),
(6, 1, 'Ability Score Increase', 'Your Strength score increases by 2, and your Constitution score increases by 1.'),
(6, 1, 'Size', 'Medium'),
(6, 1, 'Speed', 'Your base walking speed is 30 feet.'),
(6, 1, 'Darkvision', 'You can see in dim light within 60 feet of you as if it were bright light, and in darkness as if it were dim light.'),
(6, 1, 'Menacing', 'You gain proficiency in the Intimidation skill.'),
(6, 1, 'Relentless Endurance', 'When you are reduced to 0 hit points but not killed outright, you can drop to 1 hit point instead. You can’t use this feature again until you finish a long rest.'),
(6, 1, 'Savage Attacks', 'When you score a critical hit with a melee weapon attack, you can roll one of the weapon’s damage dice one additional time and add it to the extra damage of the critical hit.'),
(7, 1, 'Ability Score Increase', 'Your Intelligence score increases by 2.'),
(7, 1, 'Size', 'Small'),
(7, 1, 'Speed', 'Your base walking speed is 25 feet.'),
(7, 1, 'Darkvision', 'You can see in dim light within 60 feet of you as if it were bright light, and in darkness as if it were dim light.'),
(7, 1, 'Gnome Cunning', 'You have advantage on all Intelligence, Wisdom, and Charisma saving throws against magic.'),
(7, 1, 'Artificers Lore', 'Whenever you make an Intelligence (History) check related to magic items, alchemical objects, or technological devices, you can add twice your proficiency bonus, instead of any proficiency bonus you normally apply.'),
(7, 1, 'Tinker', 'You have proficiency with artisan’s tools (tinker’s tools). Using those tools, you can spend 1 hour and 10 gp worth of materials to construct a Tiny clockwork device (AC 5, 1 hp). The device ceases to function after 24 hours (unless you spend 1 hour repairing it to keep the device functioning), or when you use your action to dismantle it; at that time, you can reclaim the materials used to create it. You can have up to three such devices active at a time.'),
(8, 1, 'Ability Score Increase', 'Your Intelligence score increases by 1, and your Charisma score increases by 2.'),
(8, 1, 'Size', 'Medium'),
(8, 1, 'Speed', 'Your base walking speed is 30 feet.'),
(8, 1, 'Darkvision', 'You can see in dim light within 60 feet of you as if it were bright light, and in darkness as if it were dim light.'),
(8, 1, 'Hellish Resistance', 'You have resistance to fire damage.'),
(8, 1, 'Infernal Legacy', 'You know the thaumaturgy cantrip. Once you reach 3rd level, you can cast the hellish rebuke spell once per day as a 2nd-level spell. Once you reach 5th level, you can also cast the darkness spell once per day. Charisma is your spellcasting ability for these spells.'),
(10, 1, 'Ability Score Increase', 'Your Charisma score increases by 2, and your Wisdom score increases by 1.'),
(10, 1, 'Size', 'Medium'),
(10, 1, 'Speed', 'Your base walking speed is 30 feet.'),
(10, 1, 'Darkvision', 'You can see in dim light within 60 feet of you as if it were bright light, and in darkness as if it were dim light.'),
(10, 1, 'Celestial Resistance', 'You have resistance to necrotic damage and radiant damage.'),
(10, 1, 'Healing Hands', 'As an action, you can touch a creature and cause it to regain a number of hit points equal to your level. Once you use this trait, you can’t use it again until you finish a long rest.'),
(10, 1, 'Light Bearer', 'You know the light cantrip. Charisma is your spellcasting ability for it.');



INSERT INTO subracial_traits (subrace_id, subracial_trait_level, subracial_trait_description, subracial_traits_name)
VALUES
(1, 1, 'Ability Score Increase: Your Wisdom score increases by 1.', 'Fleet of Foot'),
(1, 1, 'Fleet of Foot: Your base walking speed increases to 35 feet.', 'Fleet of Foot'),
(1, 1, 'Mask of the Wild: You can attempt to hide even when you are only lightly obscured by foliage, heavy rain, falling snow, mist, and other natural phenomena.', 'Mask of the Wild'),
(2, 1, 'Ability Score Increase: Your Intelligence score increases by 1.', 'Elf Weapon Training'),
(2, 1, 'Elf Weapon Training: You have proficiency with the longsword, shortsword, shortbow, and longbow.', 'Elf Weapon Training'),
(2, 1, 'Cantrip: You know one cantrip of your choice from the wizard spell list. Intelligence is your spellcasting ability for it.', 'Cantrip'),
(3, 1, 'Ability Score Increase: Your Charisma score increases by 1.', 'Superior Darkvision'),
(3, 1, 'Superior Darkvision: Your darkvision has a radius of 120 feet.', 'Superior Darkvision'),
(3, 1, 'Sunlight Sensitivity: You have disadvantage on attack rolls and on Wisdom (Perception) checks that rely on sight when you, the target of your attack, or whatever you are trying to perceive is in direct sunlight.', 'Sunlight Sensitivity'),
(3, 1, 'Drow Magic: You know the dancing lights cantrip. When you reach 3rd level, you can cast the faerie fire spell once per day. When you reach 5th level, you can also cast the darkness spell once per day. Charisma is your spellcasting ability for these spells.', 'Drow Magic'),
(4, 1, 'Ability Score Increase: Your Strength score increases by 2.', 'Dwarven Armor Training'),
(4, 1, 'Dwarven Armor Training: You have proficiency with light and medium armor.', 'Dwarven Armor Training'),
(5, 1, 'Ability Score Increase: Your Wisdom score increases by 1.', 'Dwarven Toughness'),
(5, 1, 'Dwarven Toughness: Your hit point maximum increases by 1, and it increases by 1 every time you gain a level.', 'Dwarven Toughness'),
(6, 1, 'Ability Score Increase: Your Charisma score increases by 1.', 'Naturally Stealthy'),
(6, 1, 'Naturally Stealthy: You can attempt to hide even when you are obscured only by a creature that is at least one size larger than you.', 'Naturally Stealthy'),
(7, 1, 'Ability Score Increase: Your Constitution score increases by 1.', 'Stout Resilience'),
(7, 1, 'Stout Resilience: You have advantage on saving throws against poison, and you have resistance against poison damage.', 'Stout Resilience'),
(8, 1, 'Ability Score Increase: Your Dexterity score increases by 1.', 'Natural Illusionist'),
(8, 1, 'Natural Illusionist: You know the minor illusion cantrip. Intelligence is your spellcasting ability for it.', 'Natural Illusionist'),
(8, 1, 'Speak with Small Beasts: Through sounds and gestures, you can communicate simple ideas with Small or smaller beasts.', 'Speak with Small Beasts'),
(9, 1, 'Ability Score Increase: Your Constitution score increases by 1.', 'Artificers Lore'),
(9, 1, 'Artificers Lore: Whenever you make an Intelligence (History) check related to magic items, alchemical objects, or technological devices, you can add twice your proficiency bonus, instead of any proficiency bonus you normally apply.', 'Artificers Lore'),
(9, 1, 'Tinker: You have proficiency with artisans tools (tinkers tools). Using those tools, you can spend 1 hour and 10 gp worth of materials to construct a Tiny clockwork device (AC 5, 1 hp).', 'Tinker');




       INSERT INTO class_features (class_id, level, class_feature_name, class_feature_description)
VALUES
(1, 1, 'Rage', 'Na 1ª nível, você pode entrar em um estado de fúria como uma ação bônus.'),
(1, 1, 'Unarmored Defense', 'Começando no 1º nível, enquanto você não estiver usando nenhuma armadura e não estiver segurando um escudo, sua CA é igual a 10 + seu modificador de Destreza + seu modificador de Constituição.'),
(1, 1, 'Reckless Attack', 'Começando no 2º nível, você pode lançar ataques com selvageria e abandonar qualquer defesa para fazê-lo.'),
(1, 2, 'Danger Sense', 'A partir do 2º nível, você tem uma intuição inata que lhe dá uma vantagem nos testes de habilidade para evitar perigos.'),
(1, 2, 'Reckless Attack Improvement', 'Começando no 2º nível, você pode lançar ataques com selvageria e abandonar qualquer defesa para fazê-lo.'),
(1, 3, 'Primal Path', 'No 3º nível, você escolhe um caminho primal que molda os instintos de sua fúria: o Caminho do Berserker ou o Caminho do Totem Guerreiro.'),
(1, 4, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(1, 5, 'Extra Attack', 'Começando no 5º nível, você pode atacar duas vezes, em vez de uma, sempre que tomar a ação de Ataque no seu turno.'),
(1, 5, 'Fast Movement', 'Começando no 5º nível, seu deslocamento aumenta em 10 pés enquanto você não estiver vestindo uma armadura pesada.'),
(1, 6, 'Path Feature', 'No 6º nível, você ganha uma habilidade especial baseada no caminho primal que você escolheu: Fúria Frenética (Caminho do Berserker) ou Espírito Totêmico (Caminho do Totem Guerreiro).'),
(1, 7, 'Feral Instinct', 'A partir do 7º nível, sua fúria é tão selvagem que você tem vantagem em iniciativas enquanto não estiver surpreso.'),
(1, 9, 'Brutal Critical', 'Começando no 9º nível, você pode rolar um dado adicional de dano ao acertar um ataque com arma.'),
(1, 11, 'Relentless Rage', 'Começando no 11º nível, sua fúria continua apesar dos golpes que você sofre.'),
(1, 13, 'Brutal Critical Improvement', 'Começando no 13º nível, você pode rolar dois dados adicionais de dano ao acertar um ataque com arma.'),
(1, 15, 'Persistent Rage', 'Começando no 15º nível, sua fúria é tão fervorosa que não pode ser desfeita prematuramente.'),
(1, 17, 'Brutal Critical Improvement', 'Começando no 17º nível, você pode rolar três dados adicionais de dano ao acertar um ataque com arma.'),
(1, 18, 'Indomitable Might', 'Começando no 18º nível, se o total que você rolar em um teste de Força for inferior ao seu total de Força, você pode usar este total em vez do outro.'),
(1, 20, 'Primal Champion', 'No 20º nível, você é uma força de natureza quando entra em sua fúria. Seus pontos de vida aumentam em 4x seu modificador de Constituição, e você tem vantagem em todos os testes de Força e Constituição.');

INSERT INTO class_features (class_id, level, class_feature_name, class_feature_description)
VALUES
(2, 1, 'Bardic Inspiration', 'No 1º nível, você pode inspirar os outros através de palavras ou música.'),
(2, 1, 'Spellcasting', 'A partir do 1º nível, você pode conjurar magias do bardo.'),
(2, 1, 'Bard College', 'No 3º nível, você escolhe um colégio para se juntar: Colégio da Canção, Colégio do Valor ou Colégio do Saber.'),
(2, 1, 'Jack of All Trades', 'Começando no 2º nível, você pode adicionar metade do seu bônus de proficiência, arredondado para baixo, em qualquer teste de habilidade que você não seja proficiente.'),
(2, 2, 'Song of Rest', 'A partir do 2º nível, você pode usar músicas ou palavras de consolo para ajudar a revitalizar seus aliados durante um descanso curto.'),
(2, 3, 'Expertise', 'No 3º nível, escolha duas habilidades em que você é proficiente. Seu bônus de proficiência é dobrado para qualquer teste de habilidade que você fizer com essas habilidades.'),
(2, 4, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(2, 5, 'Font of Inspiration', 'Começando no 5º nível, sua habilidade de inspiração recupera após um descanso curto ou longo.'),
(2, 6, 'Countercharm', 'No 6º nível, você adquire a habilidade de usar música ou palavras mágicas para impedir ou interromper efeitos de charme e medo.'),
(2, 7, 'Magical Secrets', 'A partir do 10º nível, você pode aprender magias de qualquer classe.'),
(2, 8, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(2, 9, 'Song of Rest Improvement', 'A partir do 9º nível, as músicas que você executa durante um descanso curto restauram pontos de vida adicionais para aqueles que ouvem.'),
(2, 10, 'Expertise Improvement', 'No 10º nível, você pode escolher mais duas habilidades para ganhar Expertise.'),
(2, 13, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(2, 14, 'Magical Secrets Improvement', 'A partir do 14º nível, você pode aprender duas magias adicionais de qualquer classe.'),
(2, 15, 'Inspiration Mastery', 'Começando no 15º nível, você pode usar sua habilidade de inspiração mais vezes entre os descansos.'),
(2, 16, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(2, 18, 'Magical Secrets Improvement', 'A partir do 18º nível, você pode aprender duas magias adicionais de qualquer classe.'),
(2, 19, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(2, 20, 'Superior Inspiration', 'No 20º nível, sua habilidade de inspiração se torna ainda mais eficaz.');

INSERT INTO class_features (class_id, level, class_feature_name, class_feature_description)
VALUES
(3, 1, 'Spellcasting', 'A partir do 1º nível, você aprendeu a conjurar magias.'),
(3, 1, 'Divine Domain', 'No 1º nível, você escolhe uma área de especialização divina que molda sua prática clericar: Conhecimento, Vida, Luz, Natureza, Guerra, ou Morte.'),
(3, 2, 'Channel Divinity', 'A partir do 2º nível, você pode usar sua conexão divina para canalizar poderes divinos.'),
(3, 2, 'Channel Divinity Improvement', 'A partir do 2º nível, você pode usar sua conexão divina para canalizar poderes divinos.'),
(3, 3, 'Divine Domain Feature', 'No 3º nível, você ganha um recurso especial baseado na sua área de especialização divina.'),
(3, 4, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(3, 5, 'Destroy Undead', 'Começando no 5º nível, quando um undead com CD de desafio 1/2 ou inferior falhar em seu teste de resistência contra sua Turn Undead, o undead é destruído.'),
(3, 5, 'Divine Domain Feature', 'No 5º nível, você ganha um recurso especial baseado na sua área de especialização divina.'),
(3, 6, 'Channel Divinity Improvement', 'A partir do 6º nível, você pode usar sua conexão divina para canalizar poderes divinos com mais frequência.'),
(3, 7, 'Divine Domain Feature', 'No 7º nível, você ganha um recurso especial baseado na sua área de especialização divina.'),
(3, 9, 'Divine Intervention', 'Começando no 9º nível, você pode chamar a intervenção direta do seu deus quando você realmente precisa.'),
(3, 10, 'Divine Domain Feature', 'No 10º nível, você ganha um recurso especial baseado na sua área de especialização divina.'),
(3, 11, 'Destroy Undead Improvement', 'Começando no 11º nível, undeads com CD de desafio 1 ou inferior falham automaticamente no teste de resistência contra sua Turn Undead e são destruídos se você os afastar.'),
(3, 14, 'Divine Domain Feature', 'No 14º nível, você ganha um recurso especial baseado na sua área de especialização divina.'),
(3, 17, 'Divine Domain Feature', 'No 17º nível, você ganha um recurso especial baseado na sua área de especialização divina.'),
(3, 18, 'Channel Divinity Improvement', 'A partir do 18º nível, você pode usar sua conexão divina para canalizar poderes divinos com ainda mais frequência.'),
(3, 20, 'Divine Intervention Improvement', 'No 20º nível, sua chance de chamar a intervenção do seu deus é aumentada e a intervenção divina é mais eficaz.');



INSERT INTO class_features (class_id, level, class_feature_name, class_feature_description)
VALUES
(4, 1, 'Druidic', 'A partir do 1º nível, você pode falar a língua druídica.'),
(4, 1, 'Spellcasting', 'A partir do 1º nível, você aprendeu a conjurar magias.'),
(4, 2, 'Wild Shape', 'Começando no 2º nível, você pode usar suas ações para se transformar em uma besta que você tenha visto antes.'),
(4, 2, 'Druid Circle', 'No 2º nível, você escolhe um círculo druídico que guia sua compreensão da natureza: Círculo da Terra, Círculo da Lua.'),
(4, 3, 'Druid Circle Feature', 'No 3º nível, você ganha um recurso especial baseado no seu círculo druídico.'),
(4, 4, 'Wild Shape Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º e 16º níveis, você pode transformar-se em uma besta com um nível de desafio maior.'),
(4, 5, 'Druid Circle Feature', 'No 5º nível, você ganha um recurso especial baseado no seu círculo druídico.'),
(4, 6, 'Druid Circle Feature', 'No 6º nível, você ganha um recurso especial baseado no seu círculo druídico.'),
(4, 7, 'Druid Circle Feature', 'No 7º nível, você ganha um recurso especial baseado no seu círculo druídico.'),
(4, 8, 'Wild Shape Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º e 16º níveis, você pode transformar-se em uma besta com um nível de desafio maior.'),
(4, 9, 'Druid Circle Feature', 'No 9º nível, você ganha um recurso especial baseado no seu círculo druídico.'),
(4, 10, 'Druid Circle Feature', 'No 10º nível, você ganha um recurso especial baseado no seu círculo druídico.'),
(4, 11, 'Druid Circle Feature', 'No 11º nível, você ganha um recurso especial baseado no seu círculo druídico.'),
(4, 12, 'Druid Circle Feature', 'No 12º nível, você ganha um recurso especial baseado no seu círculo druídico.'),
(4, 14, 'Druid Circle Feature', 'No 14º nível, você ganha um recurso especial baseado no seu círculo druídico.'),
(4, 18, 'Timeless Body', 'Começando no 18º nível, o envelhecimento não pode mais afetá-lo.'),
(4, 18, 'Beast Spells', 'No 18º nível, você pode conjurar muitas de suas magias de druida na forma selvagem.'),
(4, 20, 'Archdruid', 'No 20º nível, você pode usar suas habilidades druídicas com liberdade ainda maior.');

INSERT INTO class_features (class_id, level, class_feature_name, class_feature_description)
VALUES
(5, 1, 'Fighting Style', 'No 1º nível, você adota um estilo de combate que será seu foco.'),
(5, 1, 'Second Wind', 'No 1º nível, você tem uma reserva de energia que lhe permite se curar.'),
(5, 2, 'Action Surge', 'Começando no 2º nível, você pode empurrar-se além dos limites normais para realizar uma ação adicional em seu turno.'),
(5, 3, 'Martial Archetype', 'No 3º nível, você escolhe uma especialização marcial que define seu estilo de combate: Campeão, Mestre das Armas, ou Cavaleiro.'),
(5, 4, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 6º, 8º, 12º, 14º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(5, 5, 'Extra Attack', 'Começando no 5º nível, você pode atacar duas vezes, em vez de uma, sempre que tomar a ação de Ataque no seu turno.'),
(5, 5, 'Second Wind Improvement', 'Começando no 5º nível, você recupera pontos de vida adicionais quando usa Second Wind.'),
(5, 6, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 6º, 8º, 12º, 14º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(5, 7, 'Extra Attack Improvement', 'Começando no 7º nível, você pode atacar três vezes, em vez de duas, sempre que tomar a ação de Ataque no seu turno.'),
(5, 9, 'Indomitable', 'Começando no 9º nível, você pode refazer um teste de resistência que falhou.'),
(5, 11, 'Extra Attack Improvement', 'Começando no 11º nível, você pode atacar quatro vezes, em vez de três, sempre que tomar a ação de Ataque no seu turno.'),
(5, 13, 'Indomitable Improvement', 'Começando no 13º nível, você pode refazer um teste de resistência adicional.'),
(5, 15, 'Extra Attack Improvement', 'Começando no 15º nível, você pode atacar cinco vezes, em vez de quatro, sempre que tomar a ação de Ataque no seu turno.'),
(5, 17, 'Action Surge Improvement', 'Começando no 17º nível, você pode usar o Action Surge duas vezes antes de precisar de um descanso.'),
(5, 18, 'Indomitable Improvement', 'Começando no 17º nível, você pode refazer um teste de resistência adicional.'),
(5, 20, 'Extra Attack Improvement', 'Começando no 20º nível, você pode atacar seis vezes, em vez de cinco, sempre que tomar a ação de Ataque no seu turno.');

INSERT INTO class_features (class_id, level, class_feature_name, class_feature_description)
VALUES
(6, 1, 'Unarmored Defense', 'No 1º nível, enquanto você não estiver usando armadura ou escudo, a sua CA equivale a 10 + seu modificador de Destreza + seu modificador de Sabedoria.'),
(6, 1, 'Martial Arts', 'No 1º nível, suas habilidades marciais crescentes permitem que você use armas marciais e desarmadas com mais eficiência.'),
(6, 2, 'Ki', 'A partir do 2º nível, você pode usar energia interna, chamada de ki, para realizar proezas sobrenaturais.'),
(6, 2, 'Unarmored Movement', 'Começando no 2º nível, seu treinamento marcial lhe concede velocidade sobrenatural.'),
(6, 3, 'Monastic Tradition', 'No 3º nível, você escolhe uma tradição monástica que orienta suas práticas de combate e suas habilidades sobrenaturais: Viajante das Sombras, Punho Aberto, ou Monge Elemental.'),
(6, 4, 'Slow Fall', 'Começando no 4º nível, você pode usar sua reação para reduzir o dano de uma queda.'),
(6, 4, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(6, 5, 'Extra Attack', 'Começando no 5º nível, você pode atacar duas vezes, em vez de uma, sempre que tomar a ação de Ataque no seu turno.'),
(6, 5, 'Stunning Strike', 'Começando no 5º nível, você pode tentar atordoar uma criatura atingida com um ataque de monge.'),
(6, 6, 'Ki-Empowered Strikes', 'A partir do 6º nível, seus ataques desarmados contam como mágicos para superar a resistência e imunidade a danos não mágicos.'),
(6, 7, 'Evasion', 'A partir do 7º nível, você pode evitar danos de muitas áreas de efeito.'),
(6, 7, 'Stillness of Mind', 'A partir do 7º nível, você pode usar sua ação para encerrar um efeito de encantamento ou medo em você.'),
(6, 8, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(6, 9, 'Unarmored Movement Improvement', 'Começando no 9º nível, seu treinamento marcial lhe concede maior velocidade sobrenatural.'),
(6, 10, 'Purity of Body', 'A partir do 10º nível, você é imune a doenças e venenos.'),
(6, 11, 'Tranquility', 'Começando no 11º nível, você pode canalizar a paz ao seu redor, agindo como um farol de calma.'),
(6, 13, 'Tongue of the Sun and Moon', 'Começando no 13º nível, você pode entender e falar todas as línguas.'),
(6, 14, 'Diamond Soul', 'A partir do 14º nível, sua mente e corpo tornam-se resistentes a efeitos mágicos.'),
(6, 15, 'Timeless Body', 'Começando no 15º nível, seu envelhecimento é retardado drasticamente.'),
(6, 18, 'Empty Body', 'A partir do 18º nível, você pode usar sua ação para se tornar invisível, além de outras habilidades.'),
(6, 18, 'Perfect Self', 'No 20º nível, sua alma está completamente integrada com seu corpo, tornando-se um monge perfeito.');

INSERT INTO class_features (class_id, level, class_feature_name, class_feature_description)
VALUES
(7, 1, 'Divine Sense', 'No 1º nível, você pode detectar a presença de energia divina.'),
(7, 1, 'Lay on Hands', 'No 1º nível, você tem uma reserva de cura que você pode usar para curar ferimentos.'),
(7, 2, 'Divine Smite', 'A partir do 2º nível, quando você acerta uma criatura com um ataque corpo-a-corpo, você pode canalizar energia divina para causar dano extra.'),
(7, 3, 'Divine Health', 'No 3º nível, a pureza da sua conexão divina o torna imune a doenças.'),
(7, 4, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(7, 5, 'Extra Attack', 'Começando no 5º nível, você pode atacar duas vezes, em vez de uma, sempre que tomar a ação de Ataque no seu turno.'),
(7, 5, 'Aura of Protection', 'Começando no 6º nível, você e aliados amigáveis dentro de 10 pés de você ganham bônus nos testes de resistência.'),
(7, 6, 'Aura of Protection Improvement', 'Começando no 6º nível, o alcance da sua Aura de Proteção aumenta para 30 pés.'),
(7, 9, 'Aura of Courage', 'Começando no 10º nível, você e aliados amigáveis dentro de 10 pés de você não podem ser amedrontados enquanto você estiver consciente.'),
(7, 10, 'Aura of Courage Improvement', 'Começando no 10º nível, o alcance da sua Aura de Coragem aumenta para 30 pés.'),
(7, 11, 'Improved Divine Smite', 'Começando no 11º nível, seu Divine Smite causa dano extra.'),
(7, 13, 'Cleansing Touch', 'Começando no 14º nível, você pode usar suas ações para neutralizar efeitos mágicos em você ou em outra pessoa.'),
(7, 17, 'Aura of Protection Improvement', 'Começando no 18º nível, o alcance da sua Aura de Proteção aumenta para 30 pés.'),
(7, 18, 'Aura of Courage Improvement', 'Começando no 18º nível, o alcance da sua Aura de Coragem aumenta para 30 pés.'),
(7, 20, 'Sacred Oath Feature Improvement', 'No 20º nível, seu juramento divino ganha um poder adicional.');



INSERT INTO class_features (class_id, level, class_feature_name, class_feature_description)
VALUES
(8, 1, 'Favored Enemy', 'No 1º nível, você tem conhecimento do idioma e das táticas usadas pelos seus inimigos.'),
(8, 1, 'Natural Explorer', 'No 1º nível, você é um mestre em navegar pelas regiões selvagens.'),
(8, 2, 'Fighting Style', 'No 2º nível, você adota um estilo de combate que será seu foco.'),
(8, 3, 'Ranger Archetype', 'No 3º nível, você escolhe um arquétipo ranger que molda suas habilidades de caça e exploração: Caçador, Besta, ou Guardião.'),
(8, 4, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º e 16º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(8, 5, 'Extra Attack', 'Começando no 5º nível, você pode atacar duas vezes, em vez de uma, sempre que tomar a ação de Ataque no seu turno.'),
(8, 7, 'Ranger Archetype Feature Improvement', 'Começando no 7º nível, seu arquétipo ranger ganha poder adicional.'),
(8, 8, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º e 16º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(8, 9, 'Evasion', 'A partir do 9º nível, você pode evitar danos de muitas áreas de efeito.'),
(8, 11, 'Ranger Archetype Feature Improvement', 'Começando no 11º nível, seu arquétipo ranger ganha poder adicional.'),
(8, 12, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º e 16º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(8, 15, 'Ranger Archetype Feature Improvement', 'Começando no 15º nível, seu arquétipo ranger ganha poder adicional.'),
(8, 16, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º e 16º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(8, 18, 'Feral Senses', 'A partir do 18º nível, você está ciente da localização de qualquer criatura oculta ou invisível dentro do alcance de seu sentido aguçado.'),
(8, 20, 'Foe Slayer', 'No 20º nível, você é um caçador consumado, suas habilidades de rastreamento e caça atingiram o ápice.');


INSERT INTO class_features (class_id, level, class_feature_name, class_feature_description)
VALUES
(9, 1, 'Expertise', 'No 1º nível, suas proficiências em determinadas habilidades refletem a sua especialização.'),
(9, 1, 'Sneak Attack', 'No 1º nível, você sabe como atacar de forma eficaz quando tem vantagem em um ataque.'),
(9, 2, 'Cunning Action', 'A partir do 2º nível, você pode usar uma ação bônus para realizar certas tarefas.'),
(9, 3, 'Roguish Archetype', 'No 3º nível, você escolhe um arquétipo de ladrão que reflete suas habilidades e técnicas: Assaltante, Atirador, ou Arcanista Ardiloso.'),
(9, 4, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 10º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(9, 5, 'Uncanny Dodge', 'Começando no 5º nível, quando uma criatura que você pode ver ataca você com um ataque corpo-a-corpo, você pode usar sua reação para reduzir o dano do ataque pela metade.'),
(9, 7, 'Evasion', 'Começando no 7º nível, você pode evitar danos de muitas áreas de efeito.'),
(9, 8, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 10º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(9, 9, 'Roguish Archetype Feature Improvement', 'Começando no 9º nível, seu arquétipo de ladrão ganha poder adicional.'),
(9, 11, 'Reliable Talent', 'A partir do 11º nível, qualquer rolagem de dado que você fizer com a qual você adiciona seu bônus de proficiência é considerada um rolagem de 10.'),
(9, 12, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 10º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(9, 13, 'Roguish Archetype Feature Improvement', 'Começando no 13º nível, seu arquétipo de ladrão ganha poder adicional.'),
(9, 14, 'Blindsense', 'A partir do 14º nível, se você estiver apto a ouvir, você é consciente da localização de qualquer criatura oculta ou invisível dentro do alcance de seu ouvido aguçado.'),
(9, 15, 'Slippery Mind', 'Começando no 15º nível, você tem resistência à magias que tentam confundir sua mente.'),
(9, 16, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 10º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(9, 17, 'Roguish Archetype Feature Improvement', 'Começando no 17º nível, seu arquétipo de ladrão ganha poder adicional.'),
(9, 18, 'Elusive', 'A partir do 18º nível, ninguém pode te atingir eficazmente enquanto você não quiser ser atingido.'),
(9, 19, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 10º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(9, 20, 'Stroke of Luck', 'No 20º nível, você tem um suprimento infinito de sorte que ressurge a cada longo descanso.');


INSERT INTO class_features (class_id, level, class_feature_name, class_feature_description)
VALUES
(10, 1, 'Spellcasting', 'No 1º nível, você possui uma reserva de energia mágica que permite que você conjure feitiços.'),
(10, 1, 'Sorcerous Origin', 'Também no 1º nível, você escolhe a origem da sua magia: Draconic Bloodline ou Wild Magic.'),
(10, 2, 'Font of Magic', 'A partir do 2º nível, você tem uma fonte de energia mágica inata.'),
(10, 3, 'Metamagic', 'No 3º nível, você ganha a habilidade de manipular sua magia.'),
(10, 4, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(10, 5, 'Sorcery Points Improvement', 'Começando no 5º nível, seus pontos de feitiço se expandem.'),
(10, 6, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(10, 7, 'Sorcerous Origin Feature Improvement', 'Começando no 6º nível, o poder da sua origem de feitiço cresce.'),
(10, 9, 'Sorcerous Origin Feature Improvement', 'Começando no 14º nível, o poder da sua origem de feitiço cresce.'),
(10, 10, 'Metamagic Improvement', 'Começando no 10º nível, você pode usar Metamagic com mais eficiência.'),
(10, 12, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(10, 13, 'Sorcerous Origin Feature Improvement', 'Começando no 18º nível, o poder da sua origem de feitiço cresce.'),
(10, 15, 'Sorcerous Restoration', 'A partir do 20º nível, você pode recuperar alguns dos seus pontos de feitiço gastos quando você termina um descanso curto.'),
(10, 16, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.');


INSERT INTO class_features (class_id, level, class_feature_name, class_feature_description)
VALUES
(11, 1, 'Otherworldly Patron', 'No 1º nível, você faz um pacto com uma entidade poderosa que concede a você habilidades mágicas.'),
(11, 1, 'Pact Magic', 'Também no 1º nível, você adquire a habilidade de lançar feitiços de forma única.'),
(11, 2, 'Eldritch Invocations', 'Começando no 2º nível, você adquire invocações sobrenaturais que aprimoram seus feitiços e sua magia.'),
(11, 3, 'Pact Boon', 'No 3º nível, seu pacto com seu patrono concede a você uma forma de pacto.'),
(11, 4, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(11, 5, 'Mystic Arcanum', 'A partir do 11º nível, seu patrono concede a você um misterioso arcano uma vez por dia.'),
(11, 6, 'Eldritch Invocations Improvement', 'Começando no 12º nível, suas invocações eldritch se expandem.'),
(11, 7, 'Pact Boon Improvement', 'Começando no 15º nível, o poder de seu pacto boon aumenta.'),
(11, 8, 'Ability Score Improvement', 'Quando você alcança o 8º nível, e novamente no 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(11, 9, 'Mystic Arcanum Improvement', 'A partir do 13º nível, você ganha mais usos diários de Mystic Arcanum.'),
(11, 10, 'Eldritch Master', 'A partir do 20º nível, você pode recuperar slots de feitiço gastos em um descanso curto.');


INSERT INTO class_features (class_id, level, class_feature_name, class_feature_description)
VALUES
(12, 1, 'Spellcasting', 'No 1º nível, você possui um livro de magias que contém feitiços que você aprendeu e que podem ser preparados.'),
(12, 1, 'Arcane Recovery', 'Também no 1º nível, você tem a habilidade de recuperar parte de sua energia mágica durante um breve descanso.'),
(12, 2, 'Arcane Tradition', 'No 2º nível, você escolhe uma tradição arcana que molda suas práticas mágicas: Abjuration, Conjuration, Divination, Enchantment, Evocation, Illusion, Necromancy, ou Transmutation.'),
(12, 3, 'Arcane Tradition Feature', 'A partir do 2º nível, você adquire características especiais baseadas na tradição arcana que você escolheu.'),
(12, 4, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(12, 5, 'Arcane Tradition Feature Improvement', 'Começando no 6º nível, o poder de sua tradição arcana aumenta.'),
(12, 6, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(12, 7, 'Arcane Tradition Feature Improvement', 'Começando no 10º nível, o poder de sua tradição arcana aumenta.'),
(12, 9, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.'),
(12, 10, 'Arcane Tradition Feature Improvement', 'Começando no 14º nível, o poder de sua tradição arcana aumenta.'),
(12, 11, 'Spell Mastery', 'A partir do 18º nível, você pode dominar feitiços suficientemente para lançá-los à vontade.'),
(12, 12, 'Ability Score Improvement', 'Quando você alcança o 4º nível, e novamente no 8º, 12º, 16º e 19º níveis, você pode aumentar um atributo em 2 pontos ou dois atributos em 1 ponto.');



INSERT INTO features (feature_name, feature_description) VALUES
('Actor', 'Você ganha os seguintes benefícios: Aumente seu carisma em 1, para um máximo de 20. Você tem vantagem em testes de Carisma (Enganação) e Carisma (Atuação) quando tenta passar por outra pessoa.'),
('Alert', 'Você ganha os seguintes benefícios: Você não pode ser surpreendido enquanto estiver consciente. Outros personagens não ganham vantagem em testes de ataque contra você como resultado de estarem escondidos de você.'),
('Athlete', 'Você ganha os seguintes benefícios: Aumente sua Força ou Destreza em 1, para um máximo de 20. Quando você estiver a pelo menos 9 metros de distância de uma criatura hostil, você pode usar metade de sua movimentação para ficar de pé.'),
('Charger', 'Você ganha os seguintes benefícios: Quando você usa a ação de Correr e acerta com um ataque de corpo-a-corpo, você pode usar uma ação bônus para tentar empurrar a criatura com sucesso. A criatura deve ser grande ou menor e não pode estar empurrando.'),
('Crossbow Expert', 'Você ganha os seguintes benefícios: Quando você usa a ação de Ataque e ataca com uma besta leve que você está segurando, você pode usar uma ação bônus para atacar com a mão livre.'),
('Defensive Duelist', 'Você ganha os seguintes benefícios: Aumente sua Destreza em 1, para um máximo de 20. Quando você é atacado por uma arma com a qual você é proficient, você pode usar sua reação para adicionar seu bônus de proficiência ao seu resultado de CA para essa jogada.'),
('Dual Wielder', 'Você ganha os seguintes benefícios: Aumente seu valor de Destreza ou Força em 1, até um máximo de 20. Você pode usar duas armas de corpo-a-corpo leves ao lutar.'),
('Dungeon Delver', 'Você ganha os seguintes benefícios: Você tem vantagem em testes de resistência para evitar ou resistir a armadilhas e em testes de resistência contra efeitos que você não pode ver.'),
('Durable', 'Você ganha os seguintes benefícios: Quando você rolar um Dado de Vida para recuperar pontos de vida, o mínimo que você pode rolar é igual ao dobro do seu modificador de Constituição.'),
('Elemental Adept', 'Você ganha os seguintes benefícios: Escolha um tipo de dano: ácido, frio, fogo, trovão ou relâmpago. Feitiços que você lança ignoram a resistência à dano desse tipo.'),
('Grappler', 'Você ganha os seguintes benefícios: Aumente sua Força em 1, para um máximo de 20. Você tem vantagem em ataques com armas improvisadas usadas para agarrar.'),
('Great Weapon Master', 'Você ganha os seguintes benefícios: Em seu turno, quando você acerta uma criatura com um ataque corpo-a-corpo com arma de combate pesado ou uma arma de duas mãos versátil, você pode escolher desistir de sua jogada de bônus para ganhar +10 de dano.'),
('Healer', 'Você ganha os seguintes benefícios: Quando você usa um kit de cura para estabilizar uma criatura, essa criatura também recupera 1 ponto de vida. Como uma ação, você pode usar um kit de cura para curar pontos de vida igual a 1d6 + 4 + o número de Dados de Vida do alvo (mínimo de 1).'),
('Heavily Armored', 'Você ganha os seguintes benefícios: Aumente sua Força em 1, para um máximo de 20. Você ganha proficiência com armadura pesada.'),
('Heavy Armor Master', 'Você ganha os seguintes benefícios: Aumente sua Força em 1, para um máximo de 20. Quando você está usando armadura pesada, você ganha resistência a dano não mágico que é do mesmo tipo que a arma que você usou para fazer o ataque (cortante, perfurante ou esmagamento).'),
('Inspiring Leader', 'Você ganha os seguintes benefícios: Aumente seu carisma em 1, para um máximo de 20. Como uma ação de 10 minutos que pode ser feita durante um descanso curto ou longo, você pode inspirar até seis criaturas que você possa ver ou ouvir você.'),
('Keen Mind', 'Você ganha os seguintes benefícios: Aumente seu valor de inteligência em 1, até um máximo de 20. Você sempre pode precisar da direção norte, e você sempre sabe quanto tempo é até o próximo nascer ou pôr do sol.'),
('Lightly Armored', 'Você ganha os seguintes benefícios: Aumente sua Destreza em 1, para um máximo de 20. Você ganha proficiência com armadura leve.'),
('Linguist', 'Você ganha os seguintes benefícios: Aumente seu valor de inteligência em 1, até um máximo de 20. Você aprende três línguas de sua escolha.'),
('Lucky', 'Você ganha os seguintes benefícios: Você tem três pontos de sorte. Sempre que você fizer uma jogada de ataque, teste de habilidade ou teste de resistência, você pode gastar um ponto de sorte para rolar um adicional d20.'),
('Mage Slayer', 'Você ganha os seguintes benefícios: Quando uma criatura dentro de 1,5 metros de você lança um feitiço, você pode usar sua reação para fazer um ataque corpo-a-corpo com arma contra essa criatura.'),
('Magic Initiate', 'Escolha uma classe: bard, cleric, druid, sorcerer, warlock ou wizard. Você aprende duas magias dessa classe.'),
('Martial Adept', 'Você ganha os seguintes benefícios: Aumente sua Força ou Destreza em 1, para um máximo de 20. Você aprende duas manobras de sua escolha do estilo de luta de batalha.'),
('Medium Armor Master', 'Você ganha os seguintes benefícios: Aumente sua Destreza em 1, para um máximo de 20. Você pode usar sua destreza modificada em vez de sua força modificada para testes de atletismo e testes de força para se mover.'),
('Mobile', 'Você ganha os seguintes benefícios: Seu deslocamento aumenta em 1,5 metros. Quando você usa a ação de Disparada, os ataques de oportunidade contra você são feitos com desvantagem e seu deslocamento não provoca ataques de oportunidade pelo resto do turno.'),
('Moderately Armored', 'Você ganha os seguintes benefícios: Aumente sua Força ou Destreza em 1, para um máximo de 20. Você ganha proficiência com armadura média.'),
('Mounted Combatant', 'Você ganha os seguintes benefícios: Aumente sua Força ou Destreza em 1, para um máximo de 20. Você tem vantagem em testes de resistência de Força e Destreza enquanto você estiver montado em uma criatura.'),
('Observant', 'Você ganha os seguintes benefícios: Aumente sua inteligência ou Sabedoria em 1, para um máximo de 20. Você pode ler lábios.'),
('Polearm Master', 'Você ganha os seguintes benefícios: Ao fazer uma jogada de ataque com uma arma de ataque de alcance, você pode usar uma ação bônus para tentar empurrar a criatura.'),
('Resilient', 'Escolha uma habilidade: Constituição, Inteligência ou Sabedoria. Você ganha proficiência em testes de resistência usando a habilidade escolhida.'),
('Ritual Caster', 'Escolha uma classe: bard, cleric, druid, sorcerer, warlock ou wizard. Você aprende dois rituais dessa classe.'),
('Savage Attacker', 'Quando você rolar dano para um ataque que você faz com uma arma corpo-a-corpo, você pode re-rolar o dano e usar either roll.'),
('Sentinel', 'Quando você acerta uma criatura com um ataque de oportunidade, o movimento dessa criatura é reduzido a 0 até o final do turno atual.'),
('Sharpshooter', 'Antes de fazer um ataque com uma arma de ataque à distância que você é proficiente, você pode escolher ignorar a cobertura.'),
('Shield Master', 'Se você usar a ação de Ataque, você pode usar uma ação bônus para tentar empurrar a criatura com sucesso.'),
('Skilled', 'Você ganha proficiência em qualquer combinação de três habilidades ou ferramentas de sua escolha.'),
('Skulker', 'Você pode tentar se esconder quando estiver apenas levemente obscurecido pela escuridão, névoa ou vegetação.'),
('Spell Sniper', 'Você aprende um cantrip que requer uma jogada de ataque. Quando você ataca com um cantrip, o alcance é dobrado.'),
('Tavern Brawler', 'Se você acertar uma criatura com um ataque de corpo-a-corpo improvisado, você pode usar uma ação bônus para tentar agarrar a criatura.'),
('Tough', 'Aumente sua Constituição em 1, até um máximo de 20. Você ganha pontos de vida temporários igual ao dobro do seu modificador de Constituição sempre que você ganha um nível.'),
('War Caster', 'Você tem vantagem em testes de resistência de concentração que você faz para manter a concentração em um feitiço quando você leva dano. Você pode realizar os componentes somáticos de feitiços mesmo quando você tiver armas ou um escudo em ambas as mãos.'),
('Weapon Master', 'Você ganha proficiência com quatro armas de sua escolha.');



INSERT INTO subclasses (class_id, subclass_name, subclass_description) VALUES
(1, 'Path of the Berserker', 'For those who embrace their rage to become ferocious warriors.'),
(1, 'Path of the Totem Warrior', 'For those who draw on the spirits of nature to aid their rage.'),
(2, 'College of Lore', 'Bards of the College of Lore know something about most things, collecting bits of knowledge from sources as diverse as scholarly tomes and peasant tales.'),
(2, 'College of Valor', 'Bards of the College of Valor are daring skalds whose tales keep alive the memory of the great heroes of the past, and thereby inspire a new generation of heroes.'),
(3, 'Knowledge Domain', 'The gods of knowledge – including Oghma, Boccob, Gilean, Aureon, and Thoth – value learning and understanding above all.'),
(3, 'Life Domain', 'The Life domain focuses on the vibrant positive energy – one of the fundamental forces of the universe – that sustains all life.'),
(4, 'Circle of the Land', 'Druids who are members of the Circle of the Land are mystics and sages who safeguard ancient knowledge and rites through a vast oral tradition.'),
(4, 'Circle of the Moon', 'Druids of the Circle of the Moon are fierce guardians of the wilds. Their order gathers under the full moon to share news and trade warnings.'),
(5, 'Champion', 'The archetypal Champion focuses on the development of raw physical power honed to deadly perfection.'),
(5, 'Battle Master', 'Those who emulate the archetypal Battle Master employ martial techniques passed down through generations.'),
(6, 'Way of the Open Hand', 'Monks of the Way of the Open Hand are the ultimate masters of martial arts combat, whether armed or unarmed.'),
(6, 'Way of Shadow', 'Monks of the Way of Shadow follow a tradition that values stealth and subterfuge.'),
(7, 'Oath of Devotion', 'The Oath of Devotion binds a paladin to the loftiest ideals of justice, virtue, and order.'),
(7, 'Oath of the Ancients', 'The Oath of the Ancients is as old as the race of elves and the rituals of the druids.'),
(8, 'Hunter', 'Emulating the Hunter archetype means accepting your place as a bulwark between civilization and the terrors of the wilderness.'),
(8, 'Beast Master', 'Ranger archetypes are known as beast masters, who forge close bonds with animals.'),
(9, 'Thief', 'The Thief archetype is stealthy enough to slip past the most vigilant guards and rogues.'),
(9, 'Assassin', 'The Assassin focuses on taking out targets cleanly and efficiently.'),
(10, 'Draconic Bloodline', 'Your innate magic comes from draconic magic that was mingled with your blood or that of your ancestors.'),
(10, 'Wild Magic', 'Your innate magic comes from the wild forces of chaos that underlie the order of creation.'),
(11, 'The Archfey', 'Your patron is a lord or lady of the fey, a creature of legend who holds secrets that were forgotten before the mortal races were born.'),
(11, 'The Fiend', 'You have made a pact with a fiend from the lower planes of existence, a being whose aims are evil, even if you strive against those aims.'),
(12, 'School of Abjuration', 'The School of Abjuration emphasizes magic that blocks, banishes, or protects.'),
(12, 'School of Conjuration', 'The School of Conjuration is focused on the study of summoning monsters and magic alike to bend to your will.');


INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(1, 3, 'Frenzy', 'At 3rd level, you gain the ability to go into a frenzy when you rage.'),
(1, 6, 'Mindless Rage', 'At 6th level, you gain the ability to shrug off some injury.'),
(1, 10, 'Intimidating Presence', 'At 10th level, you cant be charmed or frightened while raging.'),
(1, 14, 'Retaliation', 'Beginning at 14th level, you can use your reaction when you fall to 0 hit points in battle.'),
(1, 18, 'Primal Champion', 'At 18th level, you embody the power of the storm.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(2, 3, 'Spirit Seeker', 'At 3rd level, you gain the ability to cast the beast sense and speak with animals spells, but only as rituals.'),
(2, 6, 'Totem Spirit', 'At 6th level, you gain a magical benefit based on the totem animal you choose.'),
(2, 10, 'Spirit Walker', 'At 10th level, you can cast the commune with nature spell, but only as a ritual.'),
(2, 14, 'Totemic Attunement', 'At 14th level, you gain a magical benefit based on a totem animal you choose.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(3, 3, 'Bonus Proficiencies', 'At 3rd level, you gain proficiency with three skills of your choice.'),
(3, 3, 'Cutting Words', 'At 3rd level, you learn how to use your wit to distract, confuse, and otherwise sap the confidence and competence of others.'),
(3, 6, 'Additional Magical Secrets', 'At 6th level, you learn two spells of your choice from any class.'),
(3, 14, 'Peerless Skill', 'At 14th level, your mastery of lore and your exposure to the mysteries of the multiverse have culminated in an extraordinary talent.'); 


INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(4, 3, 'Bonus Proficiencies', 'At 3rd level, you gain proficiency with medium armor, shields, and martial weapons.'),
(4, 3, 'Combat Inspiration', 'At 3rd level, when you use your Bardic Inspiration feature, you can inspire your allies to greatness in battle.'),
(4, 6, 'Extra Attack', 'Beginning at 6th level, you can attack twice, instead of once, whenever you take the Attack action on your turn.'),
(4, 14, 'Battle Magic', 'At 14th level, you have mastered the art of weaving spellcasting and weapon use into a single harmonious act.'),
(4, 20, 'Combat Inspiration Improvement', 'Starting at 20th level, your Bardic Inspiration dice becomes a d12.');


INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(6, 1, 'Bonus Proficiencies', 'At 1st level, you gain proficiency with heavy armor.'),
(6, 1, 'Disciple of Life', 'Also at 1st level, your healing spells are more effective. Whenever you use a spell of 1st level or higher to restore hit points to a creature, the creature regains additional hit points equal to 2 + the spell’s level.'),
(6, 2, 'Channel Divinity: Preserve Life', 'Starting at 2nd level, you can use your Channel Divinity to heal the badly injured.'),
(6, 6, 'Blessed Healer', 'Beginning at 6th level, the healing spells you cast on others heal you as well.'),
(6, 8, 'Divine Strike', 'At 8th level, you gain the ability to infuse your weapon strikes with divine energy.'),
(6, 17, 'Supreme Healing', 'Starting at 17th level, when you would normally roll one or more dice to restore hit points with a spell, you instead use the highest number possible for each die.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(7, 2, 'Bonus Cantrip', 'When you choose this circle at 2nd level, you learn one additional druid cantrip of your choice.'),
(7, 2, 'Natural Recovery', 'Starting at 2nd level, you can regain some of your magical energy by sitting in meditation and communing with nature.'),
(7, 6, 'Land\s Stride', 'Starting at 6th level, moving through nonmagical difficult terrain costs you no extra movement.'),
(7, 10, 'Nature Ward', 'When you reach 10th level, you can\t be charmed or frightened by elementals or fey, and you are immune to poison and disease.'),
(7, 14, 'Nature Sanctuary', 'When you reach 14th level, creatures of the natural world sense your connection to nature and become hesitant to attack you.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(8, 2, 'Combat Wild Shape', 'At 2nd level, you gain the ability to use Wild Shape on your turn as a bonus action, rather than as an action.'),
(8, 2, 'Circle Forms', 'Starting at 2nd level, you gain the ability to use Wild Shape on your turn as a bonus action, rather than as an action.'),
(8, 6, 'Primal Strike', 'Starting at 6th level, your attacks in beast form count as magical for the purpose of overcoming resistance and immunity to nonmagical attacks and damage.'),
(8, 10, 'Elemental Wild Shape', 'At 10th level, you can expend two uses of Wild Shape at the same time to transform into an air elemental, an earth elemental, a fire elemental, or a water elemental.'),
(8, 14, 'Thousand Forms', 'By 14th level, you have learned to use magic to alter your physical form in more subtle ways. You can cast the alter self spell at will.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(8, 2, 'Combat Wild Shape', 'At 2nd level, you gain the ability to use Wild Shape on your turn as a bonus action, rather than as an action.'),
(8, 2, 'Circle Forms', 'Starting at 2nd level, you gain the ability to use Wild Shape on your turn as a bonus action, rather than as an action.'),
(8, 6, 'Primal Strike', 'Starting at 6th level, your attacks in beast form count as magical for the purpose of overcoming resistance and immunity to nonmagical attacks and damage.'),
(8, 10, 'Elemental Wild Shape', 'At 10th level, you can expend two uses of Wild Shape at the same time to transform into an air elemental, an earth elemental, a fire elemental, or a water elemental.'),
(8, 14, 'Thousand Forms', 'By 14th level, you have learned to use magic to alter your physical form in more subtle ways. You can cast the alter self spell at will.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(9, 3, 'Improved Critical', 'Beginning when you choose this archetype at 3rd level, your weapon attacks score a critical hit on a roll of 19 or 20.'),
(9, 7, 'Remarkable Athlete', 'Starting at 7th level, you can add half your proficiency bonus (round up) to any Strength, Dexterity, or Constitution check you make that doesn\t already use your proficiency bonus.'),
(9, 10, 'Additional Fighting Style', 'At 10th level, you can choose a second option from the Fighting Style class feature.'),
(9, 15, 'Superior Critical', 'Starting at 15th level, your weapon attacks score a critical hit on a roll of 18 20.'),
(9, 18, 'Survivor', 'At 18th level, you attain the pinnacle of resilience in battle. At the start of each of your turns, you regain hit points equal to 5 + your Constitution modifier if you have no more than half of your hit points left.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(10, 3, 'Combat Superiority', 'When you choose this archetype at 3rd level, you learn maneuvers that are fueled by special dice called superiority dice.'),
(10, 3, 'Student of War', 'At 3rd level, you gain proficiency with one type of artisans tools of your choice.'),
(10, 7, 'Know Your Enemy', 'Starting at 7th level, if you spend at least 1 minute observing or interacting with another creature outside combat, you can learn certain information about its capabilities compared to your own.'),
(10, 10, 'Improved Combat Superiority', 'At 10th level, your superiority dice turn into d10s.'),
(10, 15, 'Relentless', 'Starting at 15th level, when you roll initiative and have no superiority dice remaining, you regain 1 superiority die.'),
(10, 18, 'Improved Combat Superiority', 'At 18th level, your superiority dice turn into d12s.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(11, 3, 'Shadow Arts', 'Starting when you choose this tradition at 3rd level, you can use your ki to duplicate the effects of certain spells.'),
(11, 6, 'Shadow Step', 'At 6th level, you gain the ability to step from one shadow into another.'),
(11, 11, 'Cloak of Shadows', 'By 11th level, you have learned to become one with the shadows.'),
(11, 17, 'Opportunist', 'At 17th level, you can exploit a creature’s momentary distraction when it is hit by an attack.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(12, 3, 'Channel Divinity: Sacred Weapon', 'As an action, you can imbue one weapon that you are holding with positive energy, using your Channel Divinity.'),
(12, 7, 'Aura of Devotion', 'Starting at 7th level, you and friendly creatures within 10 feet of you can’t be charmed while you are conscious.'),
(12, 15, 'Purity of Spirit', 'At 15th level, you are always under the effects of a protection from evil and good spell.');


INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(13, 3, 'Channel Divinity: Nature’s Wrath', 'As an action, you can cause spectral vines to spring up and reach for a creature within 10 feet of you that you can see.'),
(13, 7, 'Aura of Warding', 'Starting at 7th level, you and friendly creatures within 10 feet of you have resistance to damage from spells.'),
(13, 15, 'Undying Sentinel', 'At 15th level, when you are reduced to 0 hit points and are not killed outright, you can choose to drop to 1 hit point instead.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(14, 3, 'Hunter’s Prey', 'At 3rd level, you gain one of the following features of your choice.'),
(14, 7, 'Defensive Tactics', 'At 7th level, you gain one of the following features of your choice.'),
(14, 11, 'Multiattack', 'At 11th level, you gain one of the following features of your choice.'),
(14, 15, 'Superior Hunter’s Defense', 'At 15th level, you gain one of the following features of your choice.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(15, 3, 'Ranger’s Companion', 'At 3rd level, you gain a beast companion that accompanies you on your adventures and is trained to fight alongside you.'),
(15, 7, 'Exceptional Training', 'Beginning at 7th level, on any of your turns when your beast companion doesn’t attack, you can use a bonus action to command the beast to take the Dash, Disengage, Dodge, or Help action on its turn.'),
(15, 11, 'Bestial Fury', 'Starting at 11th level, your beast companion can make two attacks when you command it to use the Attack action.'),
(15, 15, 'Share Spells', 'Beginning at 15th level, when you cast a spell targeting yourself, you can also affect your beast companion with the spell if the beast is within 30 feet of you.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(16, 3, 'Fast Hands', 'Starting at 3rd level, you can use the bonus action granted by your Cunning Action to make a Dexterity (Sleight of Hand) check, use your thieves’ tools to disarm a trap or open a lock, or take the Use an Object action.'),
(16, 9, 'Supreme Sneak', 'Starting at 9th level, you have advantage on a Dexterity (Stealth) check if you move no more than half your speed on the same turn.'),
(16, 13, 'Use Magic Device', 'By 13th level, you have learned enough about the workings of magic that you can improvise the use of items even when they are not intended for you.'),
(16, 17, 'Thief’s Reflexes', 'When you reach 17th level, you have become adept at laying ambushes and quickly escaping danger. You can take two turns during the first round of any combat.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(17, 3, 'Bonus Proficiency', 'When you choose this archetype at 3rd level, you gain proficiency with the disguise kit and the poisoner’s kit.'),
(17, 9, 'Infiltration Expertise', 'Starting at 9th level, you can unfailingly create false identities for yourself.'),
(17, 13, 'Impostor', 'At 13th level, you gain the ability to unerringly mimic another person’s speech, writing, and behavior.'),
(17, 17, 'Death Strike', 'Starting at 17th level, you become a master of instant death.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(18, 1, 'Draconic Resilience', 'As magic flows through your body, it causes physical traits of your dragon ancestors to emerge.'),
(18, 6, 'Elemental Affinity', 'Starting at 6th level, when you cast a spell that deals damage of the type associated with your draconic ancestry, you can add your Charisma modifier to one damage roll of that spell.'),
(18, 14, 'Dragon Wings', 'At 14th level, you gain the ability to sprout a pair of dragon wings from your back, gaining a flying speed equal to your current speed.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(19, 1, 'Wild Magic Surge', 'Starting when you choose this origin at 1st level, your spellcasting can unleash surges of untamed magic.'),
(19, 6, 'Bend Luck', 'Starting at 6th level, you have the ability to twist fate using your wild magic.'),
(19, 14, 'Controlled Chaos', 'At 14th level, you gain a modicum of control over the surges of your wild magic.'),
(19, 18, 'Spell Bombardment', 'Beginning at 18th level, the harmful energy of your spells intensifies.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(20, 1, 'Fey Presence', 'Starting at 1st level, your patron bestows upon you the ability to project the beguiling and fearsome presence of the fey.'),
(20, 6, 'Misty Escape', 'Starting at 6th level, you can vanish in a puff of mist in response to harm.'),
(20, 10, 'Beguiling Defenses', 'Beginning at 10th level, your patron teaches you how to turn the mind-affecting magic of your enemies against them.'),
(20, 14, 'Dark Delirium', 'Starting at 14th level, you can plunge a creature into an illusory realm.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(21, 1, 'Dark One’s Blessing', 'Starting at 1st level, when you reduce a hostile creature to 0 hit points, you gain temporary hit points equal to your Charisma modifier + your warlock level (minimum of 1).'),
(21, 6, 'Dark One’s Own Luck', 'Starting at 6th level, you can call on your patron to alter fate in your favor.'),
(21, 10, 'Fiendish Resilience', 'Starting at 10th level, you can choose one damage type when you finish a short or long rest. You gain resistance to that damage type until you choose a different one with this feature.'),
(21, 14, 'Hurl Through Hell', 'Starting at 14th level, when you hit a creature with an attack, you can use this feature to instantly transport the target through the lower planes.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(22, 2, 'Abjuration Savant', 'Starting at 2nd level, the gold and time you must spend to copy an abjuration spell into your spellbook is halved.'),
(22, 6, 'Arcane Ward', 'Starting at 6th level, you can shield yourself and others with a magical ward.'),
(22, 10, 'Project Ward', 'Starting at 10th level, you can expend an abjuration spell slot to cause your Arcane Ward to manifest as a protective barrier around one of your allies.'),
(22, 14, 'Improved Abjuration', 'Beginning at 14th level, when you cast an abjuration spell of 1st level or higher, you can simultaneously use a strand of the spell’s magic to create a magical ward on yourself or on another creature you touch.');

INSERT INTO subclass_features (subclass_id, level, subclass_feature_name, subclass_feature_description) VALUES
(23, 2, 'Conjuration Savant', 'Beginning when you select this school at 2nd level, the gold and time you must spend to copy a conjuration spell into your spellbook is halved.'),
(23, 6, 'Benign Transposition', 'Starting at 6th level, you can use your action to teleport to an unoccupied space you can see within 30 feet of you.'),
(23, 10, 'Focused Conjuration', 'Beginning at 10th level, while you are concentrating on a conjuration spell, your concentration can’t be broken as a result of taking damage.'),
(23, 14, 'Durable Summons', 'Starting at 14th level, any creature that you summon or create with a conjuration spell that has a duration of 1 minute or longer gains 30 temporary hit points.');





-- Criando consultas

-- buscar todas as spells de um character por id -----------

SELECT 
    s.spell_name AS 'Spell',
    s.spell_description AS 'Descrição'
FROM 
    characters ch
INNER JOIN 
    character_spells cs ON ch.character_id = cs.character_id
INNER JOIN 
    spells s ON cs.spell_id = s.spell_id
WHERE ch.character_id = 1;


-- buscando traços raciais de um personagem especifico
select rt.racial_trait_description as 'Descrição', rt.racial_trait_level as 'Nível'  
	from
		characters ch 
        inner join
        races ra on ch.race_id = ra.race_id
        inner join
        racial_traits rt on rt.race_id = ra.race_id
        where ch.character_id = 1; 
        
                
-- buscando habilidades de  classe de um personagem especifico

select cf.class_feature_name, cf.class_feature_description, cf.level 
	from
		characters ch 
        inner join
        classes c on c.class_id = ch.class_id
        inner join
        class_features cf on cf.class_id = ch.class_id
        where ch.character_id = 1;      
        
        
-- buscando habilidades de subclasse de um personagem especifico
-- [codgo]
	


--buscando traços raciais de uma raça em especifico
select rt.racial_trait_name from races ra 
inner join racial_traits rt on 
ra.race_id = rt.race_id where ra.race_id=10;



--buscando habilidades de classe de uma classe em espefico
select cl.class_name, cf.class_feature_name from
classes cl inner join
class_features cf on cl.class_id = cf.class_id;

select * from class_features;

INSERT INTO characters (
    character_name,
    user_id,
    alignment,
    race_id,
    class_id,
    subclass_id,
    character_journal,
    subrace_id,
    character_image,
    proficiency_bonus,
    current_life,
    max_life,
    inspiration,
    backstory,
    movement,
    background
) VALUES (
    'Nome do Personagem',
    1, -- ID do usuário
    'Leal e Bom',
    1, -- ID da raça
    1, -- ID da classe
    1, -- ID da subclasse
    'Texto do diário do personagem',
    1, -- ID da subraça
    'url_da_imagem.jpg',
    2, -- Bônus de proficiência
    20, -- Vida atual
    50, -- Vida máxima
    0, -- Inspiracão
    'História do personagem',
    30, -- Movimento (em pés)
    'Antecedente do personagem'
);
