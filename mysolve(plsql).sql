SELECT USER
FROM DUAL;
--==> TWO



--■ 프로시저 ■

-- ADMIN 프로시저
CREATE OR REPLACE PROCEDURE PRC_ADMIN_INSERT
( V_ADMIN_ID    IN TBL_ADMIN.ADMIN_ID%TYPE
, V_PW          IN TBL_ADMIN.PW%TYPE
, V_NAME        IN TBL_ADMIN.NAME%TYPE
)
IS 
BEGIN
    INSERT INTO TBL_ADMIN(ADMIN_ID,PW, NAME) VALUES (V_ADMIN_ID, V_PW, V_NAME);
    
    --COMMIT;
    
END;
----------------------------------------------------
-- SUBJECTS 프로시저
CREATE OR REPLACE PROCEDURE PRC_SUBJECTS_INSERT
( V_SUB_CODE IN TBL_SUBJECTS.SUB_CODE%TYPE
, V_NAME    IN TBL_SUBJECTS.NAME%TYPE
, V_BOOK    IN TBL_SUBJECTS.BOOK%TYPE
)
IS 
   
BEGIN
    INSERT INTO TBL_SUBJECTS(SUB_CODE, NAME, BOOK) VALUES (V_SUB_CODE, V_NAME, V_BOOK);
    --COMMIT;
    
END;

-------------------------------------------------+++++++++++++++++++++++++++++++-----------------------
CREATE OR REPLACE PROCEDURE PRC_GRADE_UPDATE
--매개변수 -> 수강신청코드, 점수3개
( V_GRADE_CODE   IN TBL_GRADE.GRADE_CODE%TYPE   
, V_ATTEND       IN TBL_GRADE.ATTEND%TYPE
, V_PRACTICE     IN TBL_GRADE.PRACTICE%TYPE
, V_WRITTEN      IN TBL_GRADE.WRITTEN%TYPE
)
IS
--UPDATE 진행 시 필요한 데이터를 담을 주요 변수 선언
    V_REG_CODE          TBL_REGISTS.REG_CODE%TYPE;
    V_STU_ID            TBL_REGISTS.STU_ID%TYPE; 
    USER_DEFINE_ERROR   EXCEPTION;
    
BEGIN
-- 수강신청에 수강신청코드가 성적에 수강신청 코드랑 일치하는지
    SELECT REG_CODE INTO V_REG_CODE
    FROM TBL_GRADE
    WHERE GRADE_CODE = V_GRADE_CODE;
        
--  체크 제약조건.....................?

    
    -- UPDATE 쿼리문 구성 -> 성적테이블에서 
    UPDATE TBL_GRADE
    SET ATTEND =V_ATTEND , WRITTEN =V_WRITTEN , PRACTICE = V_PRACTICE
    WHERE GRADE_CODE = V_GRADE_CODE; 
    
           
    --COMMIT;

END;
    
    
    
    
    
-------------------------------------    
CREATE OR REPLACE PROCEDURE PRC_STUDENTS_UPDATE
( V_ID   IN TBL_STUDENTS.ID%TYPE
, V_PW   IN TBL_IDPW.PW%TYPE
, V_TEL  IN  TBL_STUDENTS.TEL%TYPE
, V_ADDR IN  TBL_STUDENTS.ADDR%TYPE
)
IS 
BEGIN
  UPDATE TBL_GRADE
  SET TEL = V_TEL, ADDR = V_ADDR
  WHERE ID = (SELECT ID
              FROM TBL_IDPW
              WHERE ID = V_ID
              AND PW = V_PW);
  COMMIT;
