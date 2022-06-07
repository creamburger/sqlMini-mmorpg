SHOW DATABASES;

USE playdata;

SHOW tables;

DROP TABLE IF EXISTS player;
DROP TABLE IF EXISTS guild;

-- 길드 테이블 생성
CREATE TABLE guild(
-- column 정의
	gno			INT AUTO_INCREMENT,		-- 길드 번호, pk
	name		VARCHAR(10),			-- 길드명, 10글자까지 가능, NOT NULL
	tend		VARCHAR(10),			-- 길드 성향, 전투/생활/친목
	reg			VARCHAR(10),			-- 길드 활동 지역, 북부/서부/동부/남부/중앙
	lev			SMALLINT,				-- 길드 LEVEL, defluat 1, NOT NULL, 최대 200
	create_date	DATE,					-- 길드 생성 일, NOT NULL
-- pk 정의
	CONSTRAINT pk_gno_guild PRIMARY KEY (gno)
);

-- 플레이어 캐릭터 테이블 생성
CREATE TABLE player(
-- column 정의
	id			VARCHAR(30),	-- 플레이어 캐릭터 id, pk, 대소문자 구분
	gno			INT,			-- 길드 번호, fk, NULL 가능
	job 		VARCHAR(10),	-- 직업, 전사/궁수/마법사/성직자/암살자, NOT NULL
	lev			SMALLINT,		-- LEVEL, DEFAULT 1, NOT NULL, 최대 200
	str			INT,			-- 전투력, DEFAULT 100, NOT NULL 
	sex			VARCHAR(1),		-- 성벌(M, F), NOT NULL
	rid			VARCHAR(10),	-- 대표 플레어이 캐릭터 id, NOT NULL, 한명의 플레이어는 다수의 캐릭터를 생성할 수 있다.
	create_date	DATE,			-- 캐릭터 생성 일, NOT NULL
	last_date	DATE,			-- 최근 접속일, NOT NULL
	cash		int,			-- 누적 결제 금액, DEFAULT 0, NOT NULL
-- pk, fk 정의
	CONSTRAINT pk_id_adventurer PRIMARY KEY (id),
	CONSTRAINT fk_gno_adventurer FOREIGN KEY (gno) REFERENCES guild(gno)
);

-- 테이블 생성 확인
SHOW tables;
DESC guild;
DESC player;

-- guild 테이블 길드 번호 자동 증가 초기값 설정
ALTER TABLE guild AUTO_INCREMENT = 1000;

-- guild 테이블 사용자 입력 데이터 대소문자 구분 설정
-- 길드명
ALTER TABLE guild CHANGE name name VARCHAR(30) BINARY;

-- player 테이블 사용자 입력 데이터 대소문자 구분 설정
-- 플레이어 id, 대표플레이어 id
ALTER TABLE player CHANGE id id VARCHAR(30) BINARY;
ALTER TABLE player CHANGE rid rid VARCHAR(30) BINARY;

-- guild 테이블 not null 설정
-- 길드명, 레벨, 생성일
ALTER TABLE guild MODIFY name VARCHAR(30) BINARY NOT NULL;
ALTER TABLE guild MODIFY lev SMALLINT NOT NULL;
ALTER TABLE guild MODIFY create_date DATE NOT NULL;

DESC guild;

-- player 테이블 not null 설정
-- 직업, 레벨, 전투력, 서버, 성별, 대표 플레이어, 생성일, 최근접속일, 캐쉬
ALTER TABLE player MODIFY job VARCHAR(10) NOT NULL;
ALTER TABLE player MODIFY lev SMALLINT NOT NULL;
ALTER TABLE player MODIFY str INT NOT NULL;
ALTER TABLE player MODIFY sex VARCHAR(1) NOT NULL;
ALTER TABLE player MODIFY rid VARCHAR(30) BINARY NOT NULL;
ALTER TABLE player MODIFY create_date DATE NOT NULL;
ALTER TABLE player MODIFY last_date DATE NOT NULL;
ALTER TABLE player MODIFY cash INT NOT NULL;

DESC player;

-- guild 테이블 default 값 설정
-- 레벨
ALTER TABLE guild ALTER lev SET DEFAULT 1;

DESC guild;

