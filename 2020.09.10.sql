많이 쓰이는 함수, 잘 알아두자
    (개념 적으로 혼돈하지 말고 잘 정리하자 - SELECT 절에 올 수 있는 컬럼에 대해 잘 정리)
    

그룹함수 : 여러개의 행을 입력으로 받아 하나의 행으로 결과를 반환하는 함수

오라클 제공 그룹함수
MIN(컬럼|익스프레션) : 그룹중에 최소값을 반환
MAX(컬럼|익스프레션) : 그룹중에 최대값을 반환
AVG(컬럼|익스프레션) : 그룹중에 평균값을 반환
SUM(컬럼|익스프레션) : 그룹중에 합계값을 반환
COUNT(컬럼 | 익스프레션 | *) : 그룹핑된 행의 갯수

SELECT 행을 묵을 컬럼, 그룹함수(MIN,MAX,AVG,SUM,COUNT...)
FORM 테이블 명
[WHERE]
GROUP BY 행을 묶을 컬럼
[HAVING 그룹함수 체크 조건];
        --기술--
            SELECT
            FROM
            [WHERE]
            GROUP BY
            [HAVING]
            ORDER BY; 

SELECT *
FROM emp
ORDER BY deptno; --부서번호로 정렬

--그룹함수에서 많이 어려워 하는 부분 
--    ==>  SELECT절에 기술할 수 있는 컬럼의 구분 : GROUP BY절에 나오지 않은 컬럼이 SELECT절에 나오면 에러
SELECT deptno,MIN(ename), COUNT(*), MIN(sal), MAX(sal), SUM(sal), AVG(sal)
FROM emp
GROUP BY deptno;

--전체 직원(모든 행을 대상으로)중에 가장 많은 급여를 받는 사람의 값
--  : 전체 행을 대상으로 그룹핑 할 경우 GROUP BY를 쓰지 않는다.
--전체 직원중에 가장 큰 급여 값을 알수있는 있지만 해당 급여를 받는 사람이 누군지는 그룹함수만 이용 해서는 구할수 없다.
--emp 테이블 가장 큰 급여를 받는 사람의 값이 5000인 것은 알지만 해당 사원이 누군지는 그룹함수만 사용해서는 식별 불가 ==> 해결 방법(추후진행)

SELECT MAX(sal)
FROM emp;

COUNT 함수 * 인자
- * : 행의 개수를 반환
컬럼 | 익스프레션 : NULL값이 아닌 행의 개수
SELECT COUNT(*), COUNT(mgr), COUNT(comm)
FROM emp;

그룹함수의 특징 :  NULL값을 무시
NULL 연산의 특징 : 결과 항상 NULL이다.

SELECT SUM(comm)
FROM emp;

SELECT SUM(sal + comm), SUM(sal) + SUM(comm)
FROM emp;

그룹함수 특징2: 그룹화 관련 없는 상수들은 SELECT 절에 기술할 수 있다.
SELECT deptno, SYSDATE, 'TEST',1, COUNT(*)
FROM emp
GROUP BY deptno;

그룹함수 특징3 :
    SINGLE ROW 함수의 경우 WHERE에 기술하는것이 가능하다.
        ex : SELECT *
             FROM emp
             WHERE ename = UPPER('smith');
    그룹함수의 경우 WHERE에서 사용하는 것이 불가능 하다.
        => HAVING 절에서 그룹함수에 대한 조건을 기술하여 행을 제한 할 수 있다.
            
            <그룹함수는 WHERE절에 사용 불가>
            SELECT deptno, COUNT(*)
            FROM emp
            WHERE COUNT(*) >= 5
            GROUP BY deptno;
            
            <그룹함수에 대한 행 제한은 HAVING절에 기술>
            SELECT deptno, COUNT(*)
            FROM emp
            GROUP BY deptno
            HAVING COUNT(*) >- 5;
            
[질문] GROUP BY를 사용하면 WHERE 절을 사용 못하나?
GROUP BY에 대상이 되는 행들을 제한할 때 WHERE 절을 사용
SELECT deptno, COUNT(*)
FROM emp
WHERE sal>1000
GROUP BY deptno;

