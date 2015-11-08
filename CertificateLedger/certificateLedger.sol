contract Certificate {

    bytes32 public RecipientID;
    int public RecipientHealth;
    
    bytes32 public DonorID;
    int public DonorHealth;
    
    address public DoctorSig;
    
    uint public TimeStamp;
    bool public ValidPair;
    
    function Certificate(bytes32 Rid, int RHealth, bytes32 Did, int DHealth, uint Date)
    {
        RecipientID = Rid;
        RecipientHealth = RHealth;
        
        DonorID = Did;
        DonorHealth = DHealth;
        DoctorSig = msg.sender;
        
        TimeStamp = Date;
        ValidPair = true;
    }

    function setRecHealth(int UpdatedHealth)
    {
        if(msg.sender != DoctorSig) return;
        RecipientHealth = UpdatedHealth;
    }
    
    function setDonHealth(int UpdatedHealth)
    {
        if(msg.sender != DoctorSig) return;
        DonorHealth = UpdatedHealth;
    }
    
    function setTimeStamp(uint UpdatedTime)
    {
        if(msg.sender != DoctorSig) return;
        TimeStamp = UpdatedTime;
        ValidPair = true;
    }
    
    function setValidity(bool Validity)
    {
        if(msg.sender != DoctorSig) return;
        ValidPair = Validity;
    }
    
    function remove() {

        suicide(msg.sender);

    }
    
    function wave() constant returns (string) 
    { 
        return "Yay, a kidney cert!"; 
    }
}

contract CertificateLedger
{
    address[] CertificateList;                      
    address Owner;
    
    function CertificateLedger()
    {
        Owner = msg.sender;
    }
    
    function createNewPair(bytes32 Rid,int256 RHealth,bytes32 Did,int256 DHealth,uint256 Date ) returns (address)
    {
        Certificate newCert = new Certificate(Rid, RHealth, Did, DHealth, Date);
        
        CertificateList.push(newCert);
		
		return newCert;
    }
    
    function printLastLedgerEntry() constant returns (address)
    {
        if(CertificateList.length != 0)
        {
            return CertificateList[CertificateList.length-1];
        }
        return 0;
    }
    
    function EditCert(address cert, int256 RHealth, int256 DHealth, uint256 Date, bool stillValid)
    {
        Certificate ChangedCert = Certificate(cert);
        
        if(ChangedCert.DoctorSig() != msg.sender) return;
        
        if(RHealth != 0) ChangedCert.setRecHealth(RHealth);
        if(DHealth != 0) ChangedCert.setDonHealth(DHealth);
        if(Date != 0) ChangedCert.setTimeStamp(Date);
        ChangedCert.setValidity(stillValid);
    }
    
    function checkCert(address cert) constant returns (address)
    {
        Certificate cert1 = Certificate(cert);
        
        for(uint i=0; i < CertificateList.length; ++i)
        {
            Certificate cert2 = Certificate(CertificateList[i]);
     
            if(cert1.ValidPair()==false) return 0;
            if(cert2.ValidPair()==false) return 0;
   
            if(((cert1.DonorHealth() - cert2.RecipientHealth()) > 5) || ((cert1.DonorHealth() - cert2.RecipientHealth())<(-5))) return 0;
            if(((cert2.DonorHealth() - cert1.RecipientHealth()) > 5) || ((cert2.DonorHealth() - cert1.RecipientHealth())<(-5))) return 0;
            return CertificateList[i];
        }
    }
    
        
    function remove() 
    {
        if(msg.sender == Owner) suicide(msg.sender);
    }
    
    function Certificatewave()
    { 
       ((Certificate)(CertificateList[0])).wave(); 
    }
    
    function wave() constant returns (string) 
    { 
        return "Yay yay yay, a kidney cert ledger!"; 
    }
} 