-- player 테이블 default 값 설정
-- 레벨, 전투력, 캐쉬
ALTER TABLE player ALTER lev SET DEFAULT 1;
ALTER TABLE player ALTER str SET DEFAULT 100;
ALTER TABLE player ALTER cash SET DEFAULT 0;

DESC player;

-- guild check 설정
-- 길드명, 성향, 지역, 레벨, 생성일
-- 길드명 : 특수 문자 X
-- 성향 : 전투, 생활, 친목
-- 지역 : 북부, 서부, 남부, 동부, 중앙
-- 레밸 : 1 이상 200 이하
-- 생성일 : 2020-05-30 포함 이후
ALTER TABLE guild ADD CONSTRAINT chk_name_guild CHECK (name NOT REGEXP '!|@|#|&|<|>');
ALTER TABLE guild ADD CONSTRAINT chk_tend_guild CHECK (tend IN ('전투', '생활', '친목'));
ALTER TABLE guild ADD CONSTRAINT chk_reg_guild CHECK (reg IN ('북부', '서부', '남부', '동부', '중앙'));
ALTER TABLE guild ADD CONSTRAINT chk_lev_guild CHECK (lev BETWEEN 1 AND 200);
ALTER TABLE guild ADD CONSTRAINT chk_cdate_guild CHECK (create_date >= '2020-05-30');

-- player check 설정
-- id, 직업, 레벨, 전투력, 성별, rid, 생성일, 최근 접속일, 캐쉬
-- id : 특수 문자 X
-- 직업 : 전사, 마법사, 궁수, 성직자, 암살자
-- 레벨 : 1 이상 200 이하
-- 전투력 : 100 이상
-- 성별 : M 또는 F
-- rid : 특수 문자 X
-- 생성일 : 2020-05-30 포함 이후
-- 최근 접속일 : 생성일 포함 이후
-- 캐쉬 : 0 이상
ALTER TABLE player ADD CONSTRAINT chk_id_player CHECK (id NOT REGEXP '!|@|#|&|<|>');
ALTER TABLE player ADD CONSTRAINT chk_job_player CHECK (job IN ('전사', '마법사', '궁수', '성직자', '암살자'));
ALTER TABLE player ADD CONSTRAINT chk_lev_player CHECK (lev BETWEEN 1 AND 200);
ALTER TABLE player ADD CONSTRAINT chk_str_player CHECK (str >= 100);
ALTER TABLE player ADD CONSTRAINT chk_sex_player CHECK (sex IN('M', 'F'));
ALTER TABLE player ADD CONSTRAINT chk_rid_player CHECK (rid NOT REGEXP '!|@|#|&|<|>');
ALTER TABLE player ADD CONSTRAINT chk_cdate_player CHECK (create_date >= '2020-05-30');
ALTER TABLE player ADD CONSTRAINT chk_ldate_player CHECK (last_date >= create_date);
ALTER TABLE player ADD CONSTRAINT chk_cash_player CHECK (cash >= 0);

-- 제약 조건 확인
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'guild';
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = 'player';

-- guild 데이터 insert
-- 길드명, 성향, 지역, 레벨(default 1), 생성 일(2020-05-30 이후)
INSERT INTO guild (name, tend, reg, lev, create_date) VALUES ('오직전투', '전투', '서부', 120, '2021-06-11');
INSERT INTO guild (name, tend, reg, lev, create_date) VALUES ('채집제작길드', '생활', '동부', 170, '2020-09-14');
INSERT INTO guild (name, tend, reg, lev, create_date) VALUES ('광부인생', '전투', '북부', 80, '2021-07-30');
INSERT INTO guild (name, tend, reg, lev, create_date) VALUES ('투기장', '전투', '남부', 130, '2021-04-11');
INSERT INTO guild (name, tend, reg, lev, create_date) VALUES ('아메리카노', '친목', '동부', 200, '2020-05-30');
INSERT INTO guild (name, tend, reg, lev, create_date) VALUES ('Asgard', '전투', '중앙', 199, '2020-06-01');

SELECT * FROM guild;

