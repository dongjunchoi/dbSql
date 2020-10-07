REPORT GROUP FUNCTION
GROUP BY의 확장 : SUBGROUP을 자동으로 생성하여 하나의 결과로 합쳐준다.
1.ROLLUP(col1, col2...)
    .기술된 컬럼을 오른쪽에서 부터 지워 나가며 서브 그룹을 생성
2.GROUPING SETS ((col1, col2),col 3)
    . ,단위로 기술된 서브 그룹을 생성
3.CUBE(col1, col2....)
    .컬럼의 순서는 지키되, 가능한 모든 조합을 생성한다.
    
GROUP BY CUBE(job, deptno) ==>4개
    job     deptno  
     0        0     ==> GROUP BY job, deptno
     0        X     ==> GROUP BY job
     X        0     ==> GROUP BY deptno
     X        X     ==> GROUP BY 전체

GROUP BY ROLLUP(job, deptno) ==> 3개((job,deptno),(job),(+전체))

SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY CUBE(job,deptno);

--컬럼이 늘어날수록 경우의 수도(x2) 많아 진다.
CUBE 의 경우 가능한 모든 조합으로 서브 그룹을 생성하기 때문에 2의 기술한 컬럼개수 승 만큼 서브그룹이 생성된다.
CUBE(col1, col2, col3) ==>8가지
CUBE(col1, col2, col3) ==>16가지


REPORT GROUP FUNCTION 조합

GROUP BY job, ROLLUP(deptno), CUBE(mgr)
--rollup (deptno,전체)= 2가지경우
--cube (mgr, 전체) = 2가지경우
--  +job  ==>(job,deptno,mgr),(job,deptno),(job,mgr),(job,전체)
SELECT job, deptno, mgr, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY job, ROLLUP(deptno), CUBE(mgr);

상호 연관 서브 쿼리를 이용한 업데이트
1.emp_test 테이블 삭제
DROP TABLE emp_test;
2.emp 테이블을 사용하여 emp_test 테이블 생성(모든 컬럼, 모든 데이터)
CREATE TABLE emp_test AS
SELECT *
FROM emp;
3.emp_test테이블에는 dname 컬럼을 추가( VARCHAR2(14) )
ALTER TABLE emp_test ADD(dname VARCHAR2(14));
4.상호 연관 서브쿼리를 이용하여 emp_test 테이블의 dname 컬럼을 dept을 이용하여 update

UPDATE emp_test SET dname = (SELECT dname FROM dept WHERE deptno = emp_test.deptno);
--비상호 연관 쿼리 =>(SELECT dname FROM dept WHERE deptno = 20)

SELECT *
FROM emp;
DROP TABLE dept_test;
1.dept 테이블을 이용하여 dept_test 테이블 생성
CREATE TABLE dept_test AS
SELECT *
FROM dept;
2.dept_test 테이블에 empcnt(NUMBER) 컬럼 추가
DESC dept;
ALTER TABLE dept_test ADD(empcnt NUMBER);
3.subquery를 이용하여 dept_test 테이블의 empcnt 컬럼에 해당 부서원 수를 update하는 쿼리 작성
UPDATE dept_test SET empcnt = (SELECT COUNT(*) FROM emp WHERE deptno = dept_test.deptno);
SELECT *
FROM dept_test;

commit;

ADVANCED

[sub a2]
INSERT INTO dept_test (deptno, dname, loc) VALUES (99, 'it1', 'daejeon');
INSERT INTO dept_test (deptno, dname, loc) VALUES (98, 'it2', 'daejeon');

SELECT *
FROM dept_test;

부서에 속한 직원이 없는 부서를 삭제하는 쿼리 작성
ALTER TABLE dept_test DROP COLUMN empcnt;

DELETE dept_test
WHERE 0 = (SELECT COUNT(*) FROM emp WHERE deptno = dept_test.deptno);

ROLLBACK;
--not in 사용
DELETE dept_test
WHERE deptno NOT IN (SELECT deptno FROM emp);

ROLLBACK;
--exists 사용
DELETE dept_test
WHERE NOT EXISTS (SELECT 'X' FROM emp WHERE deptno = dept_test.deptno);

select *
from dept_test;

