public class ServiceUtility{

	public static String REVIEW_DATE = 'Review Date';
	
    public static String getObjectFields(Schema.SobjectType sobjectType){
        List<String> fields = new List<String>();
        Map<String, Schema.SobjectField> objectFields = sobjectType.getDescribe().Fields.getMap();
        fields.addAll(objectFields.KeySet());
        return String.join(fields, ',');
    }
    
    public static Integer getSQLRowsLimit(){
    	return Limits.getLimitQueryRows() - Limits.getQueryRows();
    }
    
}