END;   
    
    
----------------------------------------------------
CREATE OR REPLACE PROCEDURE PRC_GRADE_UPDATE
( V_GRADE_CODE  IN TBL_GRADE.GRADE_CODE%TYPE
, V_ATTEND      IN TBL_GRADE.ATTEND%TYPE
, V_WRITE       IN TBL_GRADE.WRITE%TYPE
, V_PRACTICE    IN TBL_GRADE.PRACTICE%TYPE
)
IS
    V_OP_SUBJECT_CODE   TBL_OP_SUBJECTS.OP_SUBJECT_CODE%TYPE;
    V_END_DATE          TBL_OP_SUBJECTS.END_DATE%TYPE;
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN
    
    SELECT OP_SUBJECT_CODE INTO V_OP_SUBJECT_CODE
    FROM TBL_GRADE
    WHERE GRADE_CODE = V_GRADE_CODE;

    SELECT END_DATE INTO V_END_DATE
    FROM TBL_GRADE GR JOIN TBL_OP_SUBJECTS SU
    ON GR.OP_SUBJECT_CODE = SU.OP_SUBJECT_CODE
    WHERE GR.GRADE_CODE = V_GRADE_CODE;
    
    
    IF(V_END_DATE > SYSDATE)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    UPDATE TBL_GRADE
    SET ATTEND =V_ATTEND , WRITE =V_WRITE , PRACTICE = V_PRACTICE
    WHERE GRADE_CODE = V_GRADE_CODE; 
    
    COMMIT;
    
    EXCEPTION
    WHEN USER_DEFINE_ERROR
        THEN RAISE_APPLICATION_ERROR(-100,'총점 300 이상 입력 불가');
             ROLLBACK;
    WHEN OTHERS THEN ROLLBACK;
    
END;

----------------------------------------------------------------------------------

ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT='YYYY-MM-DD'



--과정 데이터 입력
INSERT INTO TBL_COURSE(COUR_CODE, CLASS_CODE, STARTDATE, ENDDATE, LIMIT) VALUES ('1회차',1, TO_DATE('2020-12-01','YYYY-MM-DD'), TO_DATE('2021-04-28','YYYY-MM-DD'),15);
INSERT INTO TBL_COURSE(COUR_CODE, CLASS_CODE, STARTDATE, ENDDATE, LIMIT) VALUES ('2회차',2, TO_DATE('2020-12-01','YYYY-MM-DD'), TO_DATE('2021-04-28','YYYY-MM-DD'),20);
INSERT INTO TBL_COURSE(COUR_CODE, CLASS_CODE, STARTDATE, ENDDATE, LIMIT) VALUES ('1회차',3, TO_DATE('2021-05-03','YYYY-MM-DD'), TO_DATE('2021-07-15','YYYY-MM-DD'),25);
INSERT INTO TBL_COURSE(COUR_CODE, CLASS_CODE, STARTDATE, ENDDATE, LIMIT) VALUES ('1회차',4, TO_DATE('2021-09-30','YYYY-MM-DD'), TO_DATE('2022-02-07','YYYY-MM-DD'),30);
INSERT INTO TBL_COURSE(COUR_CODE, CLASS_CODE, STARTDATE, ENDDATE, LIMIT) VALUES ('1회차',5, TO_DATE('2021-12-28','YYYY-MM-DD'), TO_DATE('2022-05-30','YYYY-MM-DD'),10);



--개설과목 데이터 입력
INSERT INTO TBL_OPSUBJECT(OPSUB_CODE, COUR_CODE, SUB_CODE, PRO_ID, ALLOT_CODE, STARTDATE, ENDDATE) 
            VALUES (10001, '1회차', 1, 'hjkim', 1, TO_DATE('2020-12-01','YYYY-MM-DD'), TO_DATE('2021-04-28','YYYY-MM-DD'));
INSERT INTO TBL_OPSUBJECT(OPSUB_CODE, COUR_CODE, SUB_CODE, PRO_ID, ALLOT_CODE, STARTDATE, ENDDATE) 
            VALUES (10001, '2회차', 1, 'yjseo', 1, TO_DATE('2020-12-01','YYYY-MM-DD'), TO_DATE('2021-04-28','YYYY-MM-DD'));
INSERT INTO TBL_OPSUBJECT(OPSUB_CODE, COUR_CODE, SUB_CODE, PRO_ID, ALLOT_CODE, STARTDATE, ENDDATE) 
            VALUES (10002, '1회차', 2, 'jhhan', 2, TO_DATE('2021-05-03','YYYY-MM-DD'), TO_DATE('2021-07-15','YYYY-MM-DD'));
INSERT INTO TBL_OPSUBJECT(OPSUB_CODE, COUR_CODE, SUB_CODE, PRO_ID, ALLOT_CODE, STARTDATE, ENDDATE) 
            VALUES (10004, '1회차', 3, 'jhlim', 3, TO_DATE('2021-09-30','YYYY-MM-DD'), TO_DATE('2022-02-07','YYYY-MM-DD'));
