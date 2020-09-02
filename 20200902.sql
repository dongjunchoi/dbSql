==SELECT 쿼리 문법==
alias 별칭/별명
SELECT * | {cloumn | expression [alias]}
FROM 테이블 이름;

SQL 실행 방법
1. 실행하려고 하는 SQL을 선택후 Ctrl + enter;
2. 실행려려는 SQL 구문에 커서를 위치시키고 Ctrl + enter;

SELECT *
FROM emp;

SELECT empno, ename
From emp;

SELECT *
FROM dept;


SQL 의 경우 KEY워드의 대소문자를 구분하지 않는다.
그래서 아래 SQL 은 정상적으로 실행된다.

select *
from DEPT;

Coding rule : 수업시간에는 keyword 는 대문자 그외(테이블명, 컬럼명) 소문자


[실습 select 1]
1. lprod 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
SELECT *
FROM lprod;

2. buyer 테이블에서 buyer_id, buyer_name 컬럼만 조회하는 쿼리를 작성하세요
SELECT buyer_id, buyer_name
FROM buyer;

3. cart 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
SELECT *
FROM cart;

4. member 테이블에서 mem_id, mem_pass, mem_name 컬럼만 조회하는 쿼리를 작성하세요
SELECT mem_id, mem_pass, mem_name
FROM member;

연산
SELECT 쿼리는 테이블의 데이터에 영향을 주지 않는다.
SELECT 쿼리를 잘못 작성 했다고 해서 데이터가 망가지지 않는다.

SELECT *
FROM emp;

SELECT ename, sal, sal +100
FROM emp;

데이터 타입
DESC 테이블명(테이블 구조를 확인)

DESC emp;

숫자 + 숫자 = 숫자값(예: 5 + 6 = 11)
문자 + 문자 = 문자 ==> java에서는 문자열을 이은, 문자열 결합으로 처리
수학적으로 정의된 개념이 아님
오라클에서 정의한 개념
날짜에다가 숫자를 일수로 생각하여 더하고 뺀 일자가 결과로 된다
날짜 + 숫자 = 날짜

SELECT *
FROM emp;

hiredate에서 365일 미래의 일자
별칭 : 컬럼, expression에 새로운 이름을 부여
      컬럼 | expression [AS] [컬럼명]

SELECT ename AS emp_name, hiredate,
        hiredate+365 after_1year, hiredate-365 before_1year
FROM emp;

별칭을 부여할 때 주의점
1.공백이나, 특수문자가 있는경우 더블 쿼테이션으로 감싸줘야된다.
2.별칭명은 기본적으로 대문자를 취급되지만 소문자로 지정하고 싶으면 더블 쿼테이션을 적용한다.

SELECT ename "emp name", empno emp_no, empno "emp_no2"
FROM emp;

자바에서 문자열 : "Hello, World"
SQL에서 문자열 : 'Hello, World'


==매우중요==
NULL : 아직 모르는 값
숫자 타입 : 0이랑 NULL은 다르다
문자 타입 : ' '랑 NULL은 다르다
*****NULL을 포함한 연산의 결과는 항상 NULL*****
5 * NULL = NULL
800 + NULL =NULL
800 + 0 = 800

emp 테이블 정리
1. empno : 사원번호
2. ename : 사원이름
3. job : 담당업무(담당직책)
4. mgr : 매니저 사번번호
5. hiredate : 입사일자
6. sal : 급여
7. comm : 상과금(성과금)
8. deptno : 부서번호

emp 테이블에서 NULL값 확인
SELECT ename, sal, comm, sal +comm AS total_sal
FROM emp;

SELECT *
FROM dept;

SELECT userid, usernm, reg_dt, reg_dt +5
FROM users;

[실습 select2]
SELECT prod_id AS [id], prod_name AS [name]
FROM prod;

SELECT lprod_gu "gu", lprod_nm "nm"
FROM lprod;

SELECT buyer_id "바이어아이디", buyer_name "이름"
FROM buyer

literal : 값 자체
literal 표기법 : 값을 표현하는 방법

숫자 10이라는 숫자 값을
java : int a =10;
sql : SELECT cempno, 10
      FROM emp;
      
문자 Hello, World라는 문자 값을
java : string str = "Hello,World";
                컬럼 별칭, expression 별칭, 별칭
                * | {column | expression [alias]}
sql : 
    SELECT empno e, 'Hello, World' h --"Hello, World"
    FROM emp;
    
날짜 2020년 9월 2일이라는 날짜 값을....
java : primitive type(원시타입) : 8개 -int, long,short, byte
                                     -char, boolean, float, double
                                        문자열 ==> String class
                                        날짜  ==> Date class
sql : ??? (나중에 알려줌)

문자열 연산
java + ==> 결합 연산
    "Hello," + "World" ==> "Hello,World"
    "Hello," - "World" ==> 연산자가 정의되어 있지 않다.(에러)

python
    "Hello," * 3 ==> "Hello,Hello,Hello,"

sql ||, CONCAT 함수 ==> 결합 연산
    cmp테이블의 ename, job 컬럼이 문자열
    
    ename + " " + jab --java
    ename || ' ' || job --sql
    
    CONCAT(문자열1, 문자열2) : 문자열1과 문자열2를 합쳐서 만들어진 새로운 문자열을 반환해준다.
    
    SELECT ename || ' ' || job,
            CONCAT(CONCAT(ename, ' '), job)  
    FROM emp;
    
    SELECT CONCAT(CONCAT(ename, ' '), job)
    FROM emp;
    
    DESC emp;
    
    USER_TABLES : 오라클에서 관리하는 테이블(뷰)
                  접속한 사용자가 보유하고 있는 테이블 정보를 관리
                  
SELECT table_name
FROM user_tables;

SELECT 'SELECT' || ' ' || '*' || ' ' || table_name || ';' AS QUETY
FROM user_tables;

SELECT CONCAT('SELECT * FROM', CONCAT(' ', CONCAT(table_name, ';'))) AS QUETY
FROM user_tables;

SELECT 'SELECT * FROM' || table_name || ';'
FROM user_tables;