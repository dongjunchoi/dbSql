--[base_tables.sql, 실습 join1]

SELECT lprod_gu, lprod_nm
FROM lprod;

SELECT prod_id, prod_name, prod_lgu
FROM prod;

SELECT prod_id, prod_name, prod_lgu, lprod_gu, lprod_nm
FROM prod , lprod;

SELECT  lprod_gu, lprod_nm, prod_id, prod_name
FROM prod p JOIN lprod l ON(p.prod_lgu = l.lprod_gu)
ORDER BY prod_lgu;

SELECT  lprod_gu, lprod_nm, prod_id, prod_name
FROM prod p , lprod l
WHERE p.prod_lgu = l.lprod_gu
ORDER BY lprod_gu;

prod 테이블 건수
SELECT COUNT(*)
FROM prod;

--[base_tables.sql, 실습 join2]
SELECT buyer_id, buyer_name
FROM buyer;

SELECT prod_id, prod_name
FROM prod;

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer b JOIN prod p ON(b.buyer_id = p.prod_buyer);

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer b , prod p 
WHERE b.buyer_id = p.prod_buyer;

--[base_tables.sql, 실습 join3]
--ansi
테이블 여러개 이용시
 테이블 JOIN 테이블 ON() --먼저 조인해준 테이블들이 하나의 테이블로 다시 취급 후 JOIN 테이블 on()을 해준다.
        JOIN 테이블 ON()
SELECT m.mem_id, m.mem_name, p.prod_id, p.prod_name, c.cart_qty
FROM member m JOIN cart c  ON(m.mem_id = c.cart_member)
                JOIN prod p ON(p.prod_id = c.cart_prod);
prod p
--orcle
SELECT m.mem_id, m.mem_name, p.prod_id, p.prod_name, c.cart_qty
FROM member m , cart c, prod p
WHERE m.mem_id = c.cart_member AND p.prod_id = c.cart_prod;