INSERT INTO TBL_OPSUBJECT(OPSUB_CODE, COUR_CODE, SUB_CODE, PRO_ID, ALLOT_CODE, STARTDATE, ENDDATE) 
            VALUES (10005, '1회차', 4, 'gmlee', 4, TO_DATE('2021-12-28','YYYY-MM-DD'), TO_DATE('2022-05-30','YYYY-MM-DD'));

-- 과목 테이블
INSERT INTO TBL_SUBJECTS(SUB_CODE, NAME, BOOK) VALUES (3, '파이썬', 'Do it! 점프 투 파이썬');
INSERT INTO TBL_SUBJECTS(SUB_CODE, NAME, BOOK) VALUES (4, 'C 언어', '독하게 시작하는 C 프로그래밍');
INSERT INTO TBL_SUBJECTS(SUB_CODE, NAME, BOOK) VALUES (5, '스프링', '스프링 퀵 스타트');






SELECT *
FROM TBL_COURSE;

ROLLBACK;

--------------



-- 교수 테이블 데이터
INSERT INTO TBL_PROFESSOR (PRO_ID, PW, NAME, FSSN, BSSN, SIGNDATE)
VALUES ('hjkim', '1234567', '김호진', '650924', '1234567', TO_DATE('2002-05-22','YYYY-MM-DD'));
INSERT INTO TBL_PROFESSOR (PRO_ID, PW, NAME, FSSN, BSSN, SIGNDATE)
VALUES ('yjseo', '1123456', '서영학', '770314', '1123456', TO_DATE('2016-12-02','YYYY-MM-DD'));
INSERT INTO TBL_PROFESSOR (PRO_ID, PW, NAME, FSSN, BSSN, SIGNDATE)
VALUES ('jhhan', '1112345', '한장희', '791109', '1112345', TO_DATE('2007-01-26','YYYY-MM-DD'));
INSERT INTO TBL_PROFESSOR (PRO_ID, PW, NAME, FSSN, BSSN, SIGNDATE)
VALUES ('jhlim', '1111234', '임정훈', '880111', '1111234', TO_DATE('2010-06-06','YYYY-MM-DD'));
INSERT INTO TBL_PROFESSOR (PRO_ID, PW, NAME, FSSN, BSSN, SIGNDATE)
VALUES ('gmlee', '2345678', '이규미', '941013', '2345678', TO_DATE('2013-02-28','YYYY-MM-DD'));
INSERT INTO TBL_PROFESSOR (PRO_ID, PW, NAME, FSSN, BSSN, SIGNDATE)
VALUES ('hrkim', '1111123', '김현룡', '710211', '1111123', TO_DATE('2004-08-07','YYYY-MM-DD'));



-- 학생 테이블 데이터
INSERT INTO TBL_STUDENT(STU_ID, PW, NAME, FSSN, BSSN, SIGNDATE)   
VALUES ('201305097', '1124567','이찬호','941108','1124567',TO_DATE('2013-02-15','YYYY-MM-DD'));
INSERT INTO TBL_STUDENT(STU_ID, PW, NAME, FSSN, BSSN, SIGNDATE)
VALUES ('201405047', '1144589','홍길동','951211','1144589',TO_DATE('2014-04-02','YYYY-MM-DD'));
INSERT INTO TBL_STUDENT(STU_ID, PW, NAME, FSSN, BSSN, SIGNDATE)
VALUES ('201305047', '2145789','박혜진','990312','2145789',TO_DATE('2013-03-12','YYYY-MM-DD'));
INSERT INTO TBL_STUDENT(STU_ID, PW, NAME, FSSN, BSSN, SIGNDATE)
VALUES ('200102059', '2234567','장민지','960618','2234567',TO_DATE('2001-08-07','YYYY-MM-DD'));
INSERT INTO TBL_STUDENT(STU_ID, PW, NAME, FSSN, BSSN, SIGNDATE)          
VALUES ('201702057', '3123458','윤유동','010505','3123458',TO_DATE('2021-02-12','YYYY-MM-DD'));
INSERT INTO TBL_STUDENT(STU_ID, PW, NAME, FSSN, BSSN, SIGNDATE)         
VALUES ('202002015', '3246887','김진희','021112','3246887',TO_DATE('2020-07-13','YYYY-MM-DD'));
INSERT INTO TBL_STUDENT(STU_ID, PW, NAME, FSSN, BSSN, SIGNDATE)         
VALUES ('202105043', '4123457','손다정','010812','4123457',TO_DATE('2020-05-17','YYYY-MM-DD'));
INSERT INTO TBL_STUDENT(STU_ID, PW, NAME, FSSN, BSSN, SIGNDATE)         
VALUES ('201403047', '2225689','장유진','950517','2225689',TO_DATE('2014-04-13','YYYY-MM-DD'));
INSERT INTO TBL_STUDENT(STU_ID, PW, NAME, FSSN, BSSN, SIGNDATE)         
VALUES ('202105044', '4812578','장진하','010712','4812578',TO_DATE('2020-05-17','YYYY-MM-DD'));
INSERT INTO TBL_STUDENT(STU_ID, PW, NAME, FSSN, BSSN, SIGNDATE)          
VALUES ('201502078', '3245678','손범석','020305','3245678',TO_DATE('2015-02-12','YYYY-MM-DD'));
INSERT INTO TBL_STUDENT(STU_ID, PW, NAME, FSSN, BSSN, SIGNDATE)          
VALUES ('201505023', '1378214','서승균','940312','1378214',TO_DATE('2015-05-07','YYYY-MM-DD'));