[Function( group function 십습 grp1)]
--emp 테이블을 이용하여 다음을 구하세요
SELECT MAX(sal) max_sal, --1.가장높은 급여
        MIN(sal) min_sal, --2.가장 낮은 급여 
        ROUND(AVG(sal),2) avg_sal, --3.급여 평균(소수점 두자리까지)
        SUM(sal) sum_sal, --4.급여의 합
        COUNT(sal) count_sal, --5.급여가 있는 직원의 수 (null제외)
        COUNT(mgr) count_mgr, --6.상급자가 있는 직원의 수(null제외)
        COUNT(*) count_all --7.전체직원의 수
FROM emp;

[Function( group function 십습 grp2)]
--emp 테이블을 이용하여 다음을 구하세요
SELECT deptno,
        MAX(sal) max_sal, --1.가장높은 급여
        MIN(sal) min_sal, --2.가장 낮은 급여 
        ROUND(AVG(sal),2) avg_sal, --3.급여 평균(소수점 두자리까지)
        SUM(sal) sum_sal, --4.급여의 합
        COUNT(sal) count_sal, --5.급여가 있는 직원의 수 (null제외)
        COUNT(mgr) count_mgr, --6.상급자가 있는 직원의 수(null제외)
        COUNT(*) count_all --7.전체직원의 수
FROM emp
GROUP BY deptno;
--**GROUP BY절에 기술한 컬럼이 SELECT절에 오지 않아도 실행에는 문제 없다.

[Function( group function 십습 grp3)]
--emp 테이블을 이용하여 다음을 구하세요
--  grp2에서 작성한 쿼리 활용 - > deptno대신 부서명이 나올수 있도록 수정
SELECT 
    CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
    END danem,        
        MAX(sal) max_sal, --1.가장높은 급여
        MIN(sal) min_sal, --2.가장 낮은 급여 
        ROUND(AVG(sal),2) avg_sal, --3.급여 평균(소수점 두자리까지)
        SUM(sal) sum_sal, --4.급여의 합
        COUNT(sal) count_sal, --5.급여가 있는 직원의 수 (null제외)
        COUNT(mgr) count_mgr, --6.상급자가 있는 직원의 수(null제외)
        COUNT(*) count_all --7.전체직원의 수
FROM emp
GROUP BY deptno;

SELECT *
FROM dept;

SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') dname,
        MAX(sal) max_sal, --1.가장높은 급여
        MIN(sal) min_sal, --2.가장 낮은 급여 
        ROUND(AVG(sal),2) avg_sal, --3.급여 평균(소수점 두자리까지)
        SUM(sal) sum_sal, --4.급여의 합
        COUNT(sal) count_sal, --5.급여가 있는 직원의 수 (null제외)
        COUNT(mgr) count_mgr, --6.상급자가 있는 직원의 수(null제외)
        COUNT(*) count_all --7.전체직원의 수
FROM emp
GROUP BY deptno;
-------------------
SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') dname,
        MAX(sal) max_sal, --1.가장높은 급여
        MIN(sal) min_sal, --2.가장 낮은 급여 
        ROUND(AVG(sal),2) avg_sal, --3.급여 평균(소수점 두자리까지)
        SUM(sal) sum_sal, --4.급여의 합
        COUNT(sal) count_sal, --5.급여가 있는 직원의 수 (null제외)
        COUNT(mgr) count_mgr, --6.상급자가 있는 직원의 수(null제외)
        COUNT(*) count_all --7.전체직원의 수
FROM emp
GROUP BY DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES');
-------------------------
SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') dname,
        max_sal, min_sal, avg_sal, sum_sal, count_sal, count_mgr, count_all
