create table otpp_details(mobile_number number,otp number,otpgeneratedtime date,otpexpiredtime date);
alter table otpp_details modify otpexpiredtime timestamp;
alter table otpp_details modify otpgeneratedtime timestamp;

desc otpp_details;
select * from otpp_details;

Create or Replace Procedure Otp_Generation(P_Phone IN NUMBER,
                                           P_Otp   OUT NUMBER)
As
Begin
  select trunc(dbms_random.value(100000,999999))
   into P_Otp
  from Dual;

 
insert into otpp_details(mobile_number,otp,otpgeneratedtime,otpexpiredtime) values (P_Phone,P_Otp,SYSDATE,SYSDATE+1/(24*60));
commit;
End Otp_Generation;
/


set serveroutput on;
Declare
   otp number;
Begin
   Otp_Generation(9866328612,otp);
   Dbms_output.put_line(otp);
End;
/

create or replace procedure otp_validation(P_Phone IN NUMBER,
                                        P_Otp IN NUMBER,
                                        P_Message OUT VARCHAR2)
As
  L_Count number;
Begin
 Select count(1)
   into L_Count
 From otpp_details
 where mobile_number=P_Phone
 and otp = P_Otp
 and sysdate between otpgeneratedtime and otpexpiredtime;
 if L_Count =1 then
   P_Message := 'otp applied successfully';
 else 
   P_Message := 'otp is invalid/expired';
 end if;
end otp_validation;
/
SET SERVEROUTPUT ON;
Declare 
 Message Varchar2(200);
begin
 otp_validation(9866328612,720824,Message);
 Dbms_output.put_line(Message);
end;
/
                                