--강의실 테이블 데이터
INSERT INTO TBL_CLASSROOM(CLASS_CODE,NAME,CAPACITY) VALUES(1,'공학관R101','강의실1층 수용인원15명');
INSERT INTO TBL_CLASSROOM(CLASS_CODE,NAME,CAPACITY) VALUES(2,'상경학관R202','강의실2층 수용인원20명');
INSERT INTO TBL_CLASSROOM(CLASS_CODE,NAME,CAPACITY) VALUES(3,'의료학관R303','강의실3층 수용인원25명');
INSERT INTO TBL_CLASSROOM(CLASS_CODE,NAME,CAPACITY) VALUES(4,'예술학관R404','강의실4층 수용인원30명');
INSERT INTO TBL_CLASSROOM(CLASS_CODE,NAME,CAPACITY) VALUES(5,'인문관R505','강의실5층 수용인원35명');
INSERT INTO TBL_CLASSROOM(CLASS_CODE,NAME,CAPACITY) VALUES(6,'공학관R205','강의실2층 수용인원10명');


--배점 테이블 데이터
INSERT INTO TBL_ALLOT(ALLOT_CODE,ATTEND ,PRACTICE ,WRITTEN) VALUES(1,30,35,35);
INSERT INTO TBL_ALLOT(ALLOT_CODE,ATTEND ,PRACTICE ,WRITTEN) VALUES(2,20,40,40);
INSERT INTO TBL_ALLOT(ALLOT_CODE,ATTEND ,PRACTICE ,WRITTEN) VALUES(3,15,45,40);
INSERT INTO TBL_ALLOT(ALLOT_CODE,ATTEND ,PRACTICE ,WRITTEN) VALUES(4,10,45,45);
INSERT INTO TBL_ALLOT(ALLOT_CODE,ATTEND ,PRACTICE ,WRITTEN) VALUES(5,25,50,25);
INSERT INTO TBL_ALLOT(ALLOT_CODE,ATTEND ,PRACTICE ,WRITTEN) VALUES(6,30,40,30);


--과목 테이블 데이터
INSERT INTO TBL_SUBJECTS(SUB_CODE, NAME, BOOK) VALUES(1, '자바', '자바의 정석');
INSERT INTO TBL_SUBJECTS(SUB_CODE, NAME, BOOK) VALUES(2, '오라클', '오라클의 정석');

--========================================================================================


INSERT INTO TBL_SUBJECTS(SUB_CODE, NAME, BOOK) VALUES (1, '자바', '자바의 정석');
INSERT INTO TBL_SUBJECTS(SUB_CODE, NAME, BOOK) VALUES (2, '오라클', '오라클의 정석');
INSERT INTO TBL_SUBJECTS(SUB_CODE, NAME, BOOK) VALUES (3, '파이썬', 'Do it! 점프 투 파이썬');
INSERT INTO TBL_SUBJECTS(SUB_CODE, NAME, BOOK) VALUES (4, 'C언어', '독하게 시작하는 C 프로그래밍');
INSERT INTO TBL_SUBJECTS(SUB_CODE, NAME, BOOK) VALUES (5, '스프링', '스프링 퀵 스타트');

