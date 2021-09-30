
      ************************************************************
     H DFTACTGRP(*NO) ACTGRP(*NEW) BNDDIR('AAKASH/B10':'QC2LE')
      ************************************************************
     FEmp_mast1 IF A E           K DISK
      ************************************************************
     DGetenv           PR              *   ExtProc('getenv')
     D var                             *   value Options(*string)
      ************************************************************
     Dwritetoweb       PR                  ExtProc('QtmhWrStout')
     D Datavar                    65535A   Options(*varsize)
     D Datavarlen                    10I 0 const
     D Errorcode                   8000A   Options(*Varsize)
      ************************************************************
     DErrDs            DS                  Qualified
     D BytesProv                     10I 0 Inz(0)
     D BytesAvail                    10I 0 Inz(0)
      ************************************************************
       /COPY QSYSINC/QRPGLESRC,QUSEC
      ************************************************************
     DReadStdInput     pr                  ExtProc('QtmhRdStin')
     D szRtnBuffer                65535A   Options(*varsize)
     D nBufLen                       10I 0 const
     D nRtnLen                       10I 0
     D QUSEC                               like(QUSEC)
      ************************************************************ 
     D CRLF            C                   x'0d25'
     D DATA            S           5000A
     D URL             S            100A
     D REQMETHOD       S             20A
     D CONTENT         S            100A
     D RtnBuffer       s           4096A   inz
     D RtnLen          s             10I 0
     D ApiError        Ds                  likeds(QUSEC) inz
     D EmpID1          s              4S 0
     D EmpNam1         s             20A
     D Empage1         s              3S 0
     D Empmob1         s             10S 0
     D W_pos           s              3S 0
     D w_pos1          s              3S 0
     D FLAG            s              3S 0 INZ(0)

      ************************************************************
      /Free
      **
         DATA = 'Content-type: text/html' + CRLF + CRLF ;
         writetoweb(DATA: %len(%trim(DATA)): ErrDs);

         URL = %Str(GetEnv('REQUEST_URI'));
         REQMETHOD = %STR(GetEnv('REQUEST_METHOD'));
      **
         IF REQMETHOD = 'POST';
           CONTENT = %STR(GetEnv('CONTENT_TYPE'));
           ReadStdInput(RtnBuffer:%size(RtnBuffer):RtnLen:ApiError);
         ENDIF;
      **
         DATA = %trim(RtnBuffer);
      **
         MONITOR;
           w_pos = %scan(',':DATA);
           Empid1= %dec(%subst(DATA:1:w_POS-1):4:0);
           w_POS1 = w_POS+1;
      **
           w_pos = %scan(',':DATA:w_POS1);
           Empnam1 = %subst(DATA:w_pos1:w_pos-w_pos1);
           w_POS1 = W_POS+1;

           W_POS= %scan(',':DATA:w_POS1);
           Empage1= %dec(%subst(DATA:w_pos1:W_POS-w_pos1):3:0);
           w_POS1 =W_POS+1;

        Empmob1  = %dec(%subst(DATA:w_pos1:%len(%trim(data))-(w_pos1-1)):10:0);
           FLAG = 0;
         ON-ERROR;
           DATA = 'FORMAT INCORRECT : ID,NAME,AGE,MOBILE-No ';
           FLAG = 1;
         ENDMON;

         IF FLAG = 0;
          MONITOR;
            Empid = empid1;
            CHAIN EmpID EMP_mast1;
            IF %FOUND(EMP_mast1);
              DATA = 'ID ALREADY EXIST';
            ELSE;
              EmpNAM = %TRIM(empnam1);
              EmpAGE = EmpAGE1;
              Empmob  = Empmob1;
              write emprec;
              DATA = 'RECORD ADDED SUCCESSFULLY';
            ENDIF;
          ON-ERROR;
            DATA = 'ERROR WHILE INSERTING RECORD IN DATABASE';
          ENDMON;
         ENDIF;

           writetoweb(DATA: %len(%trim(DATA)): ErrDs);

         *Inlr = *On;
         Return;
      /End-Free
