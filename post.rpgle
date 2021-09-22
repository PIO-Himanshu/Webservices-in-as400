   Ctl-Opt option(*srcstmt:*Nodebugio) bnddir('QC2LE':'HIMANSHU/BND1');
   Ctl-Opt Dftactgrp(*No) ActGrp(*new);                                
                                                                       
   Dcl-F WebEmp Usage(*Input) Keyed;
   
   Dcl-Pr GetEnv Pointer ExtProc('getenv');
       *N Pointer Value Options(*String);
   End-Pr;        
                                                                       
   /COPY QSYSINC/QRPGLESRC,QUSEC                                     
   Dcl-Pr ReadStdInput Extproc('QtmhRdStin');                        
       szRtnBuffer Char(65535) options(*Varsize);                      
       nBufLen Int(10) Const;                                          
       nRtnLen int(10);                                                
       QUSEC like(QUSEC);                                              
   End-Pr;                                                           
                                                                       
   Dcl-Pr WritetoWeb ExtProc('QtmhWrStout');                         
       DataVar Char(65535) Options(*Varsize);                          
       Datavarlen int(10) const;                                       
       Errcode char(8000) options(*Varsize);      
   End-Pr;                                      
                                             
   Dcl-Ds Errds qualified;                      
       bytesprov int(10) inz(0);                  
       bytesavail int(10) inz(0);                 
   End-Ds;                                      
                                             
   Dcl-S data char(1000);                       
   Dcl-C CRLF x'0d25';                          
                                             
   Dcl-S URL Char(100);                         
   Dcl-S ContentType Char(100);                 
   Dcl-S ReqMethod Char(20);                    
                                             
   Dcl-S RtnBuffer char(4096) inz;              
   Dcl-S RtnLen Int(10);                        
   Dcl-Ds apiError LikeDs(QUSEC) Inz;           

   data = 'Content-Type: text/Plain' + CRLF + CRLF;                 
   WritetoWeb(data: %Len(%trim(data)) : ERRds);                     
                                                                 
   URL = %str(GetEnv('REQUEST_URI'));                               
   ContentType = %Str(GetEnv('CONTENT_TYPE'));                      
   ReqMethod = %STR(GetEnv('REQUEST_METHOD'));                      
                                                                 
   ReadStdInput(RtnBuffer : %Size(RtnBuffer) : RtnLen : apiError);  
   Data = 'Data:' + %Trim(RtnBuffer);                               
   WritetoWeb(data: %Len(%trim(data)) : ERRds);                     
   *Inlr = *On;                                                     
   Return;                                                          
