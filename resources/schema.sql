CREATE TABLE config (`key` VARCHAR(255) NOT NULL, value LONGTEXT NOT NULL, PRIMARY KEY(`key`)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE users (id INT UNSIGNED AUTO_INCREMENT NOT NULL, login VARCHAR(100) NOT NULL, password VARCHAR(255) NOT NULL, display_name VARCHAR(255) DEFAULT NULL, gravatar_hash VARCHAR(32) DEFAULT NULL, language VARCHAR(10) DEFAULT NULL, role VARCHAR(100) NOT NULL, created_at DATETIME NOT NULL, max_events INT UNSIGNED NOT NULL, UNIQUE INDEX unique_login (login), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE teams (id INT UNSIGNED AUTO_INCREMENT NOT NULL, name VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, UNIQUE INDEX unique_slug (slug), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE users_teams (user_id INT UNSIGNED NOT NULL, team_id INT UNSIGNED NOT NULL, role VARCHAR(100) NOT NULL, INDEX IDX_71B58611A76ED395 (user_id), INDEX IDX_71B58611296CD8AE (team_id), PRIMARY KEY(user_id, team_id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE events (id INT UNSIGNED AUTO_INCREMENT NOT NULL, user_id INT UNSIGNED DEFAULT NULL, team_id INT UNSIGNED DEFAULT NULL, name VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, website VARCHAR(255) DEFAULT NULL, twitter VARCHAR(255) DEFAULT NULL, twitch VARCHAR(255) DEFAULT NULL, max_schedules INT UNSIGNED NOT NULL, INDEX IDX_5387574AA76ED395 (user_id), INDEX IDX_5387574A296CD8AE (team_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE schedules (id INT UNSIGNED AUTO_INCREMENT NOT NULL, event_id INT UNSIGNED NOT NULL, name VARCHAR(255) NOT NULL, slug VARCHAR(255) NOT NULL, timezone VARCHAR(100) NOT NULL, updated_at DATETIME NOT NULL, start DATETIME DEFAULT NULL, max_items INT UNSIGNED NOT NULL, theme VARCHAR(100) NOT NULL, INDEX IDX_313BDC8E71F7E88B (event_id), UNIQUE INDEX unique_slug (event_id, slug), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE schedule_items (id INT UNSIGNED AUTO_INCREMENT NOT NULL, schedule_id INT UNSIGNED NOT NULL, position INT UNSIGNED NOT NULL, length TIME NOT NULL, extra LONGTEXT NOT NULL, INDEX IDX_1D472911A40BC2D5 (schedule_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE schedule_columns (id INT UNSIGNED AUTO_INCREMENT NOT NULL, schedule_id INT UNSIGNED NOT NULL, position INT UNSIGNED NOT NULL, name VARCHAR(255) NOT NULL, INDEX IDX_21A4EC06A40BC2D5 (schedule_id), PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
CREATE TABLE sessions (id VARCHAR(255) NOT NULL, data LONGTEXT NOT NULL, mtime INT UNSIGNED NOT NULL, PRIMARY KEY(id)) DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ENGINE = InnoDB;
ALTER TABLE users_teams ADD CONSTRAINT FK_71B58611A76ED395 FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;
ALTER TABLE users_teams ADD CONSTRAINT FK_71B58611296CD8AE FOREIGN KEY (team_id) REFERENCES users (id) ON DELETE CASCADE;
ALTER TABLE events ADD CONSTRAINT FK_5387574AA76ED395 FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;
ALTER TABLE events ADD CONSTRAINT FK_5387574A296CD8AE FOREIGN KEY (team_id) REFERENCES teams (id) ON DELETE CASCADE;
ALTER TABLE schedules ADD CONSTRAINT FK_313BDC8E71F7E88B FOREIGN KEY (event_id) REFERENCES events (id) ON DELETE CASCADE;
ALTER TABLE schedule_items ADD CONSTRAINT FK_1D472911A40BC2D5 FOREIGN KEY (schedule_id) REFERENCES schedules (id) ON DELETE CASCADE;
ALTER TABLE schedule_columns ADD CONSTRAINT FK_21A4EC06A40BC2D5 FOREIGN KEY (schedule_id) REFERENCES schedules (id) ON DELETE CASCADE;
