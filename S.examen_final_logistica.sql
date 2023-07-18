-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`cliente_log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`cliente_log` (
  `id_cliente` INT NOT NULL,
  `nombre` VARCHAR(45) NULL,
  `apellido` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `direccion` VARCHAR(45) NULL,
  PRIMARY KEY (`id_cliente`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`paquete`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`paquete` (
  `id_paquete` INT NOT NULL,
  `id_cliente` INT NOT NULL,
  `descripcion` VARCHAR(100) NULL,
  `peso` DECIMAL NULL,
  `destino` VARCHAR(45) NULL,
  `estatus` VARCHAR(45) NULL,
  PRIMARY KEY (`id_paquete`, `id_cliente`),
  INDEX `fk_paquete_cliente_log_idx` (`id_cliente` ASC) VISIBLE,
  CONSTRAINT `fk_paquete_cliente_log`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `mydb`.`cliente_log` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`transporte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`transporte` (
  `id_transporte` INT NOT NULL,
  `tipo` VARCHAR(45) NULL,
  `capacidad_peso` DECIMAL NULL,
  `estatus` VARCHAR(45) NULL,
  PRIMARY KEY (`id_transporte`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`envio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`envio` (
  `id_envio` INT NOT NULL,
  `id_paquete` INT NOT NULL,
  `id_transporte` INT NOT NULL,
  `fecha_envio` DATE NULL,
  `fecha_entrega_estimada` DATE NULL,
  `fecha_entrega_real` DATE NULL,
  PRIMARY KEY (`id_envio`, `id_paquete`, `id_transporte`),
  INDEX `fk_envio_paquete1_idx` (`id_paquete` ASC) VISIBLE,
  INDEX `fk_envio_transporte1_idx` (`id_transporte` ASC) VISIBLE,
  CONSTRAINT `fk_envio_paquete1`
    FOREIGN KEY (`id_paquete`)
    REFERENCES `mydb`.`paquete` (`id_paquete`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_envio_transporte1`
    FOREIGN KEY (`id_transporte`)
    REFERENCES `mydb`.`transporte` (`id_transporte`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

#pregunta 1 los 5 clientes que mas envios han hecho

select cliente_log.nombre, cliente_log.apellido, count(envio.id_envio) as total_envios
from envio
inner join paquete on envio.id_paquete = paquete.id_paquete
inner join cliente_log on paquete.id_cliente = cliente_log.id_cliente
group by cliente_log.nombre, cliente_log.apellido
order by total_envios desc
limit 5;

#pregunta 2 cuantos paquetes estan actualmente con el estatus "en transito"

select paquete.estatus, count(paquete.estatus) as paq_en_transito
from paquete
where paquete.estatus = 'en transito'; #este comando lo hice yo

SELECT COUNT(*) AS paquetes_en_transito
FROM paquete
WHERE estatus = 'en transito'; #este comando es el del profe

#pregunta 3 el promedio de peso de los paquetes enviados en el ultimo mes

select avg(paquete.peso) as promedio_peso
from envio
inner join paquete on envio.id_paquete = paquete.id_paquete
where envio.fecha_envio >= now() - interval 1 month;

#pregunta 4 actualizar el estatus de los transportes que han excedido su capacidad de peso