FROM(SELECT deptno,
        MAX(sal) max_sal, --1.가장높은 급여
        MIN(sal) min_sal, --2.가장 낮은 급여 
        ROUND(AVG(sal),2) avg_sal, --3.급여 평균(소수점 두자리까지)
        SUM(sal) sum_sal, --4.급여의 합
        COUNT(sal) count_sal, --5.급여가 있는 직원의 수 (null제외)
        COUNT(mgr) count_mgr, --6.상급자가 있는 직원의 수(null제외)
        COUNT(*) count_all --7.전체직원의 수
    FROM emp
    GROUP BY deptno);

[Function( group function 십습 grp4)]
--emp 테이블을 이용(직원의 입사 년월별로 몇명의 직원이 입사했는지 조회)
SELECT TO_CHAR(hiredate,'yyyy/mm') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'yyyy/mm');

[Function( group function 십습 grp5)]
--emp 테이블을 이용(직원의 입사 년별로 몇명의 직원이 입사했는지 조회)
SELECT TO_CHAR(hiredate,'yyyy') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'yyyy');

[Function( group function 십습 grp6)]
--회사에 존재하는 부서의 개수는몇개인지 조회하는 쿼리르 작성(dept테이블 사용)
SELECT COUNT(deptno) cnt
FROM dept;

[Function( group function 십습 grp7)]
--직원이 속한 부서의 개수를 조회(emp테이블 사용)
SELECT COUNT(COUNT(*)) cnt
FROM emp
GROUP BY deptno;

SELECT COUNT(*)
FROM(SELECT COUNT(*) cnt
        FROM emp
        GROUP BY deptno);

SELECT *
FROM emp;


--              ***** JOIN *****
--***********WHERE + JOIN SElECT SQL의 모든것!!!**********
--  JOIN: 다른 테이블과 연결하여 데이터를 확장하는 문법
--        .컬럼을 확장
-- **행을 확장 - 집합연산자(UNION, INTERSECT, MINUS)

--JOIN 문법 구분
-- 1. ANSI - SQL
--        : RDBMS에서 사용하는 SQL 표준 (표준을 잘 지킨 모든  RDBMS-MYSQL, MSSQL, POSTGRESQL...에서 실행가능)
-- 2. ORACLE - SQL
--        : ORACLE사만의 고유 문법 (ORACLE에서만 사용된다)

--회사에서 요구하는 형태로 따라가자 7(ORACLE) : 3(ANSI)

--잘 사용 안함
NATURAL JOIN : 조인하고자 하는 테이블의 컬럼명이 같은 컬럼끼리 연결(컬럼의 값이 같은 행들끼리 연결)
    ANSI-SQL
  
        SELECT 컬럼
        FROM 테이블명 NATURAL JOIN 테이블명;
        
SELECT *
FROM emp NATURAL JOIN dept;

조인 컬럼에 테이블 한정자를 붙이면 NATURAL JOIN에서는 에러로 취급
    emp.deptno(x) ==> deptno(o)
SELECT emp.empno, deptno
FROM emp NATURAL JOIN dept;
컬럼명이 한쪽 테이블에만 존재한 경우 테이블 한정자를 붙이지 않아도 상관 없다.
    emp.empno(o), empno(o)
SELECT empno, deptno
FROM emp NATURAL JOIN dept;

NATURAL JOIN을 ORACLE문법으로
1. FROM 절에 조인할 테이블을 나열한다(,)
2. WHERE 절에 테이블 조인 조건을 기술한다.

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno; --있는 그래로 다 보여준다

ORA-00918: column ambiguously defined :
    컬럼이 여러개의 테이블에 동시에 존재하는 상황에서 테이블 한정자를 붙이지 않아서 오라클 입장에서는 해당 컬럼이
        어떤 테이블의 컬럼인지 알수없을때 발생. deptno 컬럼은, emp, dept테이블 양쪽 다 존재
SELECT *
FROM emp, dept
WHERE deptno = deptno; --에러(한정자를 알수없다)

인라인뷰 별칭처럼, 테이블 별칭을 부여하는게 가능, 컬럼과 다르게 AS 키워드는 붙이지 않는다.
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM emp e, dept d
WHERE e.deptno = d.deptno;


