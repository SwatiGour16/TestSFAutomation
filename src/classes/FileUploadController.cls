/*************************************************************************************************************
* Name: FileUploadController
* CreatedDate: 6th May 2015
* Description: This class is used as a controller for  FileUploadPage
**************************************************************************************************************/

public class FileUploadController{
	
	/**
	* Record Type name of Station Profile Image
	*/
	public final string STATION_PROFILE_IMAGE = 'Station Profile Image';
	
	/**
	* List of File
	*/    
    public List<File__c> customFileList{get;set;}
    
    /**
    * Browsed file details comming from visualforce page
    */
    public transient string fileDetails{get;set;}
    
    /**
    * API Name of Parent Lookup field, which is populated while creating File__c and link parent and File
    */
    public string parentFieldName;
    
    /**
    * Parent Record Id
    */
    public string parentId{get;set;}
    
    /**
    * Boolean which stores success of file list insert
    */
    public boolean isSuccess{get;set;}
    
    /**
    * Custom setting which stores custom file setting
    */
    public Custom_File_Upload_Setting__c fileSetting;
    
    /**
    * Constructor
    */
    public FileUploadController(ApexPages.StandardSetController controller){
        customFileList = new List<File__c>();
        fileSetting = Custom_File_Upload_Setting__c.getOrgDefaults();
        parentId = ApexPAges.CurrentPage().getParameters().get('id');
        isSuccess = false;
        if(parentId == null || parentId == ''){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'parentId is not provided'));
        }
        else{
        	parentFieldName = getParentField(((Id)parentId).getSObjectType());
        	if(parentFieldName == null || parentId == null){
	            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Custom File has no relationship with parent'));
	        }
        }
    }
    
    /**
    * Returns Maximum File Size that can be uploaded through Custom File Page
    */
    public Decimal getMaxFileSizeLimitInMB(){
        return fileSetting.Maximum_Attachment_Size__c;
    }
    
    /**
    * Returns the height required for station profile image
    */
    public Decimal getProfileHeightInPixel(){
        return fileSetting.Station_Profile_Image_Height__c;
    }
    
    /**
    * Returns the width required for station profile image
    */
    public Decimal getProfileWidthInPixel(){
        return fileSetting.Station_Profile_Image_Width__c;
    }
    
    /**
    * Returns the record type id of station profile image
    */
    public string getProfileImageRecordType(){
        return ((String)File__c.SobjectType.getDescribe().getRecordTypeInfosByName().get(STATION_PROFILE_IMAGE).getRecordTypeId()).subString(0,15);
    }    
    
    /**
    * This method add files in custom file list
    */
    public void addFiles(){
    	if(fileDetails != null){
	        for(String individualFileDetail: fileDetails.split('~')){
	            List<String> nameSize = individualFileDetail.split('`');
	            if(nameSize != null && nameSize.size() == 2){
	            	File__c file = new File__c(Name__c = nameSize[0]);
	            	file.File_Size__C = nameSize[1];
	            	file.put(parentFieldName, parentId);
	            	customFileList.add(file);
	            }
	        }
    	}
    }
    
    /**
    * This method add record only file instance
    */
    public void addRecordOnly(){
        File__c file = new File__c(Is_Record_Only__c = true);
        file.put(parentFieldName, parentId);
        customFileList.add(file);
    }
    
    /**
    * This method inserts customFileList
    */
    public void insertFiles(){
        try{
            upsert customFileList;
            isSuccess = true;
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
            isSuccess = false;
        }
    }
    
    /**
    * This method removes selected row of file from customFileList 
    */
    public void removeFile(){
        string index = ApexPages.currentPage().getParameters().get('recIndex');
        if(index != null && index != '' && index.isNumeric()){
        	Integer indexNum = Integer.valueof(index);
            if(indexNum < customFileList.size()){
            	customFileList.remove(indexNum);
            }
        }
    }
    
    /**
    * This method returns the field api name of parent lookup present on File__c object
    */
    private string getParentField(Schema.SObjectType parentSobjectType){
        Map<String,Schema.SObjectField> mfields = File__c.SobjectType.getDescribe().fields.getMap();
        for(String field: mFields.keyset()){
            List<Schema.SobjectType> sobjList =  mFields.get(field).getDescribe().getReferenceTo();
            if(sobjList != null && sobjList.size() > 0 && sobjList[0] == parentSobjectType){
                return field;
            }
        }
        return null;
    }
}