-- player 데이터 insert
-- id, 길드 번호, 직업, 레벨, 전투력, 성별, 대표 id, 생성일, 최근접속일, 캐쉬
INSERT INTO player VALUES ('방패전사', 1000, '전사', 200, 20000, 'M', '전사', '2020-05-30', '2022-05-30', 100000000);
INSERT INTO player VALUES ('헤르미온느', 1000, '마법사', 184, 18400, 'F', '헤르미온느', '2020-07-03', '2022-05-29', 50000000);
INSERT INTO player VALUES ('10점만점', 1000, '궁수', 192, 19200, 'F', '10점만점', '2020-09-05', '2022-05-25', 1200000);
INSERT INTO player VALUES ('귀족힐러', 1000, '성직자', 172, 17200, 'M', '귀족힐러', '2020-10-16', '2022-04-29', 1800000);
INSERT INTO player VALUES ('Sneak', 1000, '암살자', 196, 19600, 'F', 'Sneak', '2020-12-31', '2022-03-15', 900000);
INSERT INTO player VALUES ('Shield', 1001, '전사', 194, 19400, 'F', '헤르미온느', '2021-07-12', '2022-04-15', 4500000);
INSERT INTO player VALUES ('goaway', 1001, '마법사', 145, 14500, 'F', '전사', '2021-09-19', '2022-03-04', 1500000);
INSERT INTO player VALUES ('Leaf', 1001, '궁수', 173, 17300, 'M', 'Leaf', '2021-10-27', '2022-01-18', 10000000);
INSERT INTO player VALUES ('Opera', 1001, '성직자', 94, 9400, 'F', 'Opera', '2022-01-01', '2022-05-09', 400000);
INSERT INTO player VALUES ('Silent', 1001, '암살자', 30, 3000, 'M', 'Opera', '2022-02-01', '2022-04-30', 150000);
INSERT INTO player VALUES ('No1나만도시락', 1002, '마법사', 101, 10100, 'F', 'No1나만도시락', '2020-05-31', '2022-04-23', 192800);
INSERT INTO player VALUES ('No2나만도시락', 1002, '암살자', 97, 9700, 'M', 'No1나만도시락', '2021-08-22', '2022-04-29', 123900);
INSERT INTO player VALUES ('세바스짱', 1002, '궁수', 105, 10500, 'F', '세바스짱', '2020-09-17', '2022-5-30', 180000);
INSERT INTO player VALUES ('트롤인데요', 1002, '궁수', 112, 11200, 'F', '트롤인데요', '2020-10-30', '2022-05-06', 827100);
INSERT INTO player VALUES ('뭐하세요', 1002, '전사', 66, 6600, 'M', '트롤인데요', '2021-08-22', '2022-04-14', 1000000);
INSERT INTO player VALUES ('성기사있으면던짐', 1003, '성직자', 99, 9900, 'M', '성기사있으면던짐', '2021-01-01', '2022-02-11', 162000);
INSERT INTO player VALUES ('투신', 1003, '암살자', 123, 12300, 'F', '투신', '2020-10-18', '2022-01-21', 5000000);
INSERT INTO player VALUES ('빅토르', 1003, '마법사', 100, 10000, 'M', '빅토르', '2021-02-17', '2022-06-01', 1010000);
INSERT INTO player VALUES ('이렐리아', 1003, '전사', 90, 9000, 'F', '빅토르', '2021-09-22', '2022-05-23', 293800);
INSERT INTO player VALUES ('Karina', 1003, '궁수', 103, 10300, 'M', '빅토르', '2020-06-19', '2022-05-31', 562000);
INSERT INTO player VALUES ('Tomas', 1004, '성직자', 164, 16400, 'F', 'Tomas', '2021-02-20', '2022-05-31', 600000);
INSERT INTO player VALUES ('하울의움직이는성', 1004, '성직자', 123, 12300, 'F', 'Tomas', '2021-02-21', '2022-05-31', 160000);
INSERT INTO player VALUES ('카드값줘채리', 1004, '마법사', 131, 13100, 'F', '카드값줘채리', '2022-01-05', '2022-05-31', 150000);
INSERT INTO player VALUES ('티끌모아파산', 1004, '전사', 122, 12200, 'M', '세바스짱', '2020-08-08', '2020-10-31', 200000);
INSERT INTO player VALUES ('친정간금자씨', 1004, '궁수', 150, 15000, 'F', '투신', '2021-11-14', '2022-01-01', 0);
INSERT INTO player VALUES ('명탐정코난', 1005, '전사', 157, 15700, 'M', '명탐정코난', '2021-02-21', '2021-09-08', 5000000);
INSERT INTO player VALUES ('불이야', 1005, '마법사', 192, 19200, 'F', '불이야', '2020-05-30', '2022-05-31', 15000000);
INSERT INTO player VALUES ('Kevin', 1005, '전사', 186, 18600, 'M', 'Sneak', '2021-02-01', '2022-04-29', 6000000);
INSERT INTO player VALUES ('시베리안허스키', 1005, '암살자', 199, 19900, 'F', '시베리안허스키', '2020-07-08', '2022-03-30', 8975200);
INSERT INTO player VALUES ('아뇨뚱인데요', 1005, '성직자', 200, 20000, 'M', 'Leaf', '2020-09-01', '2022-04-25', 3564000);

