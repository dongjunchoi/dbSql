NULL 비교
NULL값은 =, !=등의 비교연산으로 비교가 불가능
    EX: emp 테이블에는 comm컬럼의 값이 NULL인 데이터가 존재

    comm이 NULL인 데이터를 조회하기 위해 다음과 같이 실행한 경우 정상적으로 동작하지 않음
SELECT *
FROM emp
WHERE comm = NULL;

SELECT *
FROM emp
WHERE comm  IS NULL;

comm 컬럼의 값이 NULL이 아닐떄0
    = 의 부정 != or <> ==> NOT

SELECT *
FROM emp
WHERE comm IS NOT NULL;

NOT <==> NOT IN
--사원중 소속 부서가 10번이 아닌 사원 조회
SELECT *
FROM emp
WHERE deptno NOT IN (10);

SELECT *
FROM emp;

--사원중에 자신의 상급자가 존재하지 않는 사원들만 조회
SELECT *
FROM emp
WHERE mgr IS NULL;

논리 연산 : AND , OR , NOT
AND , OR : 조건을 결합할때
    AND : 조건1 AND 조건2 : 조건1과 조건2를 동시에 만족한는 행만 조회되도록 제한
    OR  : 조건1 OR 조건2 : 조건1 혹은 조건2를 만족하는 행만 조회되도록 제한 
        조건1    조건2     조건1 AND 조건2     조건1 OR 조건2
        T         T             T                   T
        T         F             F                   T
        F         T             F                   T
        F         F             F                   F
        
WHERE 절에 AND 조건을 사용하게 되면 : 보통은 행이 줄어든다
WHERE 절에 OR 조건을 사용하게 되면 : 보통은 행이 늘어든다

NOT : 부정 연산 (다른 연산자와 함계 사용되며 부정형 표현으로 사용됨)
    NOT IN(값1, 값2..)
    IS NOT NULL
    NOT EXISTS
    
--mgr가 7698사번을 갖으면서 급여가 1000보다 큰 사원들을 조회
SELECT *
FROM emp
WHERE mgr = 7698 AND sal >1000;
--mar가 7698 이거나 급여가 1000보다 큰사원을 조회
SELECT *
FROM emp
WHERE mgr = 7698 OR sal >1000;
--emp 테이블의 사원중에 mgr가 7698 7839가 아닌 직원
SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839); --/!= 7698 or !7838

IN 연산자는 OR 연산자로 대체가 가능
SELECT *
FROM emp
WHERE mgr IN(7698, 7839); --  ==> mgr = 7698 OR mgr =7839;
--WHERE mgr NOT IN(7698, 7839);  ==>NOT(mgr = 7698  mgr =7839) == mgr != 7698 AND mgr !=7839;

IN 연산자 사용시 NULL 데이터 유의점
--요구사항 : mgr가 7698, 7839, NULL인 사원만 조회
SELECT *
FROM emp
WHERE mgr IN(7698, 7839, NULL); -- mgr =7698 OR mgr =7839 OR mgr = NULL; //NULL값이 들어가면 값이 안나온다.
--NULL값까지 같이 출력하려면 (IS)를 사용
SELECT *
FROM emp
WHERE mgr IN(7698, 7839) OR mgr IS NULL;

--부정형
SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839, NULL); -- mgr !=7698 AND mgr != 7839 AND mgr != NULL; 

논리연산[AND, OR 실습 WHERE7]
SELECT *
FROM emp;
--emp 테이블에서 job이 SALESMAN 이고 입사일자가 1981년6월1일 이후인 직원의 정보를 다음과 같이 조회하세요.
SELECT *
FROM emp
WHERE job = 'SALESMAN' AND  hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

논리연산[AND, OR 실습 WHERE8]
--emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년6월1일 이후인 직원의 정보를 다음과 같이 조회(IN, NOT IN 연산자 사용금지)
SELECT *
FROM emp
WHERE deptno != 10 AND hiredate >= TO_DATE('1981/06/01' , 'yyyy/mm/dd');

논리연산[AND, OR 실습 WHERE9]
--emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년6월1일 이후인 직원의 정보를 다음과 같이 조회(IN, NOT IN 연산자 사용)
SELECT *
FROM emp
WHERE deptno NOT IN (10) AND hiredate >= TO_DATE('1981/06/01' , 'yyyy/mm/dd');

