인덱스 생성 방법
1. 자동생성
    UNIQUE, PRIMARY KEY 생성시
        (해당 컬럼으로 이루어진 인덱스가 없을 경우 해당 제약조건 명으로 인덱스르 자동생성)
        
        ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
        empno컬럼을 선두컬럼으로 하는 인덱스가 없을 경우 pk_emp이름으로 UNIQUE 인덱스를 자동생성
    
    UNIQUE : 컬럼의 중복된 값이 없음을 보장하는 제약조건
    PRIMARY KEY : UNIQUE + NOT NULL
    
    DBMS입장에서는 신규 데이터가 입력되거나 기존 데이터가 수정될 때
    UNIQUE 제약에 문제가 없는지 확인 ==> 무결성을 지키기 위해
    
    빠른 속도로 중복 데이터 검증을 위해 오라클에서는 UNIQUE, PRIMARY KEY 생성시 해당 컬럼으로 인덱스 생성을 강제한다.
    
    PRIMARY KEY 제약조건 생성 후 해당 인덱스 삭제 시도시 삭제가 불가
    
    FOREIGN KEY : 입력하려는 데이터가 참조하는 테이블의 컬럼에 존재하는 데이터만 입력되도록 제한
    
    emp 테이블에 brow 사원을 50번 부서에 입력을 하게되면 50번 부서가 dept테이블의 deptno 커럼에 존재여부를 확인, 존재할 시에만 emp테이블에 데이터 입력
    
    
[Index 실습 1(생성),2(삭제)]
CREATE TABLE dept_test2 AS
SELECT *
FROM dept
WHERE 1=1;
1. deptno UNIQUE
CREATE UNIQUE INDEX idx_dept_test2_u_01 ON dept_test2 (deptno);
DROP INDEX idx_dept_test2_u_01;
2. dname NON-UNIQUE
CREATE INDEX idx_dept_test2_n_02 ON dept_test2(dname);
DROP INDEX idx_dept_test2_n_02;
3. deptno, dname NON-UNIQUE
CREATE INDEX idx_dept_test2_n_03 ON dept_test2(deptno, dname);
DROP INDEX idx_dept_test2_n_03;

[Index 실습 3]
UNIQUE 인덱스 : 인덱스 구성의 컬럼의 중복 값을 허용하지 않는 인덱스 (emp.empno)
NON-UNIQUE  인덱스 : 인덱스 구성 컬럼의 중복 값을 허용하는 인덱스 (emp.deptno, emp.job)

1.empno(=)
2.ename(=)
3.deptno(=), empno(LIKE : empno || '%')
4.deptno(=), sal(BETWEEN)
5.deptno(=), mgr컬럼이 있을 경우 테이블 액세스 불필요
  empno(=)
6.deptno,hiredate 컬럼으로 구성된 인덱스가 있을 경우 테이블 액세스 불필요

CREATE UNIQUE INDEX  idx_emp_u_01 ON emp(empno, deptno) --(1),(3),(5-2) 만족;
CREATE INDEX idx_emp_n_02 ON emp (ename); --(2)
CREATE INDEX idx_emp_n_03 ON emp (deptno, sal, mgr, hiredate);

FBI : Function Based Index

인덱스 사용에 있어서 중요한점
인덱스 구성컬럼이 모두 null이면 인덱스에 저장을 하지 않는다.
즉, 테이블 접근을 해봐야 해당 행에 대한 정보를 알 수 있다.
가급적이면 컬럼에 값이 null이 들어오지 않을 경우는 not null 제약을 적극적으로 활용
    ==> 오라클 입장에서 실행계획을 세우는데 도움이 된다.


synonym :  동의어
오라클 객체에 별칭을 생성한 객체
오라클 객체를 짧은 이름으로 지어줄 수 있다

생성방법
CREATE [PUBLIC] SYNONYM 동의어_이름 FOR 오라클 객체;
PUBLIC : 공용동의어 생성시 사용하는 옵션/ 시스템 관리자 권한이 있어야 생성가능

emp테이블에 e라는 이름으로 synonym 생성
CREATE SYNONYM e FOR emp;

select *
from e;


dictionary : 오라클의 객체 정보를 볼 수 있는 view
dictionary의 종류는 dictionary view를 통해 조회 가능
SELECT *
FROM dictionary;

dictionary는 크게 4가지로 구분 가능
USER_ : 해당 사용자가 수유한 객체만 조회
ALL_ : 해당사용자가 소유한 객체 + 다른 사용자로부터 권한을 부여받은 객체
DBA_ : 시스템 관리자만 볼 수 있으며 모든 사용자의 객체 조회
V$ : 시스템 성능과 관련된 특수 VIEW

SELECT * 
FROM user_tables;

SELECT *
FROM all_tables;
--DBA 권한이 있는 계정에서만 조회 가능(SYSREM, SYS)
SELECT * 
FROM dba_tables;

multiple insert : 조건에 따라 여러 테이블에 데이터를 입력하는 INSERT

기존에 배운 쿼리는 하나의 테이블에 여러건의 데이터를 입력하는 쿼리
INSERT INTO emp (empno, ename)
SELECT empno, ename
FROM emp;

multiple insert 구분
    1.unconditional insert : 여러 테이블에 insert
    2.conditional all insert : 조건을 만족하는 모든 테이블에 insert
    3.conditional first insert : 조건을 만족하는 첫번째 테이블에 insert
    
1.unconditional insert : 조건과 관계없이 여러 테이블 insert
DROP TABLE emp_test;
DROP TABLE emp_test2;

CREATE TABLE emp_test AS
SELECT empno, ename
FROM emp
WHERE 1=2;

CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1=2;

INSERT ALL INTO emp_test
           INTO emp_test2
SELECT 9999, 'brown' FROM dual UNION ALL
SELECT 9998, 'sally' FROM dual;

select *
from emp_test;
select *
from emp_test2;

unconditional insert 실행시 테이블 마다 데이터를 입력할 컬럼을 조작하는 것이 가능
위에서 : INSERT INTO emp_test VALUES(...) 테이블의 모든 컬럼에 대해 입력
        INSERT INTO emp_test(empno) VALUES(9999) 특정 컬럼을 지정하여 입력 가능
        
INSERT ALL
    INTO emp_test(empno) VALUES(eno)
    INTO emp_test(empno, ename) VALUES (eno,enm)
SELECT 9999 eno, 'brown' enm FROM dual UNION ALL
SELECT 9998, 'sally' FROM dual;

select *
from emp_test;
select *
from emp_test2;

conditional insert : 조건에 따라 데이터를 입력

CASE
    WHEN job ='MANAGER' THEN sal* 1.05
    WHEN job ='PRESIDENT' THEN sal* 1.2
END

ROLLBAck;

INSERT ALL
    WHEN eno >= 9500 THEN
        INTO emp_test VALUES (eno,enm)
        INTO emp_test2 VALUES (eno,enm)
    WHEN eno >= 9900 THEN
        INTO emp_test2 VALUES (eno,enm)
SELECT 9500 eno, 'brown' enm FROM dual UNION ALL
SELECT 9998, 'sally' FROM dual;

select *
from emp_test;

select *
from emp_test2;