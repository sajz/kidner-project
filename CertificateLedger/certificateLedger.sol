contract CertificateLedger
{
    struct Certificate
    {
        int32 CertificateID;
        
        uint RecipientID;
        uint RecipientHealth;
    
        uint DonorID;
        uint DonorHealth;
    
        address DoctorSig;
        uint Contact;
    
        uint TimeStamp;
        bool ValidPair;
    }
    
    
    int32 CertificateCount=0;
    Certificate[] CertificateList;                      
    address Owner;
    
    function CertificateLedger()
    {
        Owner = msg.sender;
    }
    
    function createNewPair(uint Rid, uint RHealth, uint Did, uint DHealth, uint contact, uint Date)
    {
        CertificateCount++;
        CertificateList.push(Certificate(CertificateCount, Rid, RHealth, Did, DHealth, msg.sender, contact, Date, true));
    }
    
    function getListLength() constant returns (uint)
    {
        return CertificateList.length;
    }
    
     function getrandomnr() constant returns (uint)
    {
        return 205;
    }
    
    function GetRecipientID(uint ID) constant returns (uint)
    {
        if(CertificateList.length != 0)
        {
            if(CertificateList.length >= ID)
            {
                return CertificateList[(uint)(ID-1)].RecipientID;
            }
        }
        return 100;
    }
    
    function EditCert(uint32 ID, uint RHealth, uint DHealth, uint Date, bool stillValid)
    {
        Certificate ChangedCert = CertificateList[ID-1];
        
        if(ChangedCert.DoctorSig != msg.sender) return;
        
        if(RHealth != 0) ChangedCert.RecipientHealth = RHealth;
        if(DHealth != 0) ChangedCert.DonorHealth=DHealth;
        if(Date != 0) ChangedCert.TimeStamp=Date;
        ChangedCert.ValidPair=stillValid;
    }
    
    function checkCert(uint32 ID) constant returns (uint)
    {
         Certificate cert1 = CertificateList[ID-1];
        
        for(uint i=0; i < CertificateList.length; ++i)
        {
            Certificate cert2 = CertificateList[i];
     
            if(cert1.ValidPair == false) return 0;
            if(cert2.ValidPair == false) return 0;
   
            if((cert1.DonorHealth - cert2.RecipientHealth) > 5) return 0;
            if((cert2.DonorHealth- cert1.RecipientHealth) > 5) return 0;
            return CertificateList[i].Contact;
        }
    }
    
        
    function remove() 
    {
        if(msg.sender == Owner) suicide(msg.sender);
    }
    
    function wave() constant returns (string) 
    { 
        return "Yay yay yay, a kidney cert ledger!"; 
    }
} 