논리연산[AND, OR 실습 WHERE10]
--emp 테이블에서 부서번호가 10번이 아니고 입사일자 1981년6월1일 이후인 직원의 정보를 조회(부서는 10,20,30만 있다고 가정 IN연산자 사용)
SELECT *
FROM emp
WHERE deptno IN(20, 30) AND hiredate >= TO_DATE('1981/06/01' , 'yyyy/mm/dd');

논리연산[AND, OR 실습 WHERE11] --과제 11~14
--emp 테이블에서 job이 SALESMAN이거나 입사일자가 1981년6월1일 이후인 직원의 정보를 다음과 같이 조회
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR hiredate >= TO_DATE('1981/06/01' , 'yyyy/mm/dd');

논리연산[AND, OR 실습 WHERE12]
--emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 조회
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%';

논리연산[AND, OR 실습 WHERE13]
--emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 조회(LIKE 연산자를 사용하지 마세요)
SELECT *
FROM emp
--WHERE job = 'SALESMAN' OR SUBSTR(empno, 1, 2) = 78;
WHERE job ='SALESMAN' OR empno BETWEEN 7800 AND 7899;

논리연산[AND, OR 실습 WHERE14]
--emp 테이블에서 1.job이 SALESMAN이거나 2.사원번호가 78로 시작하면서 입사일자가 1981년6월1일 이후인 직원의 정보 조회(1 또는 2만족하는직원)
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%' AND hiredate >= TO_DATE('1981/06/01' , 'yyyy/mm/dd');

