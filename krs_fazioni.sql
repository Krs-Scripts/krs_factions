-- Insert societies
INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
    ('society_ballas', 'BALLAS', 1),
    ('society_families', 'FAMILIES', 1),
    ('society_cartello', 'CARTELLO', 1),
    ('society_mercatonero', 'MERCATONERO', 1);

-- Insert society account data
INSERT INTO `addon_account_data` (`id`, `account_name`, `money`, `owner`) VALUES
    (15, 'society_ballas', 50000, NULL),
    (16, 'society_families', 50000, NULL),
    (17, 'society_cartello', 50000, NULL),
    (18, 'society_mercatonero', 50000, NULL);

-- Insert jobs
INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
    ('ballas', 'BALLAS', 1),
    ('families', 'FAMILIES', 1),
    ('cartello', 'CARTELLO', 1),
    ('mercatonero', 'MERCATONERO', 1),
    ('offballas', 'Fuori Servizio', 0),
    ('offfamilies', 'Fuori Servizio', 0),
    ('offcartello', 'Fuori Servizio', 0),
    ('offmercatonero', 'Fuori Servizio', 0);

-- Insert job grades
INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
    (86, 'ballas', 1, 'scagnozzo', 'Scagnozzo', 200, '{}', '{}'),
    (87, 'ballas', 2, 'killer', 'Killer', 800, '{}', '{}'),
    (88, 'ballas', 3, 'boss', 'Capo Ballas', 1100, '{}', '{}'),
    (89, 'families', 1, 'scagnozzo', 'Scagnozzo', 200, '{}', '{}'),
    (90, 'families', 2, 'killer', 'Killer', 800, '{}', '{}'),
    (91, 'families', 3, 'boss', 'Capo Families', 1100, '{}', '{}'),
    (92, 'cartello', 1, 'scagnozzo', 'Scagnozzo', 200, '{}', '{}'),
    (93, 'cartello', 2, 'killer', 'Killer', 800, '{}', '{}'),
    (94, 'cartello', 3, 'boss', 'Capo Cartello', 1100, '{}', '{}'),
    (95, 'mercatonero', 1, 'scagnozzo', 'Scagnozzo', 200, '{}', '{}'),
    (96, 'mercatonero', 2, 'killer', 'Killer', 800, '{}', '{}'),
    (97, 'mercatonero', 3, 'boss', 'Capo Mercatonero', 1100, '{}', '{}'),
    (98, 'offballas', 1, 'scagnozzo', 'Scagnozzo', 0, '{}', '{}'),
    (99, 'offballas', 2, 'killer', 'Killer', 0, '{}', '{}'),
    (100, 'offballas', 3, 'boss', 'Capo Ballas', 0, '{}', '{}'),
    (101, 'offfamilies', 1, 'scagnozzo', 'Scagnozzo', 0, '{}', '{}'),
    (102, 'offfamilies', 2, 'killer', 'Killer', 0, '{}', '{}'),
    (103, 'offfamilies', 3, 'boss', 'Capo Families', 0, '{}', '{}'),
    (104, 'offcartello', 1, 'scagnozzo', 'Scagnozzo', 0, '{}', '{}'),
    (105, 'offcartello', 2, 'killer', 'Killer', 0, '{}', '{}'),
    (106, 'offcartello', 3, 'boss', 'Capo Cartello', 0, '{}', '{}'),
    (107, 'offmercatonero', 1, 'scagnozzo', 'Scagnozzo', 0, '{}', '{}'),
    (108, 'offmercatonero', 2, 'killer', 'Killer', 0, '{}', '{}'),
    (109, 'offmercatonero', 3, 'boss', 'Capo Mercatonero', 0, '{}', '{}');






DELETE FROM `jobs` WHERE `name` IN ('ballas', 'families', 'cartello', 'mercatonero', 'offballas', 'offfamilies', 'offcartello', 'offmercatonero');

DELETE FROM `job_grades` WHERE `job_name` IN ('ballas', 'families', 'cartello', 'mercatonero', 'offballas', 'offfamilies', 'offcartello', 'offmercatonero');

DELETE FROM `addon_account` WHERE `name` IN ('society_ballas', 'society_families', 'society_cartello', 'society_mercatonero');

DELETE FROM `addon_account_data` WHERE `account_name` IN ('society_ballas', 'society_families', 'society_cartello', 'society_mercatonero');