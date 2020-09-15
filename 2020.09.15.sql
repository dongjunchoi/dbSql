데이터 결합(outer join 실습1)
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON(b.buy_prod = p.prod_id 
                                AND BUY_DATE = TO_DATE('2005/01/25', 'yyyy/mm/dd'));
                                
데이터 결합(outer join 실습2)
SELECT TO_DATE(:yyyymmdd, 'yyyy/mm/dd') buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b , prod p
WHERE b.buy_prod(+) = p.prod_id
               AND BUY_DATE(+) = TO_DATE(:yyyymmdd, 'yyyy/mm/dd');
               
데이터 결합(outer join 실습3)
SELECT TO_DATE(:yyyymmdd, 'yyyy/mm/dd') buy_date,
            b.buy_prod, p.prod_id, p.prod_name, NVL(b.buy_qty, 0)
FROM buyprod b , prod p
WHERE b.buy_prod(+) = p.prod_id
               AND BUY_DATE(+) = TO_DATE(:yyyymmdd, 'yyyy/mm/dd');

데이터 결합(outer join 실습4)
--ORACLE--
SELECT  p.pid, p.pnm, :cid cid,NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
FROM cycle c , product p
WHERE c.pid(+) = p.pid AND c.cid(+) = :cid;
--ANSI--
SELECT  p.pid, p.pnm, :cid cid, NVL(c.day, 0) day, NVL(c.cnt, 0) cnt
FROM cycle c RIGHT OUTER JOIN product p ON(c.pid = p.pid) AND c.cid = :cid;

데이터 결합(outer join 실습5) cid=1:brow
    --ANSI--
SELECT  p.pid, p.pnm, :cid cid,  NVL(cu.cnm,'borwn'), NVL(cy.day, 0) day, NVL(cy.cnt, 0) cnt
FROM cycle cy  RIGHT OUTER JOIN customer cu ON(cy.cid = cu.cid)
              RIGHT OUTER JOIN product p ON(cy.pid = p.pid) AND cy.cid = :cid;
    --ORACLE--
SELECT p.pid, p.pnm, :cid cid, NVL(cu.cnm,'borwn') cnm, NVL(cy.day, 0) day, NVL(cy.cnt, 0) cnt
FROM customer cu, cycle cy, product p
WHERE cy.pid(+) = p.pid AND cu.cid(+) = cy.cid AND cy.cid(+) = :cid;


INNER JOIN : 조인이 성공하는 데이터만 조회가 되는 조인 방식
OUTER JOIN : 조인에 실패해도 기준으로 정한 테이블의 컬럼은 조회가 되는 조인 방식

--EMP테이블 행의 건수 (14)* DEPT 테이블 행의 건수 (4) = 56건
SELECT *
FROM emp, dept;

[cross join 실습 1]
--customer, product 테이블 이용, 가능한 모든 제품의 정보를 결합
SELECT c.cid, c.cnm, p.pid, p.pnm
FROM customer c, product p; --customer c CROSS JOIN product p


----*****중요!*****(중요하지만 어렵다)-----
--SQL 활용에 있어서 매우 중요
-- 서브쿼리 : 쿼리 안에서 실행되는 쿼리
--  1. 서브쿼리 분류 - 서브쿼리가 사용되는 위치에 따른 분류
--      1.1 SELECT : 스칼라 서브쿼리(SCALAR SUBQUERY)
--      1.2 FROM : 인라인 뷰(INLINE-VIEW)
--      1.3 WHERE : 서브쿼리(SUB QUERY)
--  2. 서브쿼리 분류 - 서브쿼리가 반환하는 행, 컬럼의 개수의 따른 분류
--                          (행1, 행 여러개) , (컬럼1, 컬럼 여러개) : (행, 컬럼) : 4가지
--      2.1 단일행, 단일 컬럼
--      2.2 단일행, 복수 컬럼  ==> X(잘 안씀)
--      2.3 복수행, 단일 컬럼
--      2.4 복수행, 복수 컬럼
--  3. 서브쿼리 분류 - 메인쿼리의 컬럼을 서브쿼리에서 사용여부에 따른  분류
--      3.1 상호 연관 서브 쿼리(CORELATED SUB QUERY)
--              -메인 쿼리의 컬럼을 서브 쿼리에서 사용하는 경우
--      3.2 비상호 연관 서브 쿼리(NON-CORELATED SUB QUERY)
--              -메인 쿼리으 ㅣ컬럼을 서브 쿼리에서 사용하지 않는 경우

SMITH 가 속한 부서에 속한 사원들은 누가 있을까?
1.SMITH가 속한 부서번호 구하기
2.1번에서 구한 부서에 속해 있는 사원들 구하기

SELECT deptno
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = 20;

==> 1,2를 서브쿼리를 이용하여 하나로 합칠수 있다.
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');--단일행(select....where 'smith') 결과는 deptno =( 20 );
                
서브쿼리가 한개의 행 복수 컬럼을 조회하고, 단일 컬럼과 = 비교하는 경우 => X (에러)
SELECT *
FROM emp
WHERE deptno = (SELECT deptno, ename
                FROM emp
                WHERE ename = 'SMITH');
                