--CO
INSERT INTO TBL_COURSE(COUR_CODE, CLASS_CODE, STARTDATE, ENDDATE, LIMIT) 
VALUES ('개발자A', 1, TO_DATE('2020-12-01','YYYY-MM-DD'), TO_DATE('2021-03-30','YYYY-MM-DD'),15);
INSERT INTO TBL_COURSE(COUR_CODE, CLASS_CODE, STARTDATE, ENDDATE, LIMIT) 
VALUES ('빅데이터A', 2, TO_DATE('2020-12-15','YYYY-MM-DD'), TO_DATE('2021-04-28','YYYY-MM-DD'),20);
INSERT INTO TBL_COURSE(COUR_CODE, CLASS_CODE, STARTDATE, ENDDATE, LIMIT) 
VALUES ('퍼블리셔A', 3, TO_DATE('2021-1-01','YYYY-MM-DD'), TO_DATE('2021-07-15','YYYY-MM-DD'),25);
INSERT INTO TBL_COURSE(COUR_CODE, CLASS_CODE, STARTDATE, ENDDATE, LIMIT) 
VALUES ('개발자B', 4, TO_DATE('2021-09-30','YYYY-MM-DD'), TO_DATE('2021-12-31','YYYY-MM-DD'),30);
INSERT INTO TBL_COURSE(COUR_CODE, CLASS_CODE, STARTDATE, ENDDATE, LIMIT) 
VALUES ('빅데이터B', 5, TO_DATE('2021-12-28','YYYY-MM-DD'), TO_DATE('2022-05-30','YYYY-MM-DD'),10);

--OP
INSERT INTO TBL_OPSUBJECT(OPSUB_CODE, COUR_CODE, SUB_CODE, PRO_ID, ALLOT_CODE, STARTDATE, ENDDATE) 
VALUES (10001, '개발자A', 1, 'hjkim', 5, TO_DATE('2020-12-01','YYYY-MM-DD'), TO_DATE('2021-01-30','YYYY-MM-DD'));
INSERT INTO TBL_OPSUBJECT(OPSUB_CODE, COUR_CODE, SUB_CODE, PRO_ID, ALLOT_CODE, STARTDATE, ENDDATE) 
VALUES (10002, '개발자A', 2, 'yjseo', 4, TO_DATE('2021-02-01','YYYY-MM-DD'), TO_DATE('2021-02-25','YYYY-MM-DD'));
INSERT INTO TBL_OPSUBJECT(OPSUB_CODE, COUR_CODE, SUB_CODE, PRO_ID, ALLOT_CODE, STARTDATE, ENDDATE) 
VALUES (10003, '개발자A', 3, 'jhlim', 1, TO_DATE('2021-02-26','YYYY-MM-DD'), TO_DATE('2021-03-30','YYYY-MM-DD'));

--10010
INSERT INTO TBL_OPSUBJECT(OPSUB_CODE, COUR_CODE, SUB_CODE, PRO_ID, ALLOT_CODE, STARTDATE, ENDDATE) 
VALUES (10010, '개발자B', 2, 'gmlee', 3, TO_DATE('2021-09-30','YYYY-MM-DD'), TO_DATE('2021-10-29','YYYY-MM-DD'));
INSERT INTO TBL_OPSUBJECT(OPSUB_CODE, COUR_CODE, SUB_CODE, PRO_ID, ALLOT_CODE, STARTDATE, ENDDATE) 
VALUES (10011, '개발자B', 5, 'hrkim', 6, TO_DATE('2021-11-01','YYYY-MM-DD'), TO_DATE('2021-11-30','YYYY-MM-DD'));
INSERT INTO TBL_OPSUBJECT(OPSUB_CODE, COUR_CODE, SUB_CODE, PRO_ID, ALLOT_CODE, STARTDATE, ENDDATE) 
VALUES (10012, '개발자B', 4, 'hjkim', 2, TO_DATE('2021-12-01','YYYY-MM-DD'), TO_DATE('2021-12-31','YYYY-MM-DD'));
--================================================================================================================










