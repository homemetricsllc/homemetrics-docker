CREATE DATABASE IF NOT EXISTS testing_db;

CREATE TABLE IF NOT EXISTS userpreferences(
  preference_id serial PRIMARY KEY,
  units int DEFAULT 0,
  contact_method INT DEFAULT 0,
  emergency_contact INT DEFAULT 0,
  product_updates INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS users (
     user_id       serial PRIMARY KEY,
     preference_id INT NULL,
     first_name    VARCHAR(50) NOT NULL,
     last_name     VARCHAR(50) NOT NULL,
     phone         VARCHAR(11) NOT NULL,
     email         VARCHAR(50) NOT NULL,
     password      VARCHAR(60) NOT NULL,
     verified      INT NOT NULL,
     access_code   VARCHAR(6) NOT NULL,
     push_token    VARCHAR(255) NULL,
	 account_type  INT DEFAULT 0,
     FOREIGN KEY (preference_id) REFERENCES userpreferences (preference_id) ON DELETE SET NULL
  );

CREATE TABLE IF NOT EXISTS houses (
  house_id 				serial PRIMARY KEY,
  user_id 				INT 			NULL,
  name 					VARCHAR(100) 	NULL,
  square_feet			INT 			NULL,
  resident_count		INT 			NULL,
  bath_count 			INT				NULL,
  bed_count				INT				NULL,
  year					INT 			NULL,
  address1 				VARCHAR(255) 	NULL,
  address2 				VARCHAR(255) 	NULL,
  city 					VARCHAR(255) 	NULL,
  state					VARCHAR(2) 		NULL,
  zipcode 				INT				NULL,
  water_usage_goal		INT				NULL,
  electric_usage_goal 	INT 			NULL,
  favorite 				INT				NULL,
  journey_status		INT				NULL,
  eco					BOOLEAN			NULL,
  FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS sensors (
  serial		serial 	PRIMARY KEY,
  house_id 		INT 		NULL,
  sensor_type 	INT			NULL,
  fw_version 	VARCHAR(5) 	NULL,
  sensor_name 	VARCHAR(20) NULL,
  last_seen 	INT			NULL,
  stage		BOOLEAN			FALSE,
  FOREIGN KEY (house_id) REFERENCES houses (house_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS waterdetect (
  id 			serial PRIMARY KEY,
  serial 		INT 		NOT NULL,
  time_stamp 	INT 			NULL,
  value			INT				NULL,
  FOREIGN KEY (serial) REFERENCES sensors (serial) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS waterflow (
  id 			serial PRIMARY KEY,
  serial 		INT 		NOT NULL,
  time_stamp 	INT 			NULL,
  min			DOUBLE PRECISION				NULL,
  max			DOUBLE PRECISION				NULL,
  avg			DOUBLE PRECISION				NULL,
  sd			DOUBLE PRECISION				NULL,
  FOREIGN KEY (serial) REFERENCES sensors (serial) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS waterpressure (
  id 			serial PRIMARY KEY,
  serial 		INT 		NOT NULL,
  time_stamp 	INT 			NULL,
  min			DOUBLE PRECISION				NULL,
  max			DOUBLE PRECISION				NULL,
  avg			DOUBLE PRECISION				NULL,
  sd			DOUBLE PRECISION				NULL,
  FOREIGN KEY (serial) REFERENCES sensors (serial) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS watertemp (
  id 			serial PRIMARY KEY,
  serial 		INT 		NOT NULL,
  time_stamp 	INT 			NULL,
  min			DOUBLE PRECISION				NULL,
  max			DOUBLE PRECISION				NULL,
  avg			DOUBLE PRECISION				NULL,
  sd			DOUBLE PRECISION				NULL,
  FOREIGN KEY (serial) REFERENCES sensors (serial) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS controlvalve(
  id serial PRIMARY KEY,
  serial INT NOT NULL,
  time_stamp INT NULL,
  value INT NULL,
  FOREIGN KEY (serial) REFERENCES sensors (serial) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS electricusage(
  id serial PRIMARY KEY,
  serial INT NOT NULL,
  time_stamp INT NULL,
  min DOUBLE PRECISION NULL,
  max DOUBLE PRECISION NULL,
  avg DOUBLE PRECISION NULL,
  sd DOUBLE PRECISION NULL,
  FOREIGN KEY (serial) REFERENCES sensors (serial) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS houseownership (
  id 			serial PRIMARY KEY,
  house_id 		INT 	NOT NULL,
  user_id		INT 	NOT NULL,
  admin			INT		NULL,
  accepted 		INT		NULL,
  time_stamp 	INT		NULL,
  FOREIGN KEY (house_id) REFERENCES houses (house_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS housepreferences(
  id serial PRIMARY KEY,
  house_id int NOT NULL,
  user_id INT NOT NULL,
  favorite INT NULL,
  house_name VARCHAR(40),
  FOREIGN KEY (house_id) REFERENCES houses (house_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);



CREATE TABLE IF NOT EXISTS notifications(
  notification_id serial PRIMARY KEY,
  recipient VARCHAR(255) NULL,
  time_stamp INT NULL,
  viewed INT NULL,
  signal_id INT NULL,
  device_type INT NULL,
  user_id INT NULL,
  house_id INT NULL,
  action INT NULL,
  action_payload VARCHAR(255) NULL,
  priority INT NULL,
  scope INT NULL,
  free_text VARCHAR(255) NULL,
  FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE SET NULL,
  FOREIGN KEY (house_id) REFERENCES houses (house_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS installations(
  id serial PRIMARY KEY,
  user_id INT NOT NULL,
  house_id INT NOT NULL,
  order_created INT NOT NULL,
  order_ready INT NULL,
  order_installed INT NULL,
  module_count INT NULL,
  detect_count INT NULL,
  electric_count INT NULL,
  beta BOOL NULL,
  FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
  FOREIGN KEY (house_id) REFERENCES houses (house_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS journey(
  journey_id serial PRIMARY KEY,
  user_id INT NOT NULL,
  phone_type INT NULL,
  property_type VARCHAR(60) NULL,
  FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS daily_water_flow_sum(
  id serial PRIMARY KEY,
  serial INT NOT NULL,
  time_created INT NULL,
  water_usage_per_hour FLOAT(8)[],
  FOREIGN KEY (serial) REFERENCES sensors (serial) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS avg_water_temperature_for_6_hours(
  id serial PRIMARY KEY,
  serial INT NOT NULL,
  time_created INT NULL,
  average_water_temperature DOUBLE PRECISION NULL,
  FOREIGN KEY (serial) REFERENCES sensors (serial) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS daily_average_pressure_with_min_max(
  id serial PRIMARY KEY,
  serial INT NOT NULL,
  time_created INT NULL,
  average_water_pressure DOUBLE PRECISION NULL,
  max_water_pressure DOUBLE PRECISION NULL,
  min_water_pressure DOUBLE PRECISION NULL,
  FOREIGN KEY (serial) REFERENCES sensors (serial) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS house_mode(
  id serial PRIMARY KEY,
  house_id INT NOT NULL,
  away_mode INT,
  protected_mode INT,
  FOREIGN KEY (house_id) REFERENCES houses (house_id) ON DELETE SET NULL
);
