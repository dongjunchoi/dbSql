VIEW 는 쿼리 이다
 ==> VIEW 는 물리적인 데이터를 갖고 있지 않다. 데이터를 정의하는 SELECT쿼리이다
    VIEW에서 사용하는 테이블의 테이터가 변경이 되면 VIEW의 조회 결과에도 영향을 미친다.

VIEW를 사용하는 사례
    1.데이터 노출을 방지(emp테이블의 sal,comm을 제외하고 생성, hr계정에게 view를 조회할수 있는 권한부여)
        hr계정에서는 emp테이블을 직접 조회 못하지만 v_emp는 가능
            ==> v_emp에는 sal,comm컬럼이 없기 때문에 급여관련 정보를 감출 수 있었다.
    2.자주 사용되는 쿼리를 view 만들어서 재사용
        ex) emp 테이블은 dept 테이블이랑 조인되서 사용하는 경우가 많음
            view를 만들지 않을경우 매번 조인 쿼리를 작성해야하나, view로 만들면 재사용가능
    3.쿼리가 간단해진다.
        CREATE OR REPLACE VIEW 뷰이름 AS
        SELECT 쿼리;
            
--emp 테이블과 dept 테이블 deptno가 같은 조건으로 조인한 결과를 v_emp_dept이름으로 view생성
CREATE OR REPLACE VIEW v_emp_dept AS
SELECT emp.*, dept.dname,dept.loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;
            
SELECT *
FROM v_emp_dept;

VIEW 삭제
DROP VIEW 뷰이름;
DROP VIEW v_emp_dept;

CREATE VIEW v_emp_cnt AS
SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno;

SELECT *
FROM v_emp_cnt;

ROLLBACK;

sequence : 중복되지 않는 정수값을 만들어내는 오라클 객체
    JAVA : UUID 클래스를 통해 중복되지 않는 문자열을 생성 할 수 있다.
    
V_ : view
SEQ_사용할 테이블 이름;

문법 : CREATE SEQUENCE 시퀀스이름;
CREATE SEQUENCE seq_emp;

사용방법 : 함수를 생각하자
함수 테스트 : DUAL
시퀀스 객체명.nextval : 시퀀스 객체에서 마지막으로 사용한 다음 값을 반환
시퀀스 객체명.currval : nextval 함수를 실행하고 나서 사용할 수 있다.
                     nextval 함수를 통해 얻어진 값을 반환
                     
SELECT seq_emp.nextval
FROM dual;

SELECT seq_emp.currval
FROM dual;

--사용예
INSERT INTO emp(empno, ename, hiredate) VALUES (seq_emp.nextval, 'brown', sysdate);

SELECT *
FROM emp;

--의미가 있는 값에 대해서는 시퀀스만 갖고는 만들 수 없다.
--시퀀스를 통해서는 중복되지 않는 값을 생성 할 수 있다.

--시쿼스는 롤백을 하더하도 읽은 값이 복원(ROLLBACK)되지 않는다.


Index : teble의 일부 컬럼을 기준으로 미리 정렬해준 객체
ROWID : 테이블에 저장된 행의 위치를 나타내는 값

SELECT ROWID, empno, ename
FROM emp
WHERE ROWID = 'AAAE5hAAFAAAACOAAA';

만약 ROWID를 알수만 있다면 해당 테이블의 모든 데이터를 뒤지지 않아도 해당 행에 바로 접근 할 수 있다.

--  테이블의 일부 컬럼을 기준을 데이터를 정렬할 객체
--  테이블의 row를 가리키는 주소를 갖고 있다(rowid)
--  정렬된 인덱스를 기준으로 해당 row의 위치를 빠르게 검색
--  테이블의 원하는 행을 빠르게 접근
--  테이블에 데이터를 입력하면 인덱스 구조도 갱신된다.
-- 인덱스 컬럼이 모두 null일 경우 해당 row는 인덱스에 저장되지 않는다.->not null제약의 중요성

BLOCK : 오라클의 (기본 입출력 단위)
                -사용자가 한 행을 읽어도 해당 행이 담겨져 있는 block을 전체로 읽는다
    block의 크기는 데이터베이스 생성시 결정, 기본값 8k byte
DESC emp;
emp 테이블 한 행은 최대 54byte, block 하나에는 emp 테이블을 8000/54 =160행이 들어갈수 있음



