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

## Contents

- scenario_mysql.sql
    - tables:
        1) player: 
            - id(아이디)	
	gno	(길드번호)		
	job (직업)		
	lev	(레벨)		
	str	(전투력)		
	sex	(성별)
	rid	(운영계정)	 
	create_date	DATE, (생성일자)			
	last_date	DATE, (마지막 접속일자)		
	cash (결제금액)
        2) guild
            - gno	(길드번호)	
	name	(길드이름)	
	tend	(길드성향)	
	reg		(길드점령지)	
	lev		(길드레벨)
	create_date (길드창설일자)
    - fuctions:
                -플레이어 생성
    레벨업
    길드 생성/가입/탈퇴/검색
    플레이어 검색/차단
    pvp/pve 매칭
    선물/복귀 이벤트








## 코드 예제

충전 프로시저: 
id를 입력받아 실행할 때마다 자동으로 5000 cash씩 충전해주는 프로시저를 작성해 주세요. 프로시저를 시행하면 전투력(str)이 5000/(플레이어레벨)*5)만큼 상승합니다.

## contributer
2022.06.07
**박재민, 유예지, 윤홍찬**



[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [dill]: <https://github.com/joemccann/dillinger>
   [git-repo-url]: <https://github.com/joemccann/dillinger.git>
   [john gruber]: <http://daringfireball.net>
   [df1]: <http://daringfireball.net/projects/markdown/>
   [markdown-it]: <https://github.com/markdown-it/markdown-it>
   [Ace Editor]: <http://ace.ajax.org>
   [node.js]: <http://nodejs.org>
   [Twitter Bootstrap]: <http://twitter.github.com/bootstrap/>
   [jQuery]: <http://jquery.com>
   [@tjholowaychuk]: <http://twitter.com/tjholowaychuk>
   [express]: <http://expressjs.com>
   [AngularJS]: <http://angularjs.org>
   [Gulp]: <http://gulpjs.com>

   [PlDb]: <https://github.com/joemccann/dillinger/tree/master/plugins/dropbox/README.md>
   [PlGh]: <https://github.com/joemccann/dillinger/tree/master/plugins/github/README.md>
   [PlGd]: <https://github.com/joemccann/dillinger/tree/master/plugins/googledrive/README.md>
   [PlOd]: <https://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md>
   [PlMe]: <https://github.com/joemccann/dillinger/tree/master/plugins/medium/README.md>
   [PlGa]: <https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md>