SELECT * FROM player;

-- commit
COMMIT;
select * from player;
select * from guild;
select * from player order by gno;






CREATE TABLE friendtb AS SELECT * FROM player WHERE 1=2;
ALTER TABLE friendtb DROP COLUMN rid;
ALTER TABLE friendtb DROP COLUMN create_date;
ALTER TABLE friendtb DROP COLUMN cash;

select * from friendtb;

-- <갓겜 MMORPG '엔코아연대기'에 들어오신 걸 환영합니다!>
-- 1. <이름, 직업(전사/궁수/마법사/성직자/암살자 택1), 캐릭터 성별(F/M), 플레이어 id를 적어 캐릭터를 생성해주세요!>
-- 다음 문장을 사용하세요: INSERT INTO player (id, job, sex, fid, create_date, last date) VALUES (, , , ,curdate(), curdate());


-- ex) INSERT INTO player (id, job, sex, rid, create_date, last_date) VALUES ('예지미인','전사','F','예지',curdate(), curdate());

-- 2. 캐릭터 생성을 축하드립니다! 신규 아이디 생성시 자동으로 신규 모험가 혜택이 30일간 적용되며, 기본 전투력이 1.2배가 됩니다.
-- trigger를 사용하여 설정해주세요.
DROP TRIGGER IF EXISTS new_char_event;
delimiter //
CREATE TRIGGER new_char_event
BEFORE INSERT 
ON player 
FOR EACH ROW
BEGIN
    IF timestampdiff(DAY, (NEW.create_date), curdate()) BETWEEN 0 AND 30 THEN 
        SET NEW.str = NEW.str*1.2;
    END IF;
END //
delimiter ;

-- 3. 첫 모험을 떠난 당신, 레벨을 빨리 올리기 위해서는 게임 내 유료 장비를 구입하는 것이 유리합니다.
-- 초보자만 누릴 수 있는 혜택! 500%의 효율!
-- id를 입력받아 실행할 때마다 자동으로 5000 cash씩 충전해주는 프로시저를 실행시켜 볼까요? 프로시저를 시행하면 전투력(str)이 5000/(플레이어레벨)*5)만큼 상승합니다.
​

drop procedure autocharge;
delimiter //
create procedure autocharge (v_id VARCHAR(10))
begin
 update player set cash = cash+5000 where id = v_id;
 update player set str = str+5000/((player.lev)*5) where id = v_id;
end//
delimiter ;

-- 프로시저 실행
call autocharge('용사짱');

-- 다음 문장을 써서 얼마나 질렀는지 확인해 봅시다.
-- select id, cash, str from player where id = '';

-- 4. 좋은 무기로 전투력을 갖췄으니, 사냥을 통해 레벨을 올릴 차례입니다! 1레벨이 오를 때마다 전투력이 100씩 증가하는 초보자용 사냥터입니다. id를 입력받으면 레벨은 1, 전투력은 100씩 올려주는 프로시저를 만들어 주세요.
-- 프로시저 안에서 'id', '레벨', '전투력'이라는 항목으로 id, lev, str을 출력할 수 있도록 해주세요.
DROP PROCEDURE IF EXISTS level_up;
​
CREATE PROCEDURE level_up(player_id VARCHAR(30) BINARY)
BEGIN
	UPDATE player
	SET lev = lev + 1, str = str + 100
	WHERE id = player_id;
	COMMIT;
	SELECT id, lev AS '레벨', str AS '전투력'
	FROM player
	WHERE id = player_id;
END;


