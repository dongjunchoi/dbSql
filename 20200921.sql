--제약조건
--1.PRIMARY KEY(PK_) : UNIQUE + NOT NULL
--2.NOT NULL : 컬럼에 값이 반드시 들어와야 함
--3.UNIQUE : 해당 컬럼에 중복값이 없어야함 (컬럼 복합 조합도 가능)
--4.FOREIGN KEY(FK_) : 해당 컬럼이 참조하는 다른 테이블에 값이 존재 해야함
--5.CHECK : 컬럼에 들어 갈 수 있는 값을 제한

실습때 해야될것
FOREIGN KEY, 테이블 생성, ??
PRIMARY KEY :PK_테이블명
FOREIGN KEY :FK_소스테이블명_참조테이블명

제약조건 삭제
ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;

--생성할때
1.부서 테이블에 PRIMARY KEY 제약조건 추가    
2.사원 테이블에 PRIMARY KEY 제약조건 추가
3.사원 테이블 -부서테이블 간 FOREIGN KEY 제약조건 추가

제약조건 삭제시는 데이터 입력과 반대로 자식부터 먼저 삭제
    3번(FOREIGN KEY : 부모,자식)을 먼저 삭제(1,2)는 어떤걸 먼저해도 상관없다.
    
ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
ALTER TABLE emp_test DROP CONSTRAINT FK_emp_test_dept_test;  --3번
ALTER TABLE dept_test DROP CONSTRAINT PK_dept_test;          --1번
ALTER TABLE emp_test DROP CONSTRAINT PK_emp_test;            --2번

SELECT *
FROM user_constraints
WHERE table_name IN ('EMP_TEST', 'DEPT_TEST');

--STAATUS :제약조건 활성화(ENABLED)/비활성화(DISABLED) 확인


1. dept_test 테이블의 deptno컬럼에 PRIMARY KEY 제약조건 추가
2. emp_test 테이블의 empno컬럼에 PRIMARY KEY 제약조건 추가
3. emp_test 테이블의 deptno컬럼이 dept_test컬럼의 deptno컬럼을 참조한는 FOREIGN KEY 제약조건 추가

ALTER TABLE dept_test ADD CONSTRAINT pk_dept_test PRIMARY KEY (deptno);
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);
ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept_test
                    FOREIGN KEY(deptno) REFERENCES dept_test (deptno);

제약조건 활성화-비활성화 테스트
테스트 데이터 준비 : 부모-자식 관계가 있는 테이블에서는 부모 테이블에 데이터를 먼저 입력
dept_test ==> emp_test
INSERT INTO dept_test VALUES(10, 'ddit');
INSERT INTO emp_test VALUES(9999, 'brown', 10);
dept_test와 emp_test 테이블간 FK가 설정되어 있지만 10번부서는 dept_test에 존재하기 때문에 정상입력
INSERT INTO emp_test VALUES(9999, 'brown', 10);
20번 부서는 dept_test 테이블에 존재하지 않는 데이터이기 때문에 FK에 의해 입력 불가
INSERT INTO emp_test VALUES(9998, 'sally', 20);

FK를 비활성화 한 후 다시 입력
SELECT *
FROM user_constraints
WHERE table_name IN ('EMP_TEST', 'DEPT_TEST');

ALTER TABLE emp_test DISABLE CONSTRAINT FK_emp_test_dept_test; --비활성
INSERT INTO emp_test VALUES(9998, 'sally', 20);
COMMIT;

dept_test :10
emp_test : 9999(99) brown 10 / 9998(98) sally 20 ==> 10, NULL, 삭제

FK 제약조건 재 활성화
ALTER TABLE emp_test ENABLE CONSTRAINT FK_emp_test_dept_test;


--테이블 컬럼 주석(comments) 생성가능
--테이블 주석 정보 확인
--  (user_talbes, user_constrints, user_tabb_comments)
SELECT *
FROM user_tab_comments;

--테이블 주서거 작성 방법
COMMENT ON TABLE 테이블명 IS '주석';

--emp 테이블에 주석(사원) 생성하기
COMMENT ON TABLE emp IS '사원';

--컬럼 주석 확인
SELECT *
FROM user_col_comments
WHERE table_name = 'EMP';

--컬럼 주석 다는 문법
COMMENT ON COLUMN 테이블명.컬럼명 IS '주석';

COMMENT ON COLUMN emp.EMPNO IS '사번';   
COMMENT ON COLUMN emp.ENAME IS '사원이름';   
COMMENT ON COLUMN emp.JOB IS '담당역할';     
COMMENT ON COLUMN emp.MGR IS '매니저사번';     
COMMENT ON COLUMN emp.HIREDATE IS '입사일자';
COMMENT ON COLUMN emp.SAL IS '급여';     
COMMENT ON COLUMN emp.COMM IS '성과급';    
COMMENT ON COLUMN emp.DEPTNO IS '소속부서번호';  

--DDL(Table-comments 실습 comment1)
SELECT t.*, c.column_name, c.comments
FROM user_col_comments c, user_tab_comments t
WHERE t.table_name = c.table_name 
        AND c.table_name IN('CUSTOMER','PRODUCT','CYCLE','DAILY');
        
SELECT *
FROM user_col_comments , user_tab_comments;

SELECT *
FROM user_constraints
WHERE table_name IN('EMP','DEPT');


VIEW : VIEW는 쿼리다(VIEW테이블은 잘못된 표현)
        .물리적인 데이터를 갖고 있지 않고, 논리적인 데이터 정의 집합이다(SELECT쿼리)
        .VIEW가 사용하고 있는 테이블의 데이터가 바뀌면 VIEW 조회 결과도 같이 바뀐다

문법
CREATE OR REPLACE VIEW 뷰이름 AS
SELECT 쿼리;

emp테이블에 sal,comm컬럼 두개를 제외한 나머지 6개 컬럼으로 v_emp 이름으로 VIEW 생성
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;
--insufficient privileges 불충분한 권한

GRANT CONNECT, RESOURCE TO 계정명
VIEW에 대한 생성권한은 RESOURCE에 포함되지 않는다.

SELECT *
FROM v_emp; --재활용가능(inline을 저장)

SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno
      FROM emp); --인라인뷰(재활용 불가.. 매번 사용시 입력해줘야한다)

emp 테이블에서 10번 부서에 속하는 3명을 지웠기 때문에 아래 view의 조회결과도 3명이 지워진 11명만 나온다.
SELECT *
FROM v_emp;

ROLLBACK;

choi 계정에 있는 v_emp 뷰를 hr계정에게 조회할 수 있도록 권한 부여
GRANT SELECT ON v_emp TO hr;