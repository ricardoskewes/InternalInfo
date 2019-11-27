-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema InventoryManagement
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema InventoryManagement
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `InventoryManagement` DEFAULT CHARACTER SET utf16 ;
USE `InventoryManagement` ;

-- -----------------------------------------------------
-- Table `InventoryManagement`.`Empleados`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `InventoryManagement`.`Empleados` (
  `idEmpleado` INT NOT NULL AUTO_INCREMENT,
  `Nombre` VARCHAR(45) NOT NULL,
  `ApellidoP` VARCHAR(45) NOT NULL,
  `FechaIngreso` DATE NULL,
  `Comentarios` TEXT NULL,
  PRIMARY KEY (`idEmpleado`),
  UNIQUE INDEX `idEmpleado_UNIQUE` (`idEmpleado` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `InventoryManagement`.`Productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `InventoryManagement`.`Productos` (
  `claveProducto` INT NOT NULL,
  `Medida` VARCHAR(45) NOT NULL,
  `Calibre` VARCHAR(45) NOT NULL,
  `Color` VARCHAR(45) NOT NULL,
  `Linea` VARCHAR(45) NULL,
  PRIMARY KEY (`claveProducto`),
  UNIQUE INDEX `claveProducto_UNIQUE` (`claveProducto` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `InventoryManagement`.`ContactosEnEmpresas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `InventoryManagement`.`ContactosEnEmpresas` (
  `idContacto` INT NOT NULL,
  `NombreContacto` VARCHAR(45) NULL,
  `ApellidoPContacto` VARCHAR(45) NULL,
  `ApellidoMContacto` VARCHAR(45) NULL,
  `Puesto` VARCHAR(45) NULL,
  `eMailContacto` VARCHAR(45) NULL,
  `Telefono` VARCHAR(45) NULL,
  PRIMARY KEY (`idContacto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `InventoryManagement`.`Clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `InventoryManagement`.`Clientes` (
  `idCliente` INT NOT NULL,
  `NombreCliente` VARCHAR(45) NOT NULL,
  `Direccion` VARCHAR(200) NULL,
  `Telefono1` VARCHAR(45) NOT NULL,
  `Telefono2` VARCHAR(45) NULL,
  `Telefono3` VARCHAR(45) NULL,
  `RFC` VARCHAR(15) NOT NULL,
  `AnoInicio` YEAR NULL,
  `UsuarioODistribuidor` VARCHAR(45) NOT NULL,
  `Industria` VARCHAR(45) NOT NULL,
  `ContactosEnEmpresas_idContacto` INT NOT NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE INDEX `idCliente_UNIQUE` (`idCliente` ASC) VISIBLE,
  INDEX `fk_Clientes_ContactosEnEmpresas1_idx` (`ContactosEnEmpresas_idContacto` ASC) VISIBLE,
  CONSTRAINT `fk_Clientes_ContactosEnEmpresas1`
    FOREIGN KEY (`ContactosEnEmpresas_idContacto`)
    REFERENCES `InventoryManagement`.`ContactosEnEmpresas` (`idContacto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `InventoryManagement`.`Ventas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `InventoryManagement`.`Ventas` (
  `idVenta` INT NOT NULL,
  `Fecha` DATE NOT NULL,
  `Cantidad` INT NOT NULL,
  `PrecioUnitarioConIVA` DECIMAL(13,2) NOT NULL,
  `Importe` VARCHAR(45) GENERATED ALWAYS AS (PrecioUnitarioConIVA*Cantidad) VIRTUAL,
  `idVendedor` INT NOT NULL,
  `idRegistro` INT NOT NULL,
  `PagoCliente` TINYINT(1) NOT NULL,
  `Comentarios` TEXT NULL,
  `Productos_claveProducto` INT NOT NULL,
  `Productos_Proveedores_idProveedor` INT NOT NULL,
  `Clientes_idCliente` INT NOT NULL,
  PRIMARY KEY (`idVenta`, `Productos_claveProducto`, `Productos_Proveedores_idProveedor`, `Clientes_idCliente`),
  UNIQUE INDEX `idVenta_UNIQUE` (`idVenta` ASC) VISIBLE,
  INDEX `fk_Ventas_Productos1_idx` (`Productos_claveProducto` ASC, `Productos_Proveedores_idProveedor` ASC) VISIBLE,
  INDEX `fk_Ventas_Clientes1_idx` (`Clientes_idCliente` ASC) VISIBLE,
  INDEX `fk_Ventas_Empleados1_idx` (`idRegistro` ASC) VISIBLE,
  INDEX `fk_Ventas_Empleados2_idx` (`idVendedor` ASC) VISIBLE,
  CONSTRAINT `fk_Ventas_Productos1`
    FOREIGN KEY (`Productos_claveProducto`)
    REFERENCES `InventoryManagement`.`Productos` (`claveProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Ventas_Clientes1`
    FOREIGN KEY (`Clientes_idCliente`)
    REFERENCES `InventoryManagement`.`Clientes` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Ventas_Empleados1`
    FOREIGN KEY (`idRegistro`)
    REFERENCES `InventoryManagement`.`Empleados` (`idEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Ventas_Empleados2`
    FOREIGN KEY (`idVendedor`)
    REFERENCES `InventoryManagement`.`Empleados` (`idEmpleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `InventoryManagement`.`Proveedores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `InventoryManagement`.`Proveedores` (
  `idProveedor` INT NOT NULL AUTO_INCREMENT,
  `NombreProveedor` VARCHAR(45) NOT NULL,
  `PaisDeOrigen` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  `Pagina Web` VARCHAR(60) NULL,
  `TaxID` VARCHAR(45) NOT NULL,
  `PuertoUtilizado` VARCHAR(50) NULL,
  `ContactosEnEmpresas_idContacto` INT NOT NULL,
  PRIMARY KEY (`idProveedor`),
  INDEX `fk_Proveedores_ContactosEnEmpresas1_idx` (`ContactosEnEmpresas_idContacto` ASC) VISIBLE,
  CONSTRAINT `fk_Proveedores_ContactosEnEmpresas1`
    FOREIGN KEY (`ContactosEnEmpresas_idContacto`)
    REFERENCES `InventoryManagement`.`ContactosEnEmpresas` (`idContacto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `InventoryManagement`.`Compras`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `InventoryManagement`.`Compras` (
  `idCompra` INT NOT NULL,
  `Cantidad` VARCHAR(45) NOT NULL,
  `NoFactura` VARCHAR(45) NULL,
  `Productos_claveProducto` INT NOT NULL,
  `Proveedores_idProveedor` INT NOT NULL,
  `CostoOrigenUSD` DECIMAL(13,2) NOT NULL,
  `CostoConIVAPesos` DECIMAL(13,2) NULL,
  `OrdenDeCompra` INT NULL,
  `NoPedimentoImportacion` VARCHAR(45) NOT NULL,
  `NoLote` VARCHAR(45) NULL,
  `Observaciones` VARCHAR(45) NULL,
  PRIMARY KEY (`idCompra`, `Productos_claveProducto`, `Proveedores_idProveedor`),
  INDEX `fk_Pedidos_Productos1_idx` (`Productos_claveProducto` ASC) VISIBLE,
  INDEX `fk_Pedidos_Proveedores1_idx` (`Proveedores_idProveedor` ASC) VISIBLE,
  CONSTRAINT `fk_Pedidos_Productos1`
    FOREIGN KEY (`Productos_claveProducto`)
    REFERENCES `InventoryManagement`.`Productos` (`claveProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedidos_Proveedores1`
    FOREIGN KEY (`Proveedores_idProveedor`)
    REFERENCES `InventoryManagement`.`Proveedores` (`idProveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
