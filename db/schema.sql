CREATE TABLE dogs (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  human_id INTEGER,

  FOREIGN KEY(human_id) REFERENCES human(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  house_id VARCHAR,

  FOREIGN KEY(house_id) REFERENCES house(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (name)
VALUES
  ("White House"),
  ("A Hotel"),
  ("Tent");

INSERT INTO
  humans (name, house_id)
VALUES
  ("Matt Damon", 1),
  ("Jamaal Charles", 1),
  ("Michael Jorand", 2),
  ("Tall Person", 3);

INSERT INTO
  dogs (name, human_id)
VALUES
  ("Fido", 1),
  ("Spot", 1),
  ("Skip", 2),
  ("Peanut Butter", 3),
  ("Cupcake", 3),
  ("Nacho", 4);