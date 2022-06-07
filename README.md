# SqlMiniDB
### -sql문 사용해서 MMORPG용 데이터베이스 구현하고 질의하기






## discription

- MMORPG의 database를 작게 구현하여 그 안에서 필요한 기능들을 mysql로 작성
- 캐릭터 생성, 길드 가입/탈퇴, Lev 및 전투력 상승, 조건검색 기능 구현 
- DDL, DML, join, subquery, procedure, trigger 등 복합 기능 사용
- 순차적 시나리오 실행을 통한 게임 데이터 생성 및 수정
- query를 작성하며 명령어 학습 의의



### example
> <MMORPG '엔코아연대기'에 들어오신 걸 환영합니다!>
> <이름, 직업(전사/궁수/마법사/성직자/암살자 택1), 캐릭터 성별(F/M), 플레이어 id를 적어 캐릭터를 생성해주세요!>
다음 문장을 사용하세요: INSERT INTO player (id, job, sex, fid, create_date, last date) VALUES (, , , ,curdate(), curdate());...




주어진 상황과 조건에 맞게 SQL문을 작성합니다.

## Tech

- [DBeaver 22.0.5] - Editing sql conviniently
- [MySQL Workbench] - Testing sql query

## Files

- scenario_mysql.sql

    ```bash
📦 Databases
└─ playdata
   ├─ Tables
   │  ├─ guild
   │  └─ player
   ├─ Procedures
   │  ├─ auto_charge
   │  ├─ create_guild
   │  ├─ find_friend
   │  ├─ find_new_member
   │  ├─ leaving_guild
   │  ├─ level_up
   │  ├─ purchase_item
   │  ├─ pvp_matching
   │  └─ signing_up_guild
   └─ Trigger
      └─ player.new_player_event
```
©generated by [Project Tree Generator](https://woochanleee.github.io/project-tree-generator)









## 코드 예제

충전 프로시저: 
id를 입력받아 실행할 때마다 자동으로 5000 cash씩 충전해주는 프로시저를 작성해 주세요. 프로시저를 시행하면 전투력(str)이 5000/(플레이어레벨)*5)만큼 상승합니다.

drop procedure autocharge;
delimiter //
create procedure autocharge (v_id VARCHAR(10))
begin
 update player set cash = cash+5000 where id = v_id;
 update player set str = str+5000/((player.lev)*5) where id = v_id;
end//
delimiter ;

## contributer
2022.06.07
**박재민, 유예지, 윤홍찬**



## 설명
이 프로젝트는 MMORPG의 db를 작게 구현하여 그 안에 필요한 테이블과 기능들을 MySQL을 활용해 구현해보는 프로젝트입니다.

## 목표
* MySQL의 DDL을 활용해 필요한 table을 생성합니다.
* MySQL의 DML, TCL을 활용해 필요한 기능들을 구현합니다.
* MySQL의 function, procedure, trigger를 활용해 필요한 기능들을 구현합니다


## Tech Stack
<img src="https://img.shields.io/badge/mysql-4479A1?style=for-the-badge&logo=mysql&logoColor=white">
<img src="https://img.shields.io/badge/dbeaver-003B57?style=for-the-badge&logo=dbeaver&logoColor=white">

## Project Configuration
```bash
📦 Databases
└─ playdata
   ├─ Tables
   │  ├─ guild
   │  └─ player
   ├─ Procedures
   │  ├─ auto_charge
   │  ├─ create_guild
   │  ├─ find_friend
   │  ├─ find_new_member
   │  ├─ leaving_guild
   │  ├─ level_up
   │  ├─ purchase_item
   │  ├─ pvp_matching
   │  └─ signing_up_guild
   └─ Trigger
      └─ player.new_player_event
```
©generated by [Project Tree Generator](https://woochanleee.github.io/project-tree-generator)

## Files
* scenarios_mysql.sql


### scenarios_mysql.sql
guild table과 player table을 생성하며, data를 삽입하는 insert문 작성되어 있습니다. 아래는 guild table과 player table의 예시입니다.

* guild table
```sql
-- 길드 테이블 생성
CREATE TABLE guild(
-- column 정의
	gno		INT AUTO_INCREMENT,	-- 길드 번호, PK
	name		VARCHAR(10),		-- 길드명
	tend		VARCHAR(10),		-- 성향, 전투/생활/친목
	reg		VARCHAR(10),		-- 활동 지역, 북부/서부/동부/남부/중앙
	lev		SMALLINT,		-- LEVEL
	create_date	DATE,			-- 생성 일
-- pk 정의
	CONSTRAINT pk_gno_guild PRIMARY KEY (gno)
);
```

* player table
```sql
-- 플레이어 테이블 생성
CREATE TABLE player(
-- column 정의
	id		VARCHAR(10),	-- 플레이어 캐릭터 id, PK
	gno		INT,		-- 길드 번호, FK
	job 		VARCHAR(10),	-- 직업, 전사/궁수/마법사/성직자/암살자
	lev		SMALLINT,	-- LEVEL
	str		INT,		-- 전투력
	sex		VARCHAR(1),	-- 성벌(M, F)
	rid		VARCHAR(10),	-- 대표 플레어이 캐릭터 id
	create_date	DATE,		-- 캐릭터 생성 일
	last_date	DATE,		-- 최근 접속일
	cash		int,		-- 누적 결제 금액
-- pk, fk 정의
	CONSTRAINT pk_id_adventurer PRIMARY KEY (id),
	CONSTRAINT fk_gno_adventurer FOREIGN KEY (gno) REFERENCES guild(gno)
);
```


충전 프로시저: 
id를 입력받아 실행할 때마다 자동으로 5000 cash씩 충전해주는 프로시저를 작성해 주세요. 프로시저를 시행하면 전투력(str)이 5000/(플레이어레벨)*5)만큼 상승합니다.
```sql


drop procedure autocharge;
delimiter //
create procedure autocharge (v_id VARCHAR(10))
begin
 update player set cash = cash+5000 where id = v_id;
 update player set str = str+5000/((player.lev)*5) where id = v_id;
end//
delimiter ;
```

```sql
-- Procedure 실행
call autocharge('용사짱');
```


## Contributors
* 박재민
* 윤홍찬
* 유예지
