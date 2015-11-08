contract CertificateLedger
{
    struct Certificate
    {
        int32 CertificateID;
        
        bytes32 RecipientID;
        int RecipientHealth;
    
        bytes32 DonorID;
        int DonorHealth;
    
        address DoctorSig;
        bytes32 Contact;
    
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
    
    function createNewPair(bytes32 Rid, int256 RHealth, bytes32 Did, int256 DHealth, bytes32 contact, uint256 Date )
    {
        CertificateCount++;
        CertificateList.push(Certificate(CertificateCount, Rid, RHealth, Did, DHealth, msg.sender, contact, Date, true));
    }
    
    function GetRecipientID(int32 ID) constant returns (bytes32)
    {
        if(CertificateList.length != 0)
        {
            if(CertificateList.length > (uint)(ID))
            {
                return CertificateList[(uint)(ID-1)].RecipientID;
            }
        }
        return 0;
    }
    
    function EditCert(uint32 ID, int256 RHealth, int256 DHealth, uint256 Date, bool stillValid)
    {
        Certificate ChangedCert = CertificateList[ID-1];
        
        if(ChangedCert.DoctorSig != msg.sender) return;
        
        if(RHealth != 0) ChangedCert.RecipientHealth = RHealth;
        if(DHealth != 0) ChangedCert.DonorHealth=DHealth;
        if(Date != 0) ChangedCert.TimeStamp=Date;
        ChangedCert.ValidPair=stillValid;
    }
    
    function checkCert(uint32 ID) constant returns (bytes32)
    {
         Certificate cert1 = CertificateList[ID-1];
        
        for(uint i=0; i < CertificateList.length; ++i)
        {
            Certificate cert2 = CertificateList[i];
     
            if(cert1.ValidPair == false) return 0;
            if(cert2.ValidPair == false) return 0;
   
            if(((cert1.DonorHealth - cert2.RecipientHealth > 5) || ((cert1.DonorHealth - cert2.RecipientHealth))<(-5))) return 0;
            if(((cert2.DonorHealth- cert1.RecipientHealth > 5) || ((cert2.DonorHealth - cert1.RecipientHealth))<(-5))) return 0;
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