-- 5. 혼자 게임을 하려니 너무 심심하네요, 길드를 하나 만들어 볼까요?
-- 길드 생성을 원하시면 길드명과 길드 성향을 정해주세요!
-- 선택 가능한 길드 성향은 다음과 같습니다. 전투/생활/친목
DROP PROCEDURE IF EXISTS create_guild;
CREATE PROCEDURE create_guild(guild_name VARCHAR(30) BINARY)
BEGIN
	INSERT INTO guild (name, create_date)
	VALUES (guild_name, CURDATE());
	SELECT *
	FROM guild
	WHERE name = guild_name;
END;
CALL create_guild('신규길드01');
-- select * from player where id =''

-- 6. 만든 새 길드에 가입해 보세요!
-- id와 guild name을 이용해 새로운 길드에 가입합니다.
-- Procedure, Update, Subquery 활용해주세요.

DROP PROCEDURE IF EXISTS signing_up_guild;
​
CREATE PROCEDURE signing_up_guild (player_id VARCHAR(30) BINARY, guild_name VARCHAR(30) BINARY)
BEGIN
	UPDATE player
	SET gno = (
		SELECT gno
		FROM guild
		WHERE guild.name = guild_name
	)
	WHERE id = player_id AND gno IS NULL;
	COMMIT;
	SELECT id, gno
	FROM player
	WHERE id = player_id;
END;
​
CALL signing_up_guild('10점만점', '오직전투');
​


-- 7. 같이 게임하려고 길드를 만들었는데......사람이 너무 안 모입니다. 현생도 솔로인데 길드에서조차 혼자 있고 싶지 않아요! 탈퇴하고 다른 길드에 들어가야 할 것 같습니다.
-- player id를 이용해 가입 되어 있는 길드에서 탈퇴합니다.
-- Procedure, Update 활용해주세요.
DROP PROCEDURE IF EXISTS leaving_guild;
​
CREATE PROCEDURE leaving_guild (player_id VARCHAR(30) BINARY)
BEGIN
	UPDATE player
	SET gno = NULL
	WHERE id = player_id AND gno IS NOT NULL;
	COMMIT;
	SELECT id, gno
	FROM player
	WHERE id = player_id;
END;
​
CALL leaving_guild('10점만점');


-- 7-2. 알고보니 친구가 '오직전투'라는 길드에서 활동하고 있다고 합니다. 커뮤니티를 검색해 보니, 평판이 나쁘지 않습니다. 친구 따라서 '오직전투' 길드에 가입해보죠.
-- CALL signing_up_guild('10점만점', '오직전투');


-- 8. '오직전투' 길드에서 길드원 모집을 하고 있네요. 친구가 조건에 맞는 유저들에게 쪽지라도 보내보는 게 어떻냐고 합니다. 조건에 맞는 유저를 찾아봅시다.
-- -- 길드가 원하는 직업과 최소 레벨 조건을 충족하는, 길드가 없는 플레이어를 검색합니다.
-- Procedure 활용

DROP PROCEDURE IF EXISTS find_new_member;
​
CREATE PROCEDURE find_new_member(player_job VARCHAR(10), player_lev SMALLINT)
BEGIN
	SELECT id, job, lev
	FROM player
	WHERE job = player_job 
		AND lev >= player_lev
		AND gno IS NULL;
END;
​
CALL find_new_member('성직자', 100);

-- 9. 길드 평균 전투력
-- 길드장님이 길드원이 많이 모였다며 레이드를 가자고 합니다.
-- 길드 레이드는 길드원들의 평균 전투력에 따라 도전 가능한 레이드가 다릅니다.
-- 길드에 맞는 레이드를 추천하기 위해 길드원들의 평균 전투력을 검색해주세요.
-- Join, Group By, Order By 활용

SELECT name AS '길드명', AVG(str) AS '길드원 평균 전투력'
FROM player P, guild G
WHERE P.gno = G.gno
GROUP BY P.gno
ORDER BY AVG(str) DESC;

-- 10. 길드원들과 함께 레이드를 돌았지만, 아무래도 버스(무임승차)를 탄 기분만 듭니다. 길드장님께서 초보자 던전에라도 다녀오라고 하시는군요.
-- 초보자용 던전은 100레벨 이하의 플레이어만 입장할 수 있습니다.
-- 던전을 공략하기 위해서는 최소 4명이 있어야 하며, 전사와 성직자는 반드시 포함되어야 합니다.
-- 시간이 많이 없는 당신을 위해 500cash짜리 즉시 매칭권을 판매하고 있습니다. 즉시 매칭권을 사용하면 현재 접속해 있지 않더라도 조건에 해당하는 캐릭터와 함께 던전에 들어갈 수 있습니다.
-- 최단시간에 공략할 수 있게끔 파티원을 검색해 봅시다! 
​-- update player set cash = cash+500 where id =''