[sub a3]--과제
1.emp 테이블을 이용하여 emp_test 테이블 생성
CREATE TABLE emp_test AS
SELECT *
FROM emp;
2.subquery를 이용하여 emp_test 테이블에서 본인이 속한 부서의(sal)평균 급여보다 급여가 작은 직원의 급여를
    현 급여에서 200을 추가해서 업데이트 하는 쿼리를 작성


달력 만들기 : 행을 열로 만들기 - 레포트 쿼리에서 자주 사용하는 형태
주어진 것 : 년월 ( 수업시간에는 '202009' 문자열 사용)
--level 은 값이 1부터 시작
SELECT LEVEL, SYSDATE + LEVEL
FROM dual
CONNECT BY LEVEL <= 30;

SELECT TO_CHAR(LAST_DAY(TO_DATE('202008', 'yyyymm')), 'DD')
FROM dual;

SELECT TO_DATE('202002','yyyymm') + LEVEL -1 day,
       TO_CHAR(TO_DATE('202002','yyyymm') + LEVEL -1, 'D') d
       DECODE(TO_CHAR(TO_DATE('202002','yyyymm') + LEVEL -1, 'D'), 1, TO_DATE('202002','yyyymm') + LEVEL -1 m
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202002', 'yyyymm')), 'DD');

SELECT TO_CHAR(sysdate, 'iw'), TO_CHAR(sysdate+1, 'iw') --주차 정보
FROM dual;

SELECT DECODE(d, 1, iw+1, iw),
           MIN(DECODE(d,1,day)) sun, MIN(DECODE(d,2,day)) mon, MIN(DECODE(d,3,day)) tue, 
           MIN(DECODE(d,4,day)) wed, MIN(DECODE(d,5,day)) thu, MIN(DECODE(d,6,day)) fri,
           MIN(DECODE(d,7,day)) sat
FROM (SELECT TO_DATE(:yyyymm,'yyyymm') + LEVEL -1 day,
             TO_CHAR(TO_DATE(:yyyymm,'yyyymm') + LEVEL -1, 'D') d,
             TO_CHAR(TO_DATE(:yyyymm,'yyyymm') + LEVEL -1, 'iw') iw
      FROM dual
      CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);

--201912 검색 출력 에러(달력이랑 일치 x) 해결해보기
--iw값으로는 해결 불가(ISO 표준 주차가 다르다)
SELECT TO_CHAR(TO_DATE('20191229','yyyymmdd'),'iw'),
        TO_CHAR(TO_DATE('20191229','yyyymmdd'),'iw'),
        TO_CHAR(TO_DATE('20191229','yyyymmdd'),'iw')
FROM dual;

SELECT DECODE(d, 1, iw+1, iw),
           MIN(DECODE(d,1,day)) sun, MIN(DECODE(d,2,day)) mon, MIN(DECODE(d,3,day)) tue, 
           MIN(DECODE(d,4,day)) wed, MIN(DECODE(d,5,day)) thu, MIN(DECODE(d,6,day)) fri,
           MIN(DECODE(d,7,day)) sat
FROM (SELECT TO_DATE(:yyyymm,'yyyymm') + LEVEL -1 day,
             TO_CHAR(TO_DATE(:yyyymm,'yyyymm') + LEVEL -1, 'D') d,
             TO_CHAR(TO_DATE(:yyyymm,'yyyymm') + LEVEL -1, 'iw') iw
      FROM dual
      CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);


[실습 calendar1]
달력 만들기 복습 데이터.sql의 일별 실적 데이터를 이용, 1~6월의 월별 실적 데이터를 다음과 같이 구하기
SELECT NVL(MIN(DECODE(mm,'01', sales)), 0) jan, NVL(MIN(DECODE(mm,'02', sales)), 0) feb,
       NVL(MIN(DECODE(mm,'03', sales)), 0) mar, NVL(MIN(DECODE(mm,'04', sales)), 0) apr,
       NVL(MIN(DECODE(mm,'05', sales)), 0) may, NVL(MIN(DECODE(mm,'06', sales)), 0) jun
FROM (SELECT TO_CHAR(dt, 'mm') mm, SUM(sales) sales
      FROM sales
      GROUP BY TO_CHAR(dt, 'mm'));


--계층 쿼리

select deptcd, LPAD(' ',(LEVEL-1)*3) || deptnm deptnm
from dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;