--날짜 관련 함수
--TO_CHAR 날자 ==> 문자
--TO_DATE 문자 ==> 날짜

--날짜 ==> 문자 == >날짜
--문자 ==> 날짜 ==> 문자

--SYSDATE(날짜)를 이용하여 현재 월의 1일자 날짜로 변경하기

--NULL 관련 함수 - NULL과 관련된 연산의 결과는 NULL
--총 4가지 존재 , 다 외우진 않아도 괜찮음(시험에는 나올수있음), 본인이 편한 함수로 하나 정해서 사용 방법 숙지.
--  1. NVL(expr1, expr2)
--    if(expr1 == null)
--        System.out.println(expr2);
--    else
--        System.out.println(expr1);
--  2. NVL2(expr1, expr2, expr3)
--    if(expr1 != null)
--        System.out.println(expr2);
--    else
--        System.out.println(expr3);
--  3. NULLIF(expr1, expr2) //잘 사용안한다.
--    if(expr1 == expr2)
--        System.out.println(NULL);
--    else
--        System.out.println(expr1);
--함수의 인자 개수가 정해지지 않고 유동적으로 변경이 가능한 인자 : 가변인자 / (NVL,NVL2,NULLIF는 인자가 정해져있다)
--  4. coalesce(expr1, expr2, expr3.....) : coalesece의 "**인자중 가장 처음으로 등장하는 NULL이 아닌 인자 반환**"!
--    if(expr1 != NULL)
--        System.out.println(expr1);
--    else //첫번째 인자를 제외하고 다음 인자부터 다시 계산
--        coalesce(expr2,expr3...); 

--  ex)            coalesce(null, null, 5, 4)
--                       ==> coalesce(null, 5, 4)
--                          ==> clalesce(5, 4)
--                               ==> System.out.println(5);

comm 컬럼이 NULL일때 0으로 변경하여 sal 컬럼과 합계를 구한다.
SELECT empno, ename, sal, comm,
        sal + NVL(comm,0) nvl_sum, --NVL(expr1,expr2)
        sal + NVL2(comm, comm, 0) nvl2_sum, --NVL2(expr1, expr2, expr3)
        NVL2(comm, sal+comm, sal) nvl2_sum2, --활용(결과는 같지만 표현방식이 다를뿐)
        NULLIF(sal,sal) nullif, --NULLIF(expr1, expr2)
        NULLIF(sal, 5000) nullif_sal,
        sal + COALESCE(comm, 0) colaesce_sum,
        COALESCE(sal + comm, sal) colaesce_sum2
FROM emp;

[Function( null 실습 fn4)]
--emp테이블의 정보를 다음과 같이 조회하도록 쿼리 작성(nvl,nvl2,coalesce)

SELECT empno,ename, mgr,
        NVL(mgr, 9999) mgr_n,
        NVL2(mgr, mgr, 9999) mgr_n1,
        coalesce(mgr, 9999) mgr_n2 
FROM emp;

[Function( null 실습 fn5)]
--users 테이블의 정보를 다음과 같이 조회하도록 쿼리 작성(reg_dt가 null일 경우 stsdate를 적용)
SELECT userid, usernm, reg_dt,
        NVL(reg_dt, sysdate) n_reg_dt,
        TO_CHAR(NVL(reg_dt, sysdate) , 'yyyy/mm/dd') n_reg_dt2
FROM users
WHERE userid != 'brown'; --부정형(개발자로선 간결한 코딩이여서 좋다)
--in-list : 1000개까지 사용('cony'.....'moon')
--WHERE userid IN ('cony', 'dally', 'james', 'moon'); --(긍정형)성능적인 면에서 이렇게 사용하는게 좋다!

--조건 : condition
--  java 조건 체크 : if, whitch
        if(조건)
            실행할 문장
        else if(조건)
            실행할 문장
        else
            실행할 문장
--  sql : CASE 절
        CASE
            WHEN 조건 THEN 반환할 문장
            WHEN 조건2 THEN 반환할 문장
            ELSE 반환할 문장
        END

emp테이블에서 job 컬럼의 값이 
'SALESMAN' 이면 sal 값에 5%를 인상(sal*1.05)한 급여를 반환
'MANAGER' 이면 sal 값에 10%인상(sal *1.10)한 급여를 반환
'PRESIDENT'이면 sal 값에 20%인상(sal *1.20)한 급여를 반환
그밖에 직군('CLERK', 'ANALYST')은 sal 값 그대로 반환


--CASE절을 이용 새롭게 계산한 sal_b (SMITH:800, ALLEN :1680...)
SELECT ename, job, sal, 
    CASE
        WHEN job = 'SALESMAN' THEN sal * 1.05
        WHEN job = 'MANAGER' THEN sal * 1.10
        WHEN job = 'PRESIDENT' THEN sal * 1.20
        ELSE sal
    END sal_b --sql에서 사용할 수 있는 if!