서브쿼리가 여러개의 행, 단일 컬럼을 조회하는경우
1. 사용되는 위치 : WHERE - 서브쿼리
2. 조회되는 행, 컬럼의 개수 : 복수행, 단일 컬럼
3. 메인쿼리의 컬럼을 서브쿼리에서 사용 유무 : 비상호연관 서브쿼리
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno --서브쿼리 사용시 = 대신 IN연산자 사용 가능
                FROM emp
                WHERE ename = 'SMITH' OR ename = 'ALLEN'); --deptno = SMITH =20, ALLEN =30 
        -- ==> deptno IN(20,30) / = 은 단일비교이다!
        -- IN연산자를 사용 하면 에러 없이 결과가 조회된다.
              

서브쿼리를 사용할 때 주의점
1. 연산자
2. 서브쿼리의 리턴 형태


[sub 실습 1]
--평균 급여보다 높은 급여를 받는 직원의 수를 조회하세요
--1. 평균 급여 구하기, 2.1에서 구한 값보다 큰 사원들의 수 카운트 하기
14명 사원의 평균 급여 : 2073...
SELECT AVG(sal)
FROM emp;

SELECT COUNT(*)
FROM emp
WHERE sal > 2073;
-----subquery-----
SELECT COUNT(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
[sub 실습 2]
SELECT * -- empno, ename, job, mgr, hiredate, sal, comm, deptno
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
[sub 실습 3]
SELECT *
FROM emp
WHERE deptno IN(SELECT deptno
                FROM emp
                WHERE ename = 'SMITH' OR ename = 'WARD');

복수행 연산자 :IN(중요!), ANY, ALL(빈도 떨어진다)
SELECT *
FROM emp            --SMITH =800, WARD =1250
WHERE sal < ANY(SELECT sal
                FROM emp
                WHERE ename IN ('SMITH','WARD'));
    --sal 컬럼의 값이 800이나, 1250보다 작은 사원 ==> sal컬럼의 값이 1250보다 작은사원

SELECT *
FROM emp            --SMITH =800, WARD =1250
WHERE sal > ALL(SELECT sal
                FROM emp
                WHERE ename IN ('SMITH','WARD'));
    --sal 컬럼의 값이 800보다 크면서 1250보다 큰 사원 ==> sal 컬럼의 값이 1250보다 큰 사원 

--복습--
NOT IN 연산자와 NULL 

관리자가 아닌 사원의 정보를 조회
SELECT * 
FROM emp
WHERE empno NOT IN(SELECT mgr --NVL(mgr, 0)사용해주면서 null의값을 0으로 채워주고 결과를 조회한다
                    FROM emp); --null값이 있어서 데이터가 나오진 않는다

pair wise 개념 : 순서쌍, 두가지 조건을 동시에 만족시키는 데이터를 조회 할때 사용
                AND 논리연산자의 결과 값이 다를 수 있다.(아래 예시 참조)
서브쿼리 : 복수행, 복수 컬럼
SELECT *
FROM emp
WHERE mgr IN(SELECT mgr
             FROM emp
             WHERE empno IN(7499,7782))
    AND deptno IN(SELECT deptno
                  FROM emp
                  WHERE empno IN(7499,7782);
        mgr = 7698, 7839
        deptno 30, 10
        mgr , dep ==>(7698, 30), (7698, 10), (7839, 30), (7839, 10)
                     (7698, 30)                          (7839, 10)

SCALAR SUBQUERY : SELECT 절에 기술된 서브쿼리
                하나의 컬럼;
***스칼라 서브 쿼리는 하나의 행, 하나의 컬럼을 조회하는 쿼리 이여야 한다.       
SELECT dummy, (SELECT SYSDATE
                FROM dual)
FROM dual;

스칼라 서브쿼리가 복수개의 행(4개), 단일 컬럼을 조회==> 에러
SELECT empno, ename, deptno, (SELECT dname FROM dept)
FROM emp;

SELECT *
FROM customer;
emp 테이블과 스칼라 서브 쿼리를 이용하여 부서명 가져오기
기존 : emp 테이블과 dept 테이블을 조인하여 컬럼을 확장

SELECT empno, ename, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno;

==> 스칼라 서브쿼리 이용
SELECT empno, ename, deptno, 
        (SELECT dname FROM dept WHERE deptno = emp.deptno)--행의개수만큼 조회
FROM emp;

상호연관 서브 쿼리 : 메인 쿼리의 컬럼을 서브쿼리에서 사용한 서브쿼리
                    -서브쿼리만 단독으로 실행하는 것이 불가능 하다.
                    -메인쿼리와 서브쿼리의 수행 순서가 정해져 있다.
비상호연관 서브쿼리 : 메인쿼리의 컬럼을 서브쿼리에서 사용하지 않는 서브쿼리
                    -서브쿼리만 단독으로 실행하는 것이 가능하다.
                    -메인 쿼리와 서브 쿼리의 실행 순서가 정해져 있지 않다.
                        메인 => 서브, 서브=>메인 둘다 가능

SELECT *
FROM dept
WHERE deptno IN(SELECT deptno
                FROM emp);