select * from player where lev<=100 order by job;
select * from player;

-- 10-1. 던전 공략에 성공했습니다. level이 5 상승, 전투력이 500 상승했습니다. update 구문을 통해 해당 id의 레벨을 5, 전투력을 500 올려주세요!
update player set str = str+500 where id = '용사짱';
update player set lev = lev+5 where id = '용사짱';


-- 11. 공략하고 나니 밑에 반짝이며 광고 문구가 보입니다. 모든 던전은 3000cash만 결제하면 해당 던전에서 얻은 전투력을 2배로 상승시켜 준다고 합니다. 
-- 결제하고 전투력을 상승시키는 프로시저를 생성해봅시다. 
-- update문을 사용하고, id, 획득한 전투력(int)을 파라미터로 받아주세요.
​

DROP PROCEDURE IF EXISTS chargestr;
delimiter //
create procedure chargestr (v_id VARCHAR(10), v_str int)
begin
 update player set cash = cash+3000 where id = v_id;
 update player set str = str+ (v_str*2) where id = v_id;
end//
delimiter ;

-- 11-1 id와 아까 얻은 500전투력을 입력하여 프로시저를 실행시켜 봅시다.
call chargestr('용사짱', 500);
-- 11-2 얼마나 올랐는지 확인해 볼까요?
select id, lev, str, cash from player where id = '';


-- 12. 이제 자신감이 붙었습니다. 던전도 좋지만, 역시 게임의 꽃은 타 유저들간의 전투, PVP죠! 
-- PVP 매칭을 하려고 합니다. 특정 유저의 전투력을 바탕으로 +1000, -1000까지의 매칭을 시도합니다.
--  유저가 특정 직업과 매칭을 원하지 않는 경우 해당 직업을 제외하고 PVP매칭을 할 수 있도록 리스트를 만들어 주세요.
--      조건 1. 검색을 실행하는 유저 id와 매칭을 원하지 않는 특정 직업을 parameter 인자를 받도록 합니다.
--      조건 2. 매칭 직업이 상관없다면 parameter 값으로 '없음'을 설정.
--      조건 3. 캐릭별 대표 id(rid)가 검색을 실행하는 유저의 rid 와 같을 경우 제외
DROP PROCEDURE IF EXISTS pvp_matching;
delimiter //
CREATE PROCEDURE pvp_matching(player_id varchar(30) BINARY, player_job varchar(10))
BEGIN
    IF player_job = '없음' THEN 
        SELECT id, rid, job, str
        FROM player 
        WHERE str 
            BETWEEN (SELECT str FROM player WHERE id=player_id) - 1000 
                AND (SELECT str FROM player WHERE id=player_id) + 1000 
            AND rid NOT IN (SELECT rid FROM player WHERE id = player_id)
        ORDER BY str DESC;
    
    ELSEIF player_job IN ('궁수', '마법사', '전사', '성직자', '암살자') THEN 
        SELECT id, rid, job, str
        FROM player 
        WHERE str 
            BETWEEN (SELECT str FROM player WHERE id=player_id) - 1000 
                AND (SELECT str FROM player WHERE id=player_id) + 1000 
            AND rid NOT IN (SELECT rid FROM player WHERE id = player_id)
            AND job != player_job
        ORDER BY str DESC;
    END IF;
END //
delimiter ;

-- 13. PVP 보상으로 전투력을 상승시켜주는 길드 버프를 받았습니다! 당신이 속한 길드의 길드원들의 전투력이 1.2배 오르도록 select문을 사용하여 예상 전투력을 출력해주세요.
-- (서브 쿼리 사용)
select str*1.2 as '길드버프 활성시 예상전투력', gno, id
from player
where gno = (
select gno from player where id = '빅토르'); 