ANSI-SQL : JOIN WITH USING
    조인하려는 테이블간 같은 이름의 컬럼이 2개 이상일 때 하나의 컬럼으로만 조인하고 싶을 때 사용
SELECT *
FROM emp JOIN dept USING(deptno);

ORACLE 문법
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

ANSI-SQL : JOIN WITH ON - 조인 조건을 개발자가 직접 기술
            NATURAL JOIN, JOIN WITH USING 절을 JOIN WITH ON 절을 통해 표현 가능
            
SELECT *
FROM emp JOIN dept ON(emp.deptno = dept.deptno)
WHERE emp.deptno IN (20,30);

ORACLE 문법
SELECT *
FROM emp e, dept d
WHERE e.deptno = d.deptno
    AND e.deptno IN (20,30);
    
논리적인 형태에 따른 조인 구분
1. SELF JOIN : 조인하는 테이블이 서로 같은 경우
    SELECT e.empno, e.ename, e.mgr, m.ename
    FROM emp e JOIN emp m ON(e.mgr = m.empno);
    
ORACLE문법
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e , emp m
WHERE  e.mgr = m.empno;
-- ==> KING의 경우 mgr 컬럼의 값이 NULL 이기 때문에 e.mgr = m.empno 조건을 충족 시키지 못함.(조인 실패해서 14건중 13건에 데이터만 조회)

2. NONEOUI JOIN : 조인 조건이 =이 아닌 조인
    SELECT *
    FROM emp e, dept d
    WHERE e.empno = 7369 AND e.deptno != d.deptno;

emp테이블의 sal를 이용해서 등급 구하기
SELECT *
FROM salgrade , emp;

SELECT *
FROM emp JOIN dept ON(emp.deptno = dept.deptno);
WHERE emp.deptno IN (20,30);

--ORACLE문법
empno, ename, sal, 등급(grade)
SELECT empno, ename, sal, grade 
FROM emp, salgrade
WHERE sal >= losal AND sal <=hisal; --WHERE sal BETWEEN losal AND hisal;

--ANSI문법
SELECT empno, ename, sal, grade 
FROM emp  JOIN salgrade  ON(sal >= losal AND sal <=hisal);
--FROM emp  JOIN salgrade  ON(sal BETWEEN losal AND hisal);

[데이터 결합 (실습join0)]
SELECT *
FROM emp,dept;

SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e JOIN dept d ON(e.deptno = d.deptno)
ORDER BY deptno; 

SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY deptno;

[데이터 결합 (실습join0_1)]    
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e JOIN dept d ON(e.deptno = d.deptno)
WHERE e.deptno IN (10,30);

SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e , dept d 
WHERE e.deptno = d.deptno AND e.deptno IN (10,30);

[데이터 결합 (실습join0_2)]
SELECT empno, ename, sal, e.deptno, dname
FROM emp e JOIN dept d ON(e.deptno = d.deptno AND sal >2500)
ORDER BY deptno;

SELECT empno, ename, sal, e.deptno, dname
FROM emp e , dept d 
WHERE sal > 2500 AND e.deptno = d.deptno;


[데이터 결합 (실습join0_3)]
SELECT empno, ename, sal, e.deptno, dname
FROM emp e JOIN dept d ON(e.deptno = d.deptno AND sal >2500 AND empno >7600)
ORDER BY deptno;

SELECT empno, ename, sal, e.deptno, dname
FROM emp e , dept d
WHERE sal > 2500 AND empno > 7600 AND e.deptno = d.deptno; 

[데이터 결합 (실습join0_4)]

SELECT empno, ename, sal, e.deptno, d.dname
FROM emp e JOIN dept d ON
        (e.deptno = d.deptno AND sal >2500 AND empno >7600 AND d.dname = 'RESEARCH')
ORDER BY deptno;

SELECT empno, ename, sal, e.deptno, d.dname
FROM emp e , dept d 
WHERE e.deptno = d.deptno AND sal >2500 AND empno >7600 AND d.dname = 'RESEARCH'
ORDER BY deptno;