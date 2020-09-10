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