SELECT *
FROM user_constraints
WHERE table_name ='EMP';
--emp 테이블의 empno 컬럼에 primary key 추가
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);
PRIMARY KEY(UNIQUE + NOT NULL), UNIQUE 제약을 생ㄱ거하면 해당 컬럼으로 인덱스를 생성
    ==>인덱스가 있으면 값을 빠르게 찾을 수 있다.
        해당 컬럼에 중복된 값을 찾기 위한 제한사항
        
0.시나리오(테이블만 있는경우(제약조건, 인덱스가 없는 경우))
SELECT*
FROM emp
WHERE empno = 7782;
==>테이블에는 순서가 없기 때문에 emp테이블의 14건의 데이터를 모두 뒤져보고 empno값이 7782인 한건에 대해서만 사용자에게 반환

1.시나리오
emp 테이블의 empno 컬럼에 pk_emp 유니크 인덱스가 생성된경우
(우리는 인덱스르 직접생성하지 않았고 primary key 제약조건에 의해 자동으로 생성됨)
SELECT *
FROM emp
WHERE empno =7782;

2.시나리오
emp 테이블의 empno 컬럼에 primary key 제약조건이 걸려있는 경우
EXPLAIN PLAN FOR --실행계획
SELECT empno
FROM emp
WHERE empno =7782;

SELECT *
FROM TABLE (dbms_xplan.display);

UNIQUE 인덱스 : 인덱스 구성의 컬럼의 중복 값을 허용하지 않는 인덱스 (emp.empno)
NON-UNIQUE  인덱스 : 인덱스 구성 컬럼의 중복 값을 허용하는 인덱스 (emp.deptno, emp.job)

3.시나리오
emp 테이블 empno 컬럼에 non-unique 인덱스가 있는경우
ALTER TABLE emp DROP CONSTRAINT pk_dept;
ALTER TABLE emp DROP CONSTRAINT fk_emp_dept;
ALTER TABLE emp DROP CONSTRAINT pk_emp;

IDX_테이블명_U_01
IDX_테이블명_U_02
CREATE INDEX IDX_emp_N_01 ON emp(empno);
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno =7782;

SELECT *
FROM TABLE(dbms_xplan.display);

4.시나리오 
emp테이블의 job 컬럼으로 non-unique 인덱스를 생성한 경우
CREATE INDEX idx_emp_n_02 ON emp (job);

emp 테이블에는 현재 인덱스가 2개 존재
idx_emp_n_01: empno
idx_emp_n_02: job

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

5.시나리오 
emp 테이블에는 현재 인덱스가 2개 존재
idx_non_n_01: empno
idx_non_n_02: job

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER' AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

6.시나리오 
CREATE INDEX idx_emp_n_03 ON emp (job, ename);
emp 테이블에는 현재 인덱스가 3개 존재
idx_emp_n_01: empno
idx_emp_n_02: job
idx_emp_n_03: jon, ename

SELECT job, ename, ROWID
FROM emp
ORDER BY job, ename;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANGER' AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

7.시나리오 
DROP INDEX idx_emp_n_03;
CREATE INDEX idx_emp_n_04 ON emp (ename, job);
emp 테이블에는 현재 인덱스가 3개 존재
idx_emp_n_01: empno
idx_emp_n_02: job
idx_emp_n_04: ename ,job

SELECT ename, job, ROWID
FROM emp
ORDER BY ename;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER' AND ename LIKE 'C%';

SELECT*
FROM TABLE (dbms_xplan.display);

8.시나리오 
emp 테이블의 empno 컬럼에 UNIQUE 인덱스 생성
dept 테이블의 deptno 컬럼에 UNIQUE 인덱스 생성
emp 테이블에는 현재 인덱스가 3개 존재

DROP INDEX idx_emp_n_01;
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);
--dept 에러
DELETE dept
WHERE deptno >= 90;
COMMIT;

emp 테이블에는 현재 인덱스 3개 존재 (pk_emp : empno)
idx_emp_n_01: empno
idx_emp_n_02: job
idx_emp_n_04: ename ,job
dept 테이블에는 현재 인덱스 1개 존재 (pk_dept : deptno)

4가지    2가지   8가지
emp ==> dept
2가지    8가지   8가지  ==>16가지
dept ==> emp

EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno AND emp.empno = 7788;

SELECT *
FROM TABLE(dbms_xplan.display);