RDBMS는 집합에서 많은 부분을 차용
집합의 특징 : 1.순서가 없다  2. 중복을 허용하지 않는다.
    {1, 5, 10} == {5, 1, 10} (집합에 순서는 없다.)
    {1, 5, 5, 10} ==> {1, 5, 10} (집합은 중복을 허용하지 않는다.

-- 아래 sql의 실행 결과, 데이터의 조회 순서는 보장되지 않는다.
--      지금은 7369, 7499..... 조회가 되지만 내일 동일한 sql을 실행 하더라도 오늘 순서가 보장되지 않는다(바뀔수 있음)
--  *데이터는 보편적으로 데이터를 입력한 순서대로 나온다(보장은아님)
--  ** table에는 순서가 없다.
SELECT *
FROM emp;

-- 시스템을 만들다 보면 데이터의 정령이 중요한 경우가 많다.
-- 게시판 글 리스트 : 가장 최신글이 가장위로 와야 한다.

--  *즉 SELECT 결과 행의 순서를 조정할 수 있어야 한다. ==> ORDER BY 구문

--문법
SELECT *
FROM 테이블명
[WHERE ]
[ORDER BY 컬럼1, 컬럼2]

SELECT *
FROM emp
ORDER BY job, empno;

-- 오름차순, ASC : 값이 작은 데이터부터 큰 데이터 순으로 나열
-- 내리차순, DESC : 값이 큰 데이터부터 작은 데이터 순으로 나열

--ORACLE에서는 기본적으로 오름차순이 기본 값으로 적용 내림차순으로 정렬을 원할경우 정렬 기중 컬럼 뒤에 DESC를 붙여준다.

--job컬럼으로 오름차순 정렬하고, 같은 job을 갖는 행끼리는 empno로 내림차순한다.
SELECT *
FROM emp
ORDER BY job, empno DESC;

--참고로만...중요하지 않음
1. ORDER BY 절에 별칭 사용 가능
SELECT empno eno, ename enm
FROM emp
ORDER BY enm;--( ORDER BY 병칭;)
2. ORDER BY 절에 SELECT 절의 컬럼 순서번호를 기술 하여 정렬 가능
SELECT empno, ename
FROM emp
ORDER BY 2; -- ==> ORDER BY ename;
3. expression도 가능
SELECT empno, ename, sal + 500
FROM emp
ORDER BY sal + 500;

데이터 정렬[ORDER BY 실습 ORDER BY1]
--dept 테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회하도록 쿼리 작성
--dept 테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리 작성
--      (컬럼명을 명시하지 않았습니다. 지난 수업시간에 배운 내용으로 올바른 컬럼을 찾아보세요)
SELECT deptno, dname, loc
FROM dept
ORDER BY dname ASC;

SELECT deptno, dname, loc
FROM dept
ORDER BY loc DESC;

데이터 정렬[ORDER BY 실습 ORDER BY2]
--emp 테이블에서 상여(comm) 정보가 있는 사람들만 조회하고, 상여가(comm)를 많이 받는 사람이 먼저 오도록 정렬,
--  상여가 같을 경우 사번으로 내림차순(상여가 0인 사람은 상여가 없는것으로 간주)
SELECT *
FROM emp
WHERE comm IS NOT NULL AND comm != 0
ORDER BY comm DESC, empno DESC; 

SELECT *
FROM emp
WHERE comm != 0
ORDER BY comm DESC, empno DESC; 

데이터 정렬[ORDER BY 실습 ORDER BY3]
--emp 테이블에서 관리자가 있는 사람들만 조회, 직군(job)순으로 오름차순 정렬, 직군이 같을 경우 사번이 큰사람이 먼저 조회
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

데이터 정렬[ORDER BY 실습 ORDER BY4]
--emp 테이블에서 10번부서(deptno)혹은 30번 부서에 속하는 사람중 급여(sal)가 1500이 넘는 사람들만 조회, 이름을 내림차순으로 정렬
SELECT *
FROM emp
WHERE deptno IN(10,30) AND sal >1500
ORDER BY ename DESC;

orderby 4 (2->3->1->4 순으로 해석된다)
1. SELECT *
2. FROM emp
3. WHERE deptno IN(10, 30) AND sal > 1500
4. ORDER BY ename DESC;

********실무에서 매우많이 사용************
ROWNUM : 행의 번호를 부여해주는 가상 컬럼
            **조회된 순서대로 번호를 부여
            
1. WHERE 절에서 사용가능
        **ROWNUM은 1번부터 순차적으로 데이터를 읽어 올 때만 가능(절대조건!)***
    *WHERE ROWNUM = 1 ( = 동등 비교 연산의 경우 1만 가능)
     HERE ROWNUM <= 15
     WHERE ROWNUM BETWEEN 1 AND 15
     
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM =1;


SELECT ROWNUM, empno, ename
FROM emp
WHERE 글번호(글이작성된 순서) BETWEEN 46 AND 60;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 3 AND 6;

2. ORDER BY 절은 SELECT 이후에 실행된다.
    ** SELECT절에 ROWNUM을 사용하고 ORDER BY 절을 적용하게 되면 원하는 결과를 얻지 못한다.
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename; -- ORDER BY이 SELECT보다 먼저 읽어들여져서 ROWNUM이 뒤섞여 보인다.
정렬을 먼저 하고, 정렬된 결과에 ROWNUM을 적용 ==> INLIKE-VIEW : SELECT 결과를 하나의 테이블 처럼 만들어 준다.

사원정보를 페이징 처리
1페이지 5명씩 조회
1페이지 : 1~5  (page -1) * pageSize + 1 ~ page * pageSize
2페이지 : 6~10
3페이지 : 11~15
SELECT *
FROM(SELECT ROWNUM rn, a.*
    FROM (SELECT empno, ename
          FROM emp
          ORDER BY ename) a)
WHERE rn BETWEEN (:page -1) * :pageSize + 1 AND :page * :pageSize;
--WHERE rn BETWEEN 6 AND 10;
--WHERE ROWNUM BETWEEN 6 AND 10; --실행값 x ROWNUM은 1부터 시작  
SELECT 절에 * 사용 했는데 ,를 통해 다른 특수 컬럼이나 EXPRESSION을 사용 할 경우는 *앞에 해당 데이터가 어떤 테이블에서
        왔는지 명시를 해줘야 한다(한정자)
SELECT ROWNUM, *
FROM emp;

SELECT ROWNUM, emp.*
FROM emp;
별칭은 테이블에도 적용 가능, 단 컬럼이랑 다르게 AS 옵션은 없다.
SELECT ROWNUM, e.*
FROM emp AS e; --(AS)사용 시 에러 (AS)사용X => 값 출력!