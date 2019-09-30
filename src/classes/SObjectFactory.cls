@IsTest
public class SObjectFactory
{
    public static User ADMIN_USER
    {
        get
        {
            if (ADMIN_USER == null)
                ADMIN_USER = [
                    SELECT Id FROM User WHERE IsActive = true
                    AND Profile.Name = 'Counsyl System Admin'
                    LIMIT 1
                ];
            return ADMIN_USER;
        }
        private set;
    }
    public static Boolean isProduction
    {
        get
        {
            if (isProduction == null)
                isProduction = ![SELECT IsSandbox FROM Organization].IsSandbox;
            return isProduction;
        }
        private set;
    }

    public static Integer getRecordThreshold()
    {
        return isProduction ? 5 : Limits.getLimitQueries() + 1;
    }

    // no fields
    public static SObject build(SObjectType sObjectType) { return build(sObjectType, 1)[0]; }
    public static SObject create(SObjectType sObjectType) { return create(sObjectType, 1)[0]; }
    
    public static List<SObject> build(SObjectType sObjectType, Integer count)
    {
        return build(sObjectType, count, /*fieldToValue*/ null);
    }
    public static List<SObject> create(SObjectType sObjectType, Integer count)
    {
        return create(sObjectType, count, /*fieldToValue*/ null);
    }
    
    // one field
    public static SObject build(SObjectType sObjectType, SObjectField field, Object value)
    {
        return build(sObjectType, 1, field, value)[0];
    }
    public static SObject create(SObjectType sObjectType, SObjectField field, Object value)
    {
        return create(sObjectType, 1, field, value)[0];
    }
    
    public static List<SObject> build(SObjectType sObjectType, Integer count, SObjectField field, Object value)
    {
        return build(sObjectType, count, new Map<SObjectField, Object> { field => value });
    }
    public static List<SObject> create(SObjectType sObjectType, Integer count, SObjectField field, Object value)
    {
        return create(sObjectType, count, new Map<SObjectField, Object> { field => value });
    }
    
    public static List<SObject> build(
        SObjectType sObjectType, Integer count,
        Map<SObjectField, Object> fieldToValue
    )
    {
        Map<SObjectField, Object> fields = DefaultFieldsCache.get(sObjectType);
        if (fieldToValue != null) fields.putAll(fieldToValue);
        
        List<SObject> records = new List<SObject>();
        while (records.size() < count)
        {
            SObject record = sObjectType.newSObject();
            for (SObjectField field : fields.keySet())
            {
                Object value = fields.get(field);
                if (value instanceOf FieldProvider)
                    value = ((FieldProvider)value).getValue();
                record.put(field, value);
            }
            records.add(record);
        }
        return records;
    }
    public static List<SObject> create(
        SObjectType sObjectType, Integer count,
        Map<SObjectField, Object> fieldToValue
    )
    {
        List<SObject> records = build(sObjectType, count, fieldToValue);
        insert records;
        return records;
    }
    
    public static FieldProvider provideStandardProfile()
    {
        return new SObjectFieldProviders.QueryParentProvider(
            'SELECT Id FROM Profile WHERE Name = \'Standard User\' LIMIT 1'
        );
    }
    
    public static FieldProvider provideUniqueNumber()
    {
        return new SObjectFieldProviders.UniqueNumberProvider();
    }
    public static FieldProvider provideUniqueNumber(Integer start)
    {
        return new SObjectFieldProviders.UniqueNumberProvider(start);
    }

    public static FieldProvider provideUniqueDate()
    {
        return new SObjectFieldProviders.UniqueDateProvider();
    }
    public static FieldProvider provideUniqueDate(Date startDate)
    {
        return new SObjectFieldProviders.UniqueDateProvider(startDate);
    }

    public static FieldProvider provideUniqueString()
    {
        return new SObjectFieldProviders.UniqueStringProvider();
    }
    public static FieldProvider provideUniqueString(String base)
    {
        return new SObjectFieldProviders.UniqueStringProvider(base);
    }
    
    public static FieldProvider provideUniqueFixedLengthString(Integer length)
    {
        return new SObjectFieldProviders.UniqueFixedLengthStringProvider(length);
    }
    public static FieldProvider provideUniqueFixedLengthString(String base, Integer length)
    {
        return new SObjectFieldProviders.UniqueFixedLengthStringProvider(base, length);
    }

    public static FieldProvider provideDummyId(SObjectType sObjectType)
    {
        return new SObjectFieldProviders.DummyIdProvider(sObjectType);
    }

    public static FieldProvider provideGenericParent(SObjectType sObjectType)
    {
        return new SObjectFieldProviders.GenericParentProvider(sObjectType);
    }
    public static FieldProvider provideGenericParent(SObjectType sObjectType, SObjectField field, Object value)
    {
        return new SObjectFieldProviders.GenericParentProvider(sObjectType, field, value);
    }

    public static FieldProvider provideList(List<Object> values)
    {
        return new SObjectFieldProviders.ListProvider(values);
    }

    public static FieldProvider provideParents(SObjectType sObjectType, Integer count)
    {
        return new SObjectFieldProviders.MultiParentProvider(SObjectFactory.create(sObjectType, count));
    }
    public static FieldProvider provideParents(List<SObject> parents)
    {
        return new SObjectFieldProviders.MultiParentProvider(parents);
    }
    public static FieldProvider provideParents(Set<Id> parentIds)
    {
        return new SObjectFieldProviders.MultiParentProvider(parentIds);
    }

    public static FieldProvider provideQueriedParent(String query)
    {
        return new SObjectFieldProviders.QueryParentProvider(query);
    }
    public static FieldProvider provideQueriedParent(SObjectType sObjectType)
    {
        return new SObjectFieldProviders.QueryParentProvider(sObjectType);
    }

    public static FieldProvider provideUniqueParent(SObjectType sObjectType)
    {
        return new SObjectFieldProviders.UniqueParentProvider(sObjectType);
    }
    public static FieldProvider provideUniqueParent(SObjectType sObjectType, SObjectField field, Object value)
    {
        return new SObjectFieldProviders.UniqueParentProvider(sObjectType, field, value);
    }
}