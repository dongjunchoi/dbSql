customer :고객
cid : customer id
cnm : customer name

SELECT *
FROM customer;

product : 제품
pid : product id :제품 번호
pnm : product name :제품 이름

SELECT *
FROM product;

cycle : 고객애음주기
cid : customer id 고객 id
pid : product id 제품 id
day : 1~7(일~토)
cnt : count, 수량

SELECT *
FROM cycle;

데이터 결합(실습 join4)
--erd 다이어그램을 참고하여, customer, ctcle 테이블 조인, 고객별 애음 제품,요일,개수 쿼리작성(고객명 brown,sally만 조회)
SELECT cu.cid, cu.cnm, cy.pid, cy.day, cy.cnt
FROM customer cu JOIN cycle cy ON(cu.cid = cy.cid)
        AND cu.cnm IN('brown','sally');
    --oracle문법
SELECT cu.cid, cu.cnm, cy.pid, cy.day, cy.cnt -- cu.*(cu.cid,cu.cnm)
FROM customer cu, cycle cy 
WHERE cu.cid = cy.cid AND cu.cnm IN('brown' , 'sally');

데이터 결합(실습 join5)
-erd 다이어그램 참고, customer, cycle, product 테이블 조인, 애음제품,요일,개수,제품명 쿼리작성(brown,sally만조회)
SELECT cu.cid, cu.cnm, pr.pid, pr.pnm, cy.day, cy.cnt
FROM customer cu JOIN cycle cy ON(cu.cid = cy.cid)
                 JOIN product pr ON(cy.pid = pr.pid) AND cu.cnm IN('brown','sally');
--SQL : 실행에 대한 순서가 없다. 조인할 테이블에 대해서 FROM절에 기술한 순으로 테이블을 읽지않음.
--      FROM customer, cycle, product ==> 오라클에서는 prodcut 테이블부터 읽을 수도 있다.    
    
    --oracle문법
EXPLAIN PLAN FOR

SELECT cu.cid, cu.cnm, pr.pid, pr.pnm, cy.day, cy.cnt
FROM customer cu , cycle cy , product pr 
WHERE cu.cid = cy.cid AND cy.pid = pr.pid AND cu.cnm IN('brown','sally');

SELECT *
FROM TABLE(dbms_xplan.display);

--(join 6,7),(hr계정8~13)과제
데이터 결합(실습 join6)
--erd 다이어그램 참고, customer,clcle,product테이블 조인, 애음요일과 관계없이 고객별 애음 제품별,개수의 합계,제품명
SELECT cu.cid, cu.cnm, cy.pid, pr.pnm, cy.cnt
FROM customer cu, cycle cy, product pr
WHERE cu.cid = cy.cid AND cy.pid = pr.pid
GROUP BY pid;

SELECT pid, cnt
FROM cycle
GROUP BY pid;


SELECT cid, cnm, pid ,pnm, cnt
FROM customer cu JOIN cycle cy ON(cu.cid = cy.cid)
                JOIN prouct pr ON (cy.pid = pr.pid)
GROUP BY pid;

OUTER JOIN : 자주 쓰이지는 않지만 중요!!
JOIN 구분
1. 문법에 다른 구분 : ANSI-SQL , ORACLE
2. join의 형태에 따른 구분 : SELF-JOIN, NONEQUI-JOIN, CROSS-JOIN
3. join 성공여부에 따라 데이터 표시여부 : 
            INNER JOIN - 조인이 성공했을 때 데이터를 표시
            OUTER JOIN - 조인이 실패해도 기준으로 정한 테이블의 컬럼 정보는 표시
            
사번, 사원의 이름, 관리자 사번, 관리자 이름 
KING(PRESIDENT)의 경우 MGR 컬럼의 값이 NULL이기 때문에 조인에 실패. ==>13건 조회
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno);
 --ORACLE문법-- 
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e , emp m 
WHERE e.mgr = m.empno;
    --LEFT OUTER (emp e LEFT.. emp m)
--ANSI-SQL
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);
    --RIGHT OUTER (emp m RIGHT.. emp e)
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp m RIGHT OUTER JOIN emp e ON(e.mgr = m.empno);
--ORACLE-SQL : 데이터가 없는 쪽의 컬럼에 (+) 기호를 붙인다
--              ANSI-SQL 기준 테이블 반대편 테이블의 컬럼에 (+)을 붙인다.     
--              WHERE절 연결 조건 적용
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e, emp m 
WHERE e.mgr = m.empno(+);

SELECT e.empno, e.ename, e.mgr, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno);

행에 대한 제한 조건 기술기 WHERE절에 기술 했을 때와 ON절에 기술 했을때 결과가 다르다.

사원의 부서가 10번인 사람들만 조회 되도록 부서 번호 조건을 추가
SELECT e.empno, e.ename, e.mgr, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno AND e.deptno =10);

조건을 WHERE 절에 기술한 경우 ==> OUTER JOIN이 아닌 INNER 조인 결과가 나온다. 
SELECT e.empno, e.ename, e.deptno, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
WHERE e.deptno = 10;

SELECT e.empno, e.ename, e.deptno, e.mgr, m.ename, m.deptno
FROM emp e JOIN emp m ON(e.mgr = m.empno)
WHERE e.deptno = 10;

full outer join : left outer + right outer -중복 데이터 제거
SELECT e.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
UNION --위아래 행을 합쳐주는 역활(컬럼의 개수가 다르면 합쳐지진 않는다)
        --A={1,3,5}, B={1,4,5} / AUB ={1,3,4,5}
SELECT e.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno)
MINUS --차집합
SELECT e.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON(e.mgr = m.empno);

SELECT e.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
UNION
SELECT e.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno)
INTERSECT --교집합 결과 확인
SELECT e.empno, m.ename
FROM emp e FULL OUTER JOIN emp m ON(e.mgr = m.empno);

[outer join 실습1] --prod 74, buy_prod 148
--ansi--
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON(b.buy_prod = p.prod_id 
                                AND BUY_DATE = TO_DATE('2005/01/25', 'yyyy/mm/dd'));
--oracle-
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id AND BUY_DATE(+) = TO_DATE('2005/01/25', 'yyyy/mm/dd');


                                
                                