FROM emp;

--가변인자: 인자의 개수가 정해져 있지 않다
DECODE(col | expr1,
                    search1, return1,
                    search2, return2,
                    search3, return3,
                    [default])
첫번째 컬럼(col | expr1)이 두번째 컬럼(search1)과 같으면 세번째 컬럼(return1)을 리턴,
첫번째 컬럼이 네번째 컬럼(search2)과 같으면 다섯번째 컬럼(return2)을 리턴,
첫번째 컬럼이 여섯번째 컬럼(search3)과 같으면 일곱번째 컬럼(return3)을 리턴,
일치하는 값이 없으면 default 리턴 / search,return값이 +될수잇다.


SELECT ename, job, sal, 
    CASE
        WHEN job = 'SALESMAN' THEN sal * 1.05
        WHEN job = 'MANAGER' THEN sal * 1.10
        WHEN job = 'PRESIDENT' THEN sal * 1.20
        ELSE sal
    END sal_b,
    
    DECODE(job, 'SALESMAN', sal*1.05,
                'MANAGER', sal*1.10,
                'PRESIDENT', sal*1.20,
                sal) sal_decode --한줄로 사용많이 함. 보기편하려고 줄바꿈해놈
FROM emp;

CASE, DECODE 둘다 조건 비교시 사용
    차이점 : DECODE의 경우 값비교가 =(EQUAL)에 대해서만 가능
                복수조건은 DECODE를 중첩하여 표현
            CASE는 부등호 사용가능, 복수개의 조건 사용가능
                (CASE
                    WHEN sal > 3000 AND job = 'MANAGER')

[condition 실습 cond1]
--emp 테이블을 이용하여 deptno에 따라 부서명으로 변경 해서 다음과 같이 조회되는 쿼리 작성
--  (10 -> 'ACCOUNTING, 20 -> 'RESEARCH', 30 -> 'SALES', 40 -> 'OPERATIONS', 기타 -> 'DDIT')


SELECT empno, ename, deptno
FROM emp;

SELECT *
FROM dept;

SELECT empno, ename,
        CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'        
        END dname,
        
        DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES', 40, 'OPERATIONS', 'DDIT') dname1
FROM emp;

[condition 실습 cond2]
--emp 테이블을 이용 hiredate에 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리
--  (생년을 기준으로 하나 여기서는 입사년도를 기준으로 한다)
--직원의 입사년도와, 올해년도의 짝수 구분을 이용해서 올해 건강검진 대상자인지 구하는 문제

--대상 여부 : 출생년도의 짝수 구분과, 건강검진 실시년도(올해)의 짝수 구분이 같을때
--    ex: 1983년생은 홀수년도 출생이므로 2020년도(짝수년도)에는 비대상자
--        1983년생은 홀수년도 출생이므로 2021년도(홀수년도)에는 대상자
--  어떤 양의 정수 x가 짝수인지 홀수인지 구별법?
--      짝수는 2로 나눴을때 나머지가 0, 홀수는 2로 나눴을때 나머지가 1
--      (나머지는 나누는 수(2) 보다 항상 작다, 나머지는 항상 0,1

SELECT *
FROM emp;
--1.해당 직원이 홀수년도 태생 :1,짝수년도 :0값을 갖는 컬럼생성
--2.올해년도가 홀수년인지,짝수년인지 1,0 값을 갖는 컬럼생성
--나머지 연산: java : %, sql : MOD 함수
SELECT empno, ename,TO_CHAR(hiredate,'yyyy') hiredate,
    MOD(TO_CHAR(hiredate,'yyyy'), 2) year, --MOD 나머지(나누기)함수
    MOD(TO_CHAR(SYSDATE,'yyyy'), 2) sys,
    CASE
        WHEN MOD(TO_CHAR(hiredate, 'yyyy'),2) = MOD(TO_CHAR(SYSDATE,'yyyy'), 2) THEN '건강검진 비대상자'
        ELSE '건강검진 대상' 
    END contact_to_doctor
FROM emp;

[condition 실습 cond3]
--users 테이블을 이용하여  reg_dt에 따라 올해 건강보험 검진 대상자인지 조회 하는쿼리
--   (생년을 기준으로 하나 여기서는 reg_dt를 기준으로 한다
SELECT *
FROM users;


SELECT userid, usernm, ' ' alias, TO_CHAR(reg_dt, 'yy/mm/dd'),
        CASE
            WHEN TO_CHAR(reg_dt, 'yy/mm/dd')='19/01/28' THEN '건강검진 대상자'
            ELSE '건강검진 비대상자'
        END contact_to_doctor,
        
        CASE
            WHEN MOD(TO_CHAR(reg_dt, 'yyyy'), 2) = MOD(TO_CHAR(SYSDATE,'yyyy'), 2) THEN '건강검진 대상자'
            ELSE '건강검진 비대상' 
        END contact_to_doctor2
FROM users;
