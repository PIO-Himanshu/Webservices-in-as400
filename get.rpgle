   Ctl-Opt option(*srcstmt:*Nodebugio) bnddir('QC2LE':'HIMANSHU/BND1');  
   Ctl-Opt Dftactgrp(*No) ActGrp(*new);                                  
                                                                         
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
                                                                         
   data = 'Content-Type: text/html' + CRLF + CRLF;                       
   WritetoWeb(data: %Len(%trim(data)) : ERRds);                          
                                                          
   Data = '<Center><h1>Hello Himanshu</H1></Center>';  
   WritetoWeb(data: %Len(%trim(data)) : ERRds);        
   *Inlr = *On;                                        
   Return;                                             
