CREATE DATABASE test_schema;
USE test_schema;

 #############################  建立table    ############################# 
# 1 建表dept
CREATE TABLE `dept` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `deptno` mediumint unsigned NOT NULL DEFAULT '0',
  `dname` varchar(20) NOT NULL DEFAULT '',
  `loc` varchar(13) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

# 1 建表emp
CREATE TABLE `emp` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `empno` mediumint unsigned NOT NULL DEFAULT '0' COMMENT '編號',
  `ename` varchar(20) NOT NULL DEFAULT '' COMMENT '名字',
  `job` varchar(9) NOT NULL DEFAULT '' COMMENT '工作',
  `mgr` mediumint unsigned NOT NULL DEFAULT '0' COMMENT '上級編號',
  `hiredate` date NOT NULL COMMENT '到職時間',
  `sal` decimal(7,2) NOT NULL COMMENT '薪水',
  `comm` decimal(7,2) NOT NULL COMMENT '獎金',
  `deptno` mediumint unsigned NOT NULL DEFAULT '0' COMMENT '部門',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=gbk;

 #############################  開啟設置    ############################# 
# show variables like 'log_bin_trust_function_creators';
# set global log_bin_trust_function_creators = 1; # 單次開啟


 #############################  建立函數    ############################# 
# 隨機產生部門名稱
DELIMITER $$
CREATE FUNCTION rand_string(n INT) RETURNS VARCHAR(255)
BEGIN
	DECLARE chars_str VARCHAR(100)  DEFAULT 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    DECLARE return_str VARCHAR(255) DEFAULT '';
    DECLARE i INT DEFAULT 0;
    WHILE i < n DO
		SET return_str = CONCAT(return_str, SUBSTRING(chars_str, FLOOR(1+RAND()*52),1));
        SET i = i + 1;
	END WHILE;
    RETURN return_str;
END $$

# 隨機產生部門編號
DELIMITER $$
CREATE FUNCTION rand_num() RETURNS INT(5)
BEGIN
	DECLARE i INT DEFAULT 0;
    SET i = FLOOR(100+RAND()*10);
    RETURN i;
END $$


 #############################  建立stored procedure    ############################# 
# emp
DELIMITER $$
CREATE PROCEDURE insert_emp(IN START INT, IN max_num INT)
BEGIN
	DECLARE i INT DEFAULT 0;
	#set autocommit = 0
    SET autocommit = 0;
    REPEAT
    SET i = i + 1;
    INSERT INTO emp(empno, ename, job, mgr, hiredate, sal, comm, deptno) 
		VALUES((START + i), rand_string(6), 'SALESMAN', 0001, CURDATE(), 2000, 400, rand_num());
	UNTIL i = max_num
    END REPEAT;
    COMMIT;
END $$



# dept
 #############################  建立stored procedure    ############################# 
DELIMITER $$
CREATE PROCEDURE insert_dept(IN START INT, IN max_num INT)
BEGIN
	DECLARE i INT DEFAULT 0;
	#set autocommit = 0
    SET autocommit = 0;
    REPEAT
    SET i = i + 1;
    INSERT INTO dept(deptno, dname, loc) 
		VALUES((START + i), rand_string(10), rand_string(8));
	UNTIL i = max_num
    END REPEAT;
    COMMIT;
END $$

DELIMITER ;
CALL insert_dept(100, 10);
CALL insert_emp(101, 500);





