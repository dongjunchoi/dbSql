--16진수
-- : 0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F

--date
--  형변환(DATE -> CHARACTER) : TO_CHAR(DATE, '포맷')
--  형변환(CHARACTER -> DAtE) : TO_DATE(날자 문자열 ,'포맷')

--날짜 데이터 : emp.huredate / SYSDATE 
--TO_CHAR(날짜타입, '변경할 문자열 포맷')
--TO_DATE('날짜문자열', '첫번째 인자의 날짜 포맷')
--TO_CHAR, TO_DATE 첫번째 인자 값을 넣을 때 문자열인지/날짜인지 구분!

--현재 설정된 NLS DATE FORMAT : YYYY/MM/DD/ HH24:MI:SS
--YYYY(년도)/MM(월)/DD(일)/IW(주차1~53)/HH24(시간),HH,HH12(2자리 시간(12시간 표현)/MI(분)/SS(초)

SELECT SYSDATE, TO_CHAR(SYSDATE, 'DD-MM-YYYY')
FROM dual;

SELECT SYSDATE, TO_CHAR(SYSDATE, 'DD-MM-YYYY'), TO_CHAR(SYSDATE, 'D'),
                TO_CHAR(SYSDATE, 'IW')
FROM dual;

--'20200908' ==> '2020/09/08'

SELECT ename, hiredate, TO_CHAR(hiredate, 'yyyy/mm/dd hh24:mi:ss') h1,
        TO_CHAR(hiredate+1, 'yyyy/mm/dd hh24:mi:ss') h2,
        TO_CHAR(hiredate+1/24, 'yyyy/mm/dd hh24:mi:ss') h3,
        TO_CHAR(TO_DATE('20200908', 'yyyymmdd'), 'yyyy/mm/dd') h4
        --SUBSTR('20200908', 1,4) || '/' || SUBSTR('20200908', 5,2)'/' || SUBSTR('20200908', 7,2)
FROM emp;

--날짜: 일자+시분초 2020년9월8일 14시 10분 8초 ==>'20200908' ==>2020년9월8일

SELECT TO_CHAR(SYSDATE, 'yyyymmdd') -- 시분초를 날려버리기 위해 사용
FROM dual;


--[Function(date 실습 fn2)]
--오늘 날짜를 다음과 같은 포맷으로 조회
-- 1. 년-월-일 / 2. 년-월-일 시간(24)-분-초 / 3. 일-월-년
SELECT TO_CHAR(SYSDATE, 'yyyy-mm-dd') dt_dash,
        TO_CHAR(SYSDATE, 'yyyy-mm-dd hh24-mi-ss') dt_dash_with_time,
        TO_CHAR(SYSDATE, 'dd-mm-yyyy') dt_dd_mm_yyyy
FROM dual;

--날짜 조작함수(*는 사용빈도)
--MONTHS_BETWEEN(DATE1, DATE2) : 두 날짜의 사이의 개월수(두 날짜의 일정보가 틀리면 소수점이 나오기 떄문에 잘 사용하지 않는다)
--***ADD_MONTHS(DATE, NUMBER) : NUMBER개월 이후의 날짜(주어진 날짜에 개월수를 더하거나 뺀 날짜를 변환)
--                        (한달이라는 기간이 월마다 다름 - 직접 구현이 힘듬)
--**NEXT_DAT(DATE, NUMBER(주간요일:1~7)): DATE이후에 등장하는 첫번째 주간요일을 갖는 날짜
--    NEXT_DAT(DATE, 6) : SYSDATE(2020/09/08)이 후에 등장하는 첫번째 금요일에 해당하는 날짜
--*****LAST_DAY(DATE) : 주어진 날짜가 속한 월의 마지막 일자를 날짜로 변환
--      LAST_DAY(SYSDATE) : SYSDATE(2020/09/08)가 속한 9월의 마지말 날짜 : 2020/09/30
--              (월마다 마지막 일자가 다르기 때문에 해당 함수를 통해서 편하게 마지막 일자를 구할 수 있다.)

--해당월의 가장 첫 날짜를 반환하는 함수는 없다!==>모든 월의 첫날짜는 1일로 정해져 있기때문이다
SELECT MONTHS_BETWEEN(TO_DATE('20200915', 'yyyymmdd'), TO_DATE('20200808','yyyymmdd')),
                                        --일자가 정확이 떨어지지 않기때문에 사용x(1.22...)
        ADD_MONTHS(SYSDATE, 5), --오늘날짜로부터 5개월 뒤의 날짜는 몇일인가LECT ADD_MONTHS(SYSDATE, 5)
        NEXT_DAY(SYSDATE, 6), 
        LAST_DAY(SYSDATE)    --오늘 날짜가 속한 9월의 마지말 날짜 : 2020/09/30
FROM dual;

--SYSDATE가 속한 월의 첫날짜 구하기(2020년9월8일 ==> 2020년9월1일의 날짜 타입 어떻게든 구하기)
SELECT  TO_CHAR(SYSDATE, 'yyyymmdd') - TO_CHAR(SYSDATE, 'dd') +1 d1,
        TO_DATE(TO_CHAR(SYSDATE, 'yyyymm') || '01', 'yyyymmdd') d2,
        TO_DATE('01' , 'dd') d3, --참고!(SYSDATE사용x)
        --오늘 날짜를 -> 월의 마지막 날짜로 바꾸기 -> 한달전으로 돌아가기->날짜 하루 더하기
        --SYSDATE->LAST_DAY->ADD_MONHTS->+1(20200908->20200930->20200831->)
        ADD_MONTHS(LAST_DAY(SYSDATE), -1) +1 d4,
        --오늘날짜에서 일자구하기->오늘날짜-구한일짜 +1(SYSDATE -8 ==> 20200831 +1 ==>20200901
        SYSDATE - TO_CHAR(SYSDATE, 'dd')+1 d5
FROM dual;
--[Function(date 실습 fn3)]
--파라미터로 yyyymm형식의 문자열을 사용하여 (ex: yyyymm =201912)해당 년월에 해당하는 일자 수를 구하세요

--주어진것:년월 문자열=>날짜로변경=>해당월의마지막 날짜로변경
SELECT :yyyymm param, TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')),'dd') dt
FROM dual;

--**형변환**
-- 명시적 형변환
--    TO_CHAR, TO_DATE, TO_NUMBER
-- 묵시적 형변환
--    ......ORACLE DBMS가 상황에 맞게 알아서 해주는 것

--두가지 가능 한 경우
--  1. empno(숫자)를 문자로 묵시적 형변환
--  2. '7369'(문자)를 숫자로 묵시적 형변환

--(알면 매우 좋음, 몰라도 수업 진행 문제x, 추후 취업해서도 큰 지장x,
--                      다만 고급 개발자 와 일반 개발자를 구분하는 차이점이됨)
--실행계획: 오리클에서 요청받은 SQL을 처리하기 위한 절차를 수립한 것
--실행계획 보는 방법
--  1.EXPLAIN PLAN FOR 실행계획을 분석한 sql
--  2. SELECT * FROM TABLE(dbms_xplan.display);

--실행계획의 operation을 해석하는 방법
--  1.위에서 아래로
--  2.단, 자식노드(들여쓰기가 된 노드)있는 경우 자식부터 실행하고 본인 노드 실행

EXPLAIN PLAN FOR
SELECT *
FROM emp
--WHERE empno LIKE '78%';
WHERE empno = '7369';
--   == filter("EMPNO"=7369)

--TABLE 함수 : PL/SQL의 테이블 타입 자료형을 테이블로 변환
SELECT *
FROM TABLE(dbms_xplan.display);

--java의 class full name : 패키지명,클래스명
--java : String class : java.lang.String == (dbms_xplan.display)

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';
--   == filter(TO_CHAR("EMPNO")='7369') 

SELECT *
FROM TABLE(dbms_xplan.display);

--잘 사용하지 않음
--sal (1600) -> 1,600
SELECT empno, ename, sal
FROM emp;
--숫자를 문자로 포맷팅 : DB보다는 국제화(i18n) Internationalization에서 더 많이 활용
SELECT empno, ename, sal, TO_CHAR(sal, '9,999'), --1000단위에 ,
        TO_CHAR(sal, '9,999L') , --원표시
        TO_CHAR(sal, '009,999')  -- 강제 00추가
FROM emp;

--함수(정리복습)
--    문자열
--    날짜
--    숫자
--    null과 관련된 함수 : 4가지 (다 못외워도 괜찮음, 한가지를 주로사용)
--          (ex : 오라클의 NVL 함수와 동일한 역활을 하는 MS-SQL SERVER의 함수이름?)
--      null의 의미? 아직 모르는 값, 할당되지 않은 값 (0과, ''(공백)문자와는 다르다)
--      null의 특징 : NULL을 포함한 연산의 결과는 항상 NULL이다

--ex: sal 컬럼에는 null이 없지만, comm에는 4개의 행을 제외하고 10개의 행이 null값을 갖는다.
SELECT ename, sal, comm, sal+comm
FROM emp;
--NULL과 관련된 함수
--   1.NVL(컬럼 || 익스프레션, 컬럼 || 익스프레션)
--      NVL(expr1, expr2)

--java:
    if(expr1 == null){
        System.out.println(expr2); --return expr2;
    }else{
        System.out.println(expr1);
    }
--위의 내용을 실행 시켜본 결과--
SELECT empno, comm, NVL(comm, 0) --NVL(comm, 0) : comm의 null의 값을 0으로 치환시켜준다.
FROM emp;

SELECT empno, comm, sal, sal + comm, sal + NVL(comm, 0) 
FROM emp;

    