ROWNUM : 1부터 읽어야 된다.
        SELECT 절이 ORDER BY 절보다 먼저 실행 된다.
            ==> ROWNUM을 이용하여 순서를 부여 하려면 정렬부터 해야된다.
                ==>인라인뷰INLINE-VIEW ( ORDER BY - ROWNUM을 분리)
        
데이터 정렬[가상컬럼 ROWNUM 실습 row_1]
--emp 테이블에서 ROWNUM 값이 1~10인 값만 조회하는 쿼리를 작성해보세요(정렬없이 진행,결과는 화면과 다를 수 있음)
SELECT *
FROM emp;

SELECT ROWNUM rn, empno, ename
FROM emp --칼럼 구성
WHERE ROWNUM <= 10; --10번으로 제한

데이터 정렬[가상컬럼 ROWNUM 실습 row_2]
--ROWNUM 값이 11~20(11~14)인 값만 조회하는 쿼리
SELECT *
FROM(SELECT ROWNUM rn, a.*
    FROM (SELECT empno, ename
          FROM emp
          ORDER BY ename) a)
WHERE rn BETWEEN (:page -1) * :pageSize + 1 AND :page * :pageSize;

SELECT *
FROM (SELECT ROWNUM rn, empno, ename
        FROM emp)
WHERE rn >= 11 AND rn <= 20;

데이터 정렬[가상컬럼 ROWNUM 실습 row_3]
--emp 테이블의 사원 정보를 이름컬럼으로 오름차순 적용 했을 때의 11~14번째 행을 다음과 같이 조회하는 쿼리
--  1.정렬기준 : ORDER BY ename ASC;
--  2.페이지 사이즈 : 11~20(페이지당 10건)
SELECT *
FROM(SELECT ROWNUM rn, empno, ename --empno,ename => a.*
        FROM (SELECT empno, ename
        FROM emp
        ORDER BY ename ASC)) -- ASC)뒤에 a )를 사용해주면 된다.
WHERE rn > 10 AND rn <=20;


-- Function 함수
-- Single row function : 1.단일 행을 기준으로 작업, 행당 하나의 결과를 반환
--                       2.특정 컬럼의 문자열 길이 : length(ename)
-- Multi row function : 1.여러행을 기준으로 작업, 하나의 결과를 반환
--                      2.그룹함수 (count, sum, avg)

-- character[1.SQL활용 PART! p126~p131]
--  1. 대소문자 : LOWER(소문자) / UPPER(대문자) / INITCAP(권고사항, 첫글자 대문자)
--  2. 문자열 조작 : CONCAT(문자열 결합) /SUBSTR(문자열 일부분 추출) / LENGTH(문자열 길이)
--                 INS TR(조사하고 싶은 문자열 검사) / LPAD|RPAD(오/왼체워넣다) / TEIM(공백) / REPLACE(다른문자열 치환)

ORACLE 함수 분류
1.  SINGLE ROW FUNCTION : 단일 행을 작업의 기준, 겨로가도 한건 반환
2.  MULTI ROW FUNCTION : 여러 행을 작업의 기준, 하나의 행을 결과로 반환

dual 테이블
    1. sys 계정에 존재하는 누구나 사용할 수 있는 테이블
    2. 테이블에는 하나의 컬럼, dummy 존재, 값은 x
    3. 하나의 행만 존재
        ******** SINGLE
        
--LENGTH(ename)/문자열길이
SELECT empno, ename, LENGTH(ename),LENGTH('hello') 
FROM emp;

SELECT LENGTH('hello')
FROM dual;
    
sql 칠거지악
1.좌변을 가공하지 말아라(테이블 컬럼에 함수를 사용하지 말것)
    . 함수 실행 횟수
    . 인덱스 사용관련(추후에)
    
SELECT ename, LOWER(ename)
FROM emp
WHERE LOWER(ename) = 'smith'; --LOWER(ename)칼럼..14번(행의횟수) 실행 오류(바른 사용법x)

SELECT ename, LOWER(ename)
FROM emp
WHERE ename = 'SMITH';

--문자열 관련함수[1.sql활용 PART1 p134 참고]
SELECT CONCAT('Hello', ', World') concat, --문자열 결합(CONCAT('',''))
        SUBSTR('Hello, World', 1,5) substr, --문자열 일부분 추출(SUBSTR('', *,*) ==>Hello만 출력
        SUBSTR('Hello, World', 5) substr2, --o, World 출력
        LENGTH('Hello, World') length, --문자열 길이 'Hello, World' 12자
        INSTR('Hello, World' , 'W') instr, -- 문자열에 특정 문자열이 들어있는지 확인 ==>'W' 8번째
        INSTR('Hello, World' , 'o', 6) instr2, -- ('o', 6) 6번째 이후에 오는 o가 몇번째인가=> 9번째
        INSTR('Hello, World' , 'o', INSTR('Hello, World', 'o') +1 ) instr3, --instr2와같은 결과 좀더 세련된 방식이면서 주된 사용방법
        LPAD('Hello, World' , 15, '*') lapd, --문자열 왼쪽에 삽입 총 15자리중 빈자리 왼쪽에 *를 채운다
        LPAD('Hello, World' , 15) lapd2, -- *대신 공백
        RPAD('Hello, World', 15, '*') rpad, --문자열 오른쪽 삽입 LPAD와 반대
        RPAD('Hello, World', 15) rpad2,
        REPLACE('Hello, World' , 'Hello', 'Hell') replac, --문자열 치환 'Hello -> Hell'
        TRIM('Hello, World') trim, --문자열 공백,혹은 특정 문자 제거
        TRIM('    Hello, World    ') trim2 --공백
        TRIM('H' FROM 'Hello, World') trim3 --특정 문자 제거
FROM dual;

--숫자관련 함수
--number:  (숫자조작)
--          1. ROUND : 반올림 함수
--          2. TRUNC : 버림 함수(내림)
--                  ==> 몇번째 자리에서 반올림, 버림을 할지?
--                     두번째 인자가 0, 양수: ROUND(숫자, 반올림자리) 105.54 // 소수점 .이 기준으로 0 -> .54 :양수1,2 / 105. -> 음수-3,-2,-1
--                     두번째 인자가 음수 : ROUND(숫자, 반올림 해야되는 위치)
--          3. MOD :  나머지를 구하는 함수(나눗셈의 나머지)

--ROUND 반올림 함수
SELECT ROUND(105.54, 1) round, --소수점 둘째자리에서 반올림
        ROUND(105.55, 1) round2,
        ROUND(105.55, 0) round3, --소수점 첫째자리에서 반올림
        ROUND(105.55, -1) round4 --정수 첫째자리에서 반올림        
FROM dual;
--TRUNC 절삭 함수
SELECT TRUNC(105.54, 1) trunc, --소수점 둘째자리에서 절삭
        TRUNC(105.55, 1) trunc2,
        TRUNC(105.55, 0) trunc3, --소수점 첫째자리에서 절삭
        TRUNC(105.55, -1) trunc4 --정수 첫째자리에서 절삭        
FROM dual;
--mod 나머지 구하는 함수
--피제수 - 나눔을 당하는 수 , 제수 - 나누는 수
-- a/b=c => a:피제수, b:제수
--10을 3으로 나눴을 때의 몫을 구하기
SELECT mod(10,3)
FROM dual;

SELECT ROUND(10/3 , 0) round,
    --round를 사용시 값이 올라갈수도잇다(ex,3.6~ =>4) //상황에 맞게 round /trunc를 사용해야된다 
        TRUNC(10/3, 0) trunc
FROM dual;


--날짜관련 함수
--문자열 ==> 날짜 타입 TO_DATE
SYSDATE : 오라클 서버의 현재 날짜, 시간을 돌려주는 특수 함수
            함수의 인자가 없다(java void test(){ } test()  => SYSDATE;로사용

SELECT SYSDATE
FROM dual;

날짜 타입 +- 정수 : 날짜에서 정수만큼 더한(뺀) 날짜
하루 = 24
1일 = 24h , 1/24일 = 1h , 1/24일/60 = 1m , 1/24일/60/60 = 1s
emp hiredate +5, -5

SELECT SYSDATE, SYSDATE +5, SYSDATE -5
FROM dual;

SELECT SYSDATE, SYSDATE +5, SYSDATE -5,
        SYSDATE + 1/24, SYSDATE + 1/24/60
FROM dual;


[Function(date 실습 fn1)]
1. 2019년 12월 31일 date 형으로 표현
2. 2019년 12월 31일 date 형으로 표현하고자 5일 이전 날짜
3. 현재 날짜
4. 현재 날짜에 3일 전값
SELECT TO_DATE('2019/12/31' , 'yyyy/mm/dd') lasrday, --2019년12월31일 날짜
        TO_DATE('2019/12/31' , 'yyyy/mm/dd')-5 lastday_before5, --2019년12월31일 5일전날짜
        SYSDATE  now, --현재 날짜
        SYSDATE -3 now_before3 --현재 날짜-3일  //now_before3(_사용 안할시 "now before3"사용) 그냥 띄어쓰면 별칭 2개로 인식
FROM dual;

날짜를 어떻게 표현할까
java : java.util.Date
sql : ns1 포맷에 설정된 문자열 형싱을 따르거나 ==> 툴 때문일수도 있음 예측하기 힘듬
    TO_DATE 함수를 이용하여 명확하게 명시
    TO_DATE('날짜 문자열', '날짜 문자열 형식')