-- 14. 같이 게임하던 친구가 부캐(추가로 생성한 캐릭터)를 키우러 가겠다며 가버렸습니다. 친구 부캐 이름을 검색해서 찾아내야겠습니다.
-- (대표 아이디(rid)를 사용해서 친구의 모든 id를 검색하는 프로시저를 만들어주세요.)
-- 만드려는 프로시저 이름 : friend_group 
SELECT DISTINCT rid FROM player;
DROP PROCEDURE IF EXISTS friend_group;
delimiter //
CREATE PROCEDURE friend_group(player_rid varchar(30) BINARY)
BEGIN 
    SELECT id 
    FROM player
    WHERE rid = player_rid;
END //
delimiter ;
CALL FRIEND_GROUP('빅토르'); 

-- 15. 검색하다 보니 눈쌀이 찌푸려지는 이름들이 많습니다. '성기'가 들어간 닉네임에게서 쪽지가 오지 않도록 차단해버려야겠습니다.
-- id에 '성기'가 들어간 유저를 friendtb에서 지워 주세요.

-- tb 기본문
CREATE TABLE friendtb AS SELECT * FROM player;
ALTER TABLE friendtb DROP COLUMN rid;
ALTER TABLE friendtb DROP COLUMN create_date;
ALTER TABLE friendtb DROP COLUMN cash;


delete from friendtb where id like '%성기%'; -- 애꿎은 '성기사있으면던짐' 정보가 목록에서 삭제됨.
select * from friendtb;

-- 16. 누적 캐시 페이백 보상으로 선물상자 이벤트가 열렸습니다! 과연 어떤 선물을 받게 될까요? case문을 사용하여 조건에 따라 다른 선물상자를 받을 수 있게 해주세요. 
SELECT rid,
	CASE
		WHEN SUM(cash) BETWEEN 0 AND 99000 THEN '평범한 선물상자'
		WHEN SUM(cash) BETWEEN 100000 AND 990000 THEN '동 선물상자'
		WHEN SUM(cash) BETWEEN 1000000 AND 4990000 THEN '은 선물상자'
		WHEN SUM(cash) BETWEEN 5000000 AND 9990000 THEN '금 선물상자'
		WHEN SUM(cash) BETWEEN 10000000 AND 19990000 THEN '플래티넘 선물상자'
		WHEN SUM(cash) >= 20000000 THEN '다이아 선물상자'
	END AS '이벤트 선물상자'
FROM player
GROUP BY rid
ORDER BY SUM(cash) DESC;

-- 17. 복귀 이벤트도 함께 열렸습니다. 혹시 친구가 복귀 이벤트 대상자일지도 모르잖아요? 대상자를 확인해 봅시다.
--  휴면 계정 처리(오늘 날짜에서 마지막 접속일자와의 차가 3달 이상인 경우, 휴면계정으로 처리합니다.)
--  3달 이상 6달 미만인 경우 접속시 복귀 이벤트를 받습니다. 받을 수 있는 player id를 찾아주세요.
--  6달 이상인 경우 접속시 플래티넘 복귀 이벤트를 받습니다. 받을 수 있는 player id를 찾아주세요.
SELECT id, last_date AS '최종 접속일', TIMESTAMPDIFF(MONTH, last_date, curdate()) AS '마지막 접속일로부터 경과시간(month)',
    CASE 
        WHEN TIMESTAMPDIFF(MONTH, last_date, curdate()) BETWEEN 3 AND 5 THEN '복귀 이벤트 대상자    '
        WHEN TIMESTAMPDIFF(MONTH, last_date, curdate()) >= 6 THEN '플래티넘 복귀 이벤트 대상자'
        ELSE 'X'
    END AS '복귀 이벤트 대상 확인'
FROM player 
ORDER BY 3 DESC;


-- 18. 친구가 자꾸 '전사' 유저가 너무 많다며, 레이드 매칭이 잘 되지 않아 실직하게 생겼다고 합니다. 성직자는 여자가 많을 것 같다며 성직자로 직업 변경을 고민하고 있는데요, 
-- 전체 캐릭터 중 직업별, 성별로 차지하는 비율을 구해봅시다. 
SELECT job AS 직업, count(*) AS '직업별 총 인원수',
    count(CASE WHEN sex='M' THEN 1 end) AS '남자 수',
    count(CASE WHEN sex='F' THEN 1 END) AS '여자 수',
    round((count(*)/(SELECT count(*) FROM player))*100, 1) AS '직업별 비율'
    FROM player 
    GROUP BY job 
    ORDER BY 5 DESC;
   





