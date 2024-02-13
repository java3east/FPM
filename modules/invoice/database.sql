CREATE TABLE `invoices` (
    `id` INT NOT NULL AUTO_INCREMENT, 
    `receiver` VARCHAR(100) NOT NULL COMMENT 'job:~identifier~ / identifier:~identifier~ ',
    `sender` VARCHAR(100) NOT NULL COMMENT 'job:~identifier~ / identifier:~identifier~ ',
    `reason` VARCHAR(50) NOT NULL COMMENT 'short description',
    `price` INT NOT NULL,
    `note` TEXT NOT NULL COMMENT 'long description',
    `due` DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `payed` BOOLEAN NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB;