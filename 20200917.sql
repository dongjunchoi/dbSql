DML : Date Manipulate LANGUAGE --Manipulate:교묘히 다루다
1. SELECT *************
2. INSERT : 테이블에 새로운 데이터를 입력하는 명령
3. UPDATE : 테이블에 존재하는 데이터의 컬럼을 변경하는 명령
4. DELETE : 테이블에 존재하는 데이터(행)를 삭제하는 명령

INSERT 3가지
1.테이블의 특정 컬럼에만 데이터를 입력할 때(입력되지 않은 컬럼은 NULL로 설정 된다.)
INSERT INTO 테이블명(컬럼1,컬럼2...) VALUES (컬럼1의 값1,컬럼2의 값2....);

DESC emp;

INSERT INTO emp(empno, ename) VALUES (9999, 'brown');
SELECT *
FROM emp
WHERE empno =9999;

--empno컬럼의 설정이 NOT NULL이기 때문에 empno컬럼에 NULL값이 들어갈수 없어서 에러가 발생
INSERT INTO emp(ename) VALUES('sally');

2.테이블의 모든 컬럼에 모든 데이터를 입력할 때
    ****단 값을 나열하는 순서는 테이블의 정의된 컬럼 순서대로 기술 해야한다.
        테이블 컬럼 순서 확인 방법 : DESC 테이블명.
INSERT INTO 테이블명 VALUES (컬럼1의 값1,컬럼2의 값2....);

DESC dept;

INSERT INTO dept VALUES (98, '대덕', '대전');
SELECT *
FROM dept;

--컬럼을 기술하지 않았기 때문에 테이블에 정의된 모든 컬럼에 대해 값을 기술해야하나, 3개중 2개만 기술하여 에러 발생
INSERT INTO dept VALUES (97, 'DDIT'); --"not enough values" 에러

3. SELECT 결과를(여러행일 수도 있다) 테이블에 입력
INSERT INTO 테이블명[(col,...)]
SELECT 구문;
---------------------
INSERT INTO emp(empno, ename)
SELECT 9997, 'cony' FROM dual
UNION ALL
SELECT 9996, 'moon' FROM dual;

SELECT *
FROM emp;

날짜 컬럼 값 입력하기
INSERT INTO emp VALUES(9996, 'james', 'CLERK', NULL, SYSDATE, 3000, NULL, NULL);
'2020/09/01'--무결성 제약조건을 정하지 않아서 에러없이 생성된다.
INSERT INTO emp VALUES(9996, 'james', 'CLERK', NULL, TO_DATE('2020/09/01','yyyy/mm/dd'), 3000, NULL, NULL);

SELECT *
FROM emp;

*********************************************************************
UPDATE : 테이블에 존재하는 데이터를 수정할 때 사용
1.어떤 데이터를 수정할지 데이터를 한정 (WHERE)
2.어떤 컬럼에 어떤 값을 넣을지 기술
UPDATE 테이블명 SET 변경할 컬럼명 = 수정할 값[ , 변경할 컬럼명 = 수정할 값...]
[WHERE]

99 ddit deptno
dept 테이블의 deptno 컬럼의 값이 99번인 데이터의 DNAME 컬럼을 대문자 DDIT로, loc컬럼을 한글 '영민'으로 변경

UPDATE dept SET dname = 'DDIT', loc = '영민'
WHERE deptno = 99;
SELECT *
FROM dept;
--update는 머뭇거려야된다.(WHERE절에 조건을 안해주고 update만 실행시키면 모든 값이 전부 바껴버린다)
UPDATE dept SET dname = 'DDIT' loc = '영민';


ROLLBACK;-- 커밋시키기 전 상황으로 돌려준다

2. 서브 쿼리르 활용한 데이터 변경(***추후 MERGE 구문을 배우면 더 효율적으로 작성할 수 있다)
테스트 데이터 입력
INSERT INTO emp(empno, ename, job) VALUES (9000,'brown', NULL);
9000번 사번의 DEPTNO, JOB 컬럼의 값을 SMITH사원의 DEPTNO, JOB 컬럼으로 동일하게 변경
SELECT deptno, job
FROM emp
WHERE ename ='SMITH'

UPDATE emp SET deptno =(SELECT detpno
                        FROM emp
                        WHERE ename = 'SMITH'),
                job = (SELECT job
                       FROM emp
                       WHERE ename = 'SMITH')
WHERE empno = 9000;

SELECT *
FROM emp
WHERE ename IN('brown','SMITH');

UPDATE emp SET deptno = 값1, job = 값2
WHERE empno =9000;

3. DELETE : 테이블에 존재하는 데이터를 삭제(행 전체를 삭제)
    *****emp테이블에서 9000번 사번의 deptno 컬럼을 지우고 싶을 때(NULL) ??
        ==> deptno 컬럼을 NULL 업데이트 한다.
        
DELETE [FROM] 테이블명
[WHERE...]
emp 테이블에서 9000번 사번의 데이터(행)를 완전히 삭제

DELETE emp
WHERE empno =9000;

SELECT *
FROM emp;

UPDATE, DELETE 절을 실행하기 전에
WHERE 절에 기술한 조건으로 SELECT를 먼저 실행하여, 변경, 삭제되는 행을 눈으로 확인 해보자

ROLLBACK;

DML 구분 실행시
--DBMS는 복구를 위해 로그를 남긴다(즉, 데이터 변경 작업 + alpah의 잡업량이 필요
--    하지만 개발 환경에서는 데이터를 복수할 필요가 없기 때문에 삭제 속도를 빠르게 하는것이 개발 효율성에 좋음.)
DELETE emp;
--로그없이 테이블의 모든 데이터를 삭제하는 방법 : TRUNCATE TABLE 테이블명;
TRUNCATE TABLE emp;

