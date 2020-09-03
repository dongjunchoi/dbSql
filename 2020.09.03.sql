테이블의 구조(컬럼명, 데이터타입) 확인하는 방법
1. DESC 테이블명 : DESCRIBE
2. 컬럼 이름만 알 수 있는 방법(데이터 타입은 유추)
    SELSCT *
    FROM 테이블명;
3.툴에서 제공하는 메뉴 이용
    접속 정보 - 테이블 - 확인하고자 하는 테이블 클릭
    
SELECT empno, ename, sal
FROM emp;

SELECT 절 : 컬럼을 제한

*********************매우중요*********************************
WHERE 절 : 조건에 만족하는 행들만 조회되도록 제한 (행을 제한)
        ex) sal 컬럼의 값이 1500보다 큰 사람들만 조회 ==> 7명
WHERE절에 기술된 조건을 참(true)으로 만족하는 행들만 조회가 된다.(핵심!!)        

조건연산자
    동등 비교(equal)
        -- java : ==
        java : int = 5;
                primitive type : ==  ex) a == 5;
                object : "+".equals("-")
        --sql : =
        sql : sal =1500;
        
    not equal
        java : !=
        sql : !=, <>
    
    대입연산자
        java : =
        pl/sql :  :=
        
*조건에 맞는데이터 조회하기 (=)
--users테이블에는 총 5명의 캐릭터가 등록되어 있는데 그중에서 userid 컬럼의 값이 'brown'인 행만 조회되도록 WHERE절에 조건을 기술
SELECT userid, usernm, alias, reg_dt
FROM users
WHERE userid = 'brown';

--주위해야될 점
컬럼과 문자열 상수를 구분하여 사용해야된다.
SQL은 대소문자를 가리지 않는다 : 키워드, 테이블명, 컬럼명
데이터는 대소문자를 가린다.


--WHERE절에 기술된 조건을 참(true)으로 만족하는 행들만 조회가 된다.(핵심!!) 
SELECT userid, usernm, alias, reg_dt
FROM users
WHERE 1 = 1; --상수1 은 1과 같고, 참(true)이기 때문에 5번이 다 나오게 된다!
                --1=1과같지만 1=2는 다르기때문에 조건이 성립하지 않는다.따라서 값이 출력되지않음!
                
--emp테이블에서 부서번호가(deptno)가 30보다 크거나 같은 사원들만 조회. 컬럼은 모든컬럼 조회
SELECT *
FROM emp
WHERE deptno >= 30;

--날짜를 비교 (1982년 01월 01일 이후에 입사한 사람들만 조회(이름, 입사일자)
--dhiredate type : date
--문자 리터럴 표기법 : '문자열'
--숫자 리터럴 표기법 : 숫자
--날짜 리터럴 표기법 : 항상 정해진 표기법이 아니다.
--                   서버 설정 마다 다르다. (yy/mm/dd)
--                                   서양권: mm/dd/yy
--                                   한국 : yy/mm/dd    /확인방법 도구-환경설정-데이터베이스-NLS
--날짜 리터럴 결론 : 문자열 형태로 표현하는 것이 가능하나 서버설정마다 다르게 해석할 수 있기 때문에
--                    서버 설정과 관계없이 동일하게 해석할 수 있는 방법으로 사용(유지보수측면에서 좋다(TO_DATE))
--                  TO_DATE('날짜문자열' , '날짜문자열형식') : 문자열 => 날짜 타입으로 변경          

SELECT ename, hiredate
FROM emp
WHERE hiredate >= '82/01/01';

--년도 : yy / 월 : mm / 일 : dd
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01'.'');

'1982/11/12' => 82년도라는건 유추하나 11/12가 월인지 년이지는 알 수 없기때문에 위의''곳에 'yy/mm/dd'로 표시

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01','yy/mm/dd'); -- 날짜 표기시 yy/mm/dd => yy-mm-dd (/대신-를사용,다른걸 사용해도 된다)
--날짜 표기(년도)는 2자리(RR)로도 표현가능하나 4자리(YY)로표기하는게 좋다.(혼동방지)
--YYYY/MM/DD/HH24:MI:SS :년/월/일/시:분:초(오라클언어)

BEWEEN AND 연산자
WHERE 비교대상 BETWEEN 시작값 AND 종료값;
비교대상의 값이 시작값과 종료값 사이에 있을 때 참(true)으로 인식
(시작값과, 종료값을 포함하는  (비교대상 >= 시작값 ,비교대상 <= 종료값) --문법x 시작값과 종료값이 비교대상에 포함된다는걸 알려주는것)

emp테이블에서 sal 컬럼의 값이 1000이상 2000이하인 사람들의 모든 컬럼으 조회

SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

비교연산자를 이용한 풀이
SELECT *
FROM emp
WHERE sal >= 1000
      sql <= 2000;

[BETWEEN... AND... 실습 WHERE1]
--emp 테이블에서 입사 일자가 1982년 1월 1일 이후부터 1983년 01월 01일 이전의 사원의 ename, hiredate 데이터를 조회하는 쿼리를 작성
--    (단 연산자는 between을 사용한다.)

SELECT *
FROM emp
WHERE hiredate BETWEEN '1982/01/01' AND '1983/01/01';

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01' , 'YYYY/MM/DD') AND TO_DATE('1983/01/01' , 'YYYY/MM/DD');

[>=, >, <=, < 실습 WHERE2]

SELECT *
FROM ename, hiredate
WHERE hiredate >= TO_DATE('1982/01/01' , 'YYYY/MM/DD') AND
      hiredate <= TO_DATE('1983/01/01' , 'YYYY/MM/DD');

IN 연산자
특정 값이 집합(여러개의 값을 포함)에 포함되어 있는지 여부를 확인
WHERE 비교대상 IN(값1, 값2........)
  ==> 비교대상이 값1 이거나(=), 비교대상이 값2 이거나(=)
  
emp테이블에서 사원이 10번 부서 혹은 30번 부서에 속한 사원들 정보를 조회(모든컬럼)
  
SELECT *
FROM emp
WHERE deptno IN(10,30);

--AND ==> 그리고
--OR ==> 또는
--  조건1 AND 조건2 ==> 조건1과 조건2를 동시에 만족
--  조건1 OR 조건2 ==> 조건1을 만족하거나, 조건2를 만족하거나, 조건1과 조건2를 동시에 만족하거나

SELECT *
FROM emp
WHERE deptno = 10 OR
      deptno = 30;
      
[IN 실습 WHERE3]
--users 테이블에서 userid가 brown, cony, sally인 데이터를 다름과 같이 조회(IN 연산자 사용)/(userid,alias의 값)
SELECT *
FROM users;

SELECT userid "아이디", usernm "이름", alias "별명"
FROM users
WHERE userid IN('brown', 'cony', 'sally');

SELECT userid AS "아이디", usernm AS "이름", alias AS "별명"
FROM users
WHERE userid = 'brown' OR
      userid = 'cony' OR
      userid = 'sally';
      
LIKE 연산자 : 문자열 매칭
--  WHERE userid = 'brown'
--  userid가 b로 시작하는 캐릭터만 조회
--  % : 문자가 없거나, 여러개의 문자열
--  _ : 하나의 임의의 문자

SELECT *
FROM emp
WHERE ename LIKE 'S%'; --ename이 S로시작하는 사원

SELECT *
FROM emp
WHERE ename LIKE 'W___'; --ename이 W로 시작하고 이어서 3개의 글자가 있는 사원(_ _ _ :임의의 문자 3개)

[LIKE, %, _ 실습 WHERE4]
--member 테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 조회하는 쿼리를 작성
SELECT *
FROM member;

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신__'; --mem_name가 [신]으로 시작하고 이어서 (__)2개의 임의 글자가 오는 이름
                                --만약 외자인 사람이 있거나하면 검색이 안되기에 문제에서 제시하는 의도를 파악하는게 좋다.
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%'; --mem_name가 [신]으로 시작하는 이름

[LIKE, %, _ 실습 WHERE5]

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '이%' OR
      mem_name LIKE '%이' OR
      mem_name LIKE '%이%'; --'이%'+'%이'= ('%이%'): '이'가 들어간 모든 이름
--  '%이' : '이'로 끝나는 사람
--  '이%' : '이'로 시작하는 사람
--  '%이%' : 도중에 '이'가 있는 사람(이름에 '이'가 있는 모든 이름)
--  '__*' : __의 갯수와 위치에 따라 임의로 따라오는 문자... 



