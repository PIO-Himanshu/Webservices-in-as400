    Ctl-Opt option(*srcstmt:*Nodebugio) bnddir('QC2LE':'HIMANSHU/BND1'); 
    Ctl-Opt Dftactgrp(*No) ActGrp(*new);
    
    Dcl-F WebEmp Usage(*Input) Keyed;
    
    Dcl-Pr GetEnv Pointer ExtProc('getenv');
        *N Pointer Value Options(*String);
    End-Pr;
                                                                                 
    Dcl-Pr WritetoWeb ExtProc('QtmhWrStout');                          
        DataVar Char(65535) Options(*Varsize);                           
        Datavarlen int(10) const;                                        
        Errcode char(8000) options(*Varsize);                            
    End-Pr;                                                            
                                                                         
    Dcl-Ds Errds qualified;                                            
        Bytesprov int(10) inz(0);                                        
        bytesavail int(10) inz(0);                                       
    End-Ds;                                                            
                                                                         
    Dcl-S data char(1000);                           
    Dcl-C CRLF x'0d25';    
    
    Dcl-S Emp Like(ID) Inz;
    Dcl-S Url Char(1000) Inz;
    Dcl-S Parm Char(100) Inz;
    Dcl-S Pos Int(10) Signed;                 
                                                      
C     EmpKey        Klist                             
C                   KFld                    Emp       
C                                                     
                                                      
    data = 'Content-Type: text/Plain' + CRLF + CRLF;   
    WritetoWeb(data: %Len(%trim(data)) : ERRds);                                                        
    URL = %str(GetEnv('REQUEST_URI'));                 
    Parm = '/PWEB/';                                   
    pos = %ScanR('/' : %trim(URL));                    
    Monitor;                                                           
      Emp = %Int(%Subst(URL:POS+1:3));                                 
    On-Error;                                                          
      Data = '<Error>Invalid URI</Error>';                             
      WritetoWeb(data: %Len(%trim(data)) : ERRds);                     
      Return;                                                          
    EndMon;                                                            
                                                                   
    Data = '<EmployeeDetail>' +CRLF;                                   
    WritetoWeb(data: %Len(%trim(data)) : ERRds);                       
    Chain EmpKey WebEmp;                                               
    If %Found();                                                       
      Data = '<EmployeeId>' + %char(Id) + '</EmployeeId>' + CRLF +     
             '<EmployeeName>' + Name + '</EmployeeName>' + CRLF +      
             '<Status>Success</Status>';                               
      WritetoWeb(data: %Len(%trim(data)) : ERRds);                     
    Else;                                                              
      Data = '<Status>Employee Not Found</Status>' + CRLF;             
      WritetoWeb(data: %Len(%trim(data)) : ERRds);     
    EndIf;                                             
    Data = '</EmployeeDetail>' + CRLF;                 
    WritetoWeb(data: %Len(%trim(data)) : ERRds);       
    *Inlr = *On;                                       
    Return;                                            
