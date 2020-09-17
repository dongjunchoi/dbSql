--순위  시도    시군구    kfc  맥도날드  버거킹 롯데리아
--1.  서울시    서초구      3       4     5       6
--2.  서울시    강남구....

SELECT sido, sigungu, gb, COUNT(*)
FROM fastfood
WHERE gb = '롯데리아' AND sido ='강원도'
GROUP BY sido, sigungu, gb
ORDER BY sido, sigungu, gb;

SELECT sido, sigungu, gb, COUNT(*)
FROM fastfood
WHERE gb = '맥도날드' AND
GROUP BY sido, sigungu, gb
ORDER BY sido, sigungu, gb;

SELECT sido, sigungu, gb
FROM fastfood;

---------------------------------------------------------------------
SELECT a.sido, a.sigungu, a.cnt, b.cnt, ROUND(a.cnt/b.cnt,2) di
FROM (SELECT sido, sigungu, COUNT(*)cnt
      FROM  fastfood
      WHERE gb IN ('KFC', '맥도날드', '버거킹')
      GROUP BY sido, sigungu) a,
        (SELECT sido, sigungu, gb, COUNT(*)cnt
         FROM  fastfood
         WHERE gb = '롯데리아'
         GROUP BY sido, sigungu, gb)b
 WHERE a.sido = b.sido AND a.sigungu = b.sigungu
 ORDER BY di DESC;
 
 kfc 건수, 롯데리아 건수, 버거킹 건수, 맥도날드 건수
 SELECT sido, sigungu, --gb, cnt 
                ROUND(NVL(SUM(DECODE(gb, 'KFC', cnt)), 0) +
                NVL(SUM(DECODE(gb, '버거킹', cnt)), 0) +
                NVL(SUM(DECODE(gb, '맥도날드', cnt)), 0)  /
                NVL(SUM(DECODE(gb, '롯데리아', cnt)), 1),2) di
 FROM (SELECT sido, sigungu, gb, COUNT(*) cnt
       FROM fastfood
       WHERE gb IN('KFC', '롯데리아', '버거킹', '맥도날드')
       GROUP BY sido, sigungu, gb)
GROUP BY sido, sigungu
ORDER BY di DESC;

SELECT sido, sigungu, ROUND(sal/people) P_sal
FROM tax
ORDER BY P_sal DESC;

--도시발전 지수 1 - 세금 1위
--도시발전 지수 2 - 세금 2위
--도시발전 지수 3 - 세금 3위 (랭크 ROWNUM 사용)