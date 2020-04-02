@IsTest
public class DefaultFieldsCache
{
    public static Map<SObjectField, Object> get(SObjectType sObjectType)
    {
        return cache.containsKey(sObjectType) ?
            cache.get(sObjectType) : new Map<SObjectField, Object>();
    }

    public static FieldProvider getGenericParentProvider(SObjectType sObjectType)
    {
        if (!genericParentProviders.containsKey(sObjectType))
            genericParentProviders.put(sObjectType, SObjectFactory.provideGenericParent(sObjectType));
        return genericParentProviders.get(sObjectType);
    }

    public static FieldProvider getUniqueParentProvider(SObjectType sObjectType)
    {
        if (!uniqueParentProviders.containsKey(sObjectType))
            uniqueParentProviders.put(sObjectType, SObjectFactory.provideUniqueParent(sObjectType));
        return uniqueParentProviders.get(sObjectType);
    }

    static Map<SObjectType, FieldProvider> uniqueParentProviders = new Map<SObjectType, FieldProvider>();
    static Map<SObjectType, FieldProvider> genericParentProviders = new Map<SObjectType, FieldProvider>();
    
    static Map<SObjectType, Map<SObjectField, Object>> cache =
        new Map<SObjectType, Map<SObjectField, Object>>
    {
        Account.sObjectType => new Map<SObjectField, Object>
        {
            Account.Name => 'Some Account'
        },
        AccountContactRole.sObjectType => new Map<SObjectField, Object>
        {
            AccountContactRole.AccountId => getGenericParentProvider(Account.sObjectType),
            AccountContactRole.ContactId => getGenericParentProvider(Contact.sObjectType)
        },
        AccountShare.sObjectType => new Map<SObjectField, Object>
        {
            AccountShare.AccountAccessLevel => 'Edit',
            AccountShare.OpportunityAccessLevel => 'Edit',
            AccountShare.AccountId => getGenericParentProvider(Account.sObjectType),
            AccountShare.UserOrGroupId => getGenericParentProvider(Group.sObjectType)
        },
        Announcement.sObjectType => new Map<SObjectField, Object>
        {
            Announcement.FeedItemId => SObjectFactory.provideGenericParent(FeedItem.sObjectType, FeedItem.ParentId, getGenericParentProvider(CollaborationGroup.sObjectType)),
            Announcement.ExpirationDate => Date.today().addDays(1)
        },
        Asset.sObjectType => new Map<SObjectField, Object>
        {
            Asset.AccountId => getGenericParentProvider(Account.sObjectType),
            Asset.Name => 'Some Asset'
        },
        Attachment.sObjectType => new Map<SObjectField, Object>
        {
            Attachment.ParentId => getGenericParentProvider(Account.sObjectType),
            Attachment.Body => Blob.valueOf('body'),
            Attachment.Name => 'Some Attachment'
        },
        Campaign.sObjectType => new Map<SObjectField, Object>
        {
            Campaign.Name => 'Some Campaign'
        },
        CampaignMember.sObjectType => new Map<SObjectField, Object>
        {
            CampaignMember.CampaignId => getGenericParentProvider(Campaign.sObjectType),
            CampaignMember.ContactId => getGenericParentProvider(Contact.sObjectType)
        },
        CaseComment.sObjectType => new Map<SObjectField, Object>
        {
            CaseComment.ParentId => getGenericParentProvider(Case.sObjectType)
        },
        CaseContactRole.sObjectType => new Map<SObjectField, Object>
        {
            CaseContactRole.CasesId => getGenericParentProvider(Case.sObjectType),
            CaseContactRole.ContactId => getGenericParentProvider(Contact.sObjectType),
            CaseContactRole.Role => 'Role'
        },
        CaseShare.sObjectType => new Map<SObjectField, Object>
        {
            CaseShare.CaseId => getGenericParentProvider(Case.sObjectType),
            CaseShare.UserOrGroupId => getGenericParentProvider(Group.sObjectType),
            CaseShare.CaseAccessLevel => 'Edit'
        },
        CaseSolution.sObjectType => new Map<SObjectField, Object>
        {
            CaseSolution.CaseId => getGenericParentProvider(Case.sObjectType),
            CaseSolution.SolutionId => getGenericParentProvider(Solution.sObjectType)
        },
        CaseTeamMember.sObjectType => new Map<SObjectField, Object>
        {
            CaseTeamMember.TeamRoleId => getGenericParentProvider(CaseTeamRole.sObjectType),
            CaseTeamMember.ParentId => getGenericParentProvider(Case.sObjectType),
            CaseTeamMember.MemberId => getGenericParentProvider(User.sObjectType)
        },
        CaseTeamRole.sObjectType => new Map<SObjectField, Object>
        {
            CaseTeamRole.Name => SObjectFactory.provideUniqueString('Some Role'),
            CaseTeamRole.AccessLevel => 'Edit'
        },
        CaseTeamTemplate.sObjectType => new Map<SObjectField, Object>
        {
            CaseTeamTemplate.Name => SObjectFactory.provideUniqueString('Some Template')
        },
        CaseTeamTemplateMember.sObjectType => new Map<SObjectField, Object>
        {
            CaseTeamTemplateMember.TeamTemplateId => getGenericParentProvider(CaseTeamTemplate.sObjectType),
            CaseTeamTemplateMember.TeamRoleId => getGenericParentProvider(CaseTeamRole.sObjectType),
            CaseTeamTemplateMember.MemberId => getGenericParentProvider(User.sObjectType)
        },
        CaseTeamTemplateRecord.sObjectType => new Map<SObjectField, Object>
        {
            CaseTeamTemplateRecord.TeamTemplateId => getGenericParentProvider(CaseTeamTemplate.sObjectType),
            CaseTeamTemplateRecord.ParentId => getGenericParentProvider(Case.sObjectType)
        },
        CollaborationGroup.sObjectType => new Map<SObjectField, Object>
        {
            CollaborationGroup.Name => SObjectFactory.provideUniqueString('Chatter Group'),
            CollaborationGroup.CollaborationType => 'Public'
        },
        CollaborationGroupMember.sObjectType => new Map<SObjectField, Object>
        {
            CollaborationGroupMember.CollaborationGroupId => getGenericParentProvider(CollaborationGroup.sObjectType),
            CollaborationGroupMember.MemberId => getGenericParentProvider(User.sObjectType)
        },
        CollaborationGroupRecord.sObjectType => new Map<SObjectField, Object>
        {
            CollaborationGroupRecord.CollaborationGroupId => getGenericParentProvider(CollaborationGroup.sObjectType),
            CollaborationGroupRecord.RecordId => getGenericParentProvider(Account.sObjectType)
        },
        CollaborationGroupMemberRequest.sObjectType => new Map<SObjectField, Object>
        {
            CollaborationGroupMemberRequest.CollaborationGroupId => getGenericParentProvider(CollaborationGroup.sObjectType),
            CollaborationGroupMemberRequest.RequesterId => UserInfo.getUserId()
        },
        CollaborationInvitation.sObjectType => new Map<SObjectField, Object>
        {
            CollaborationInvitation.SharedEntityId => getGenericParentProvider(CollaborationGroup.sObjectType),
            CollaborationInvitation.InvitedUserEmail => 'jdoe@counsyl.com'
        },
        Contact.sObjectType => new Map<SObjectField, Object>
        {
            Contact.LastName => 'Doe'
        },
        ContentVersion.sObjectType => new Map<SObjectField, Object>
        {
            ContentVersion.Title => 'Some Content',
            ContentVersion.PathOnClient => 'some/path',
            ContentVersion.VersionData => Blob.valueOf('data')
        },
        Contract.sObjectType => new Map<SObjectField, Object>
        {
            Contract.AccountId => getGenericParentProvider(Account.sObjectType)
        },
        ContractContactRole.sObjectType => new Map<SObjectField, Object>
        {
            ContractContactRole.ContractId => getGenericParentProvider(Contract.sObjectType),
            ContractContactRole.ContactId => getGenericParentProvider(Contact.sObjectType)
        },
        Document.sObjectType => new Map<SObjectField, Object>
        {
            Document.FolderId => getGenericParentProvider(User.sObjectType),
            Document.Name => 'Some Document'
        },
        EmailMessage.sObjectType => new Map<SObjectField, Object>
        {
            EmailMessage.ParentId => getGenericParentProvider(Case.sObjectType)
        },
        EmailTemplate.sObjectType => new Map<SObjectField, Object>
        {
            EmailTemplate.DeveloperName => SObjectFactory.provideUniqueString('Template'),
            EmailTemplate.FolderId => getGenericParentProvider(User.sObjectType),
            EmailTemplate.TemplateType => 'Text',
            EmailTemplate.Name => 'Some Template'
        },
        EntitySubscription.sObjectType => new Map<SObjectField, Object>
        {
            EntitySubscription.ParentId => getGenericParentProvider(Account.sObjectType),
            EntitySubscription.SubscriberId => getGenericParentProvider(User.sObjectType)
        },
        Event.sObjectType => new Map<SObjectField, Object>
        {
            Event.ActivityDateTime => Datetime.now(),
            Event.DurationInMinutes => 60
        },
        EventRelation.sObjectType => new Map<SObjectField, Object>
        {
            EventRelation.EventId => getGenericParentProvider(Event.sObjectType),
            EventRelation.RelationId => getGenericParentProvider(User.sObjectType)
        },
        FeedComment.sObjectType => new Map<SObjectField, Object>
        {
            FeedComment.FeedItemId => getGenericParentProvider(FeedItem.sObjectType),
            FeedComment.CommentBody => 'Some Comment'
        },
        FeedItem.sObjectType => new Map<SObjectField, Object>
        {
            FeedItem.ParentId => getGenericParentProvider(Account.sObjectType),
            FeedItem.Body => 'Some Content'
        },
        FeedLike.sObjectType => new Map<SObjectField, Object>
        {
            FeedLike.FeedItemId => getGenericParentProvider(FeedItem.sObjectType)
        },
        SObjectType.FieldPermissions.getSObjectType() => new Map<SObjectField, Object>
        {
            FieldPermissions.Field => String.valueOf(Opportunity.sObjectType) + '.' + String.valueOf(Opportunity.Amount),
            FieldPermissions.ParentId => getGenericParentProvider(PermissionSet.sObjectType),
            FieldPermissions.SObjectType => String.valueOf(Opportunity.sObjectType),
            FieldPermissions.PermissionsRead => true
        },
        Group.sObjectType => new Map<SObjectField, Object>
        {
            Group.Name => 'Some Group'
        },
        GroupMember.sObjectType => new Map<SObjectField, Object>
        {
            GroupMember.GroupId => getGenericParentProvider(Group.sObjectType),
            GroupMember.UserOrGroupId => getGenericParentProvider(User.sObjectType)
        },
        Holiday.sObjectType => new Map<SObjectField, Object>
        {
            Holiday.Name => 'Some Holiday',
            Holiday.ActivityDate => Date.today()
        },
        Idea.sObjectType => new Map<SObjectField, Object>
        {
            Idea.CommunityId => SObjectFactory.provideQueriedParent(Community.sObjectType),
            Idea.Categories => 'Training',
            Idea.Title => 'Some Idea'
        },
        IdeaComment.sObjectType => new Map<SObjectField, Object>
        {
            IdeaComment.IdeaId => getGenericParentProvider(Idea.sObjectType)
        },
        Lead.sObjectType => new Map<SObjectField, Object>
        {
            Lead.LastName => 'Doe',
            Lead.Company => 'ACME'
        },
        LeadShare.sObjectType => new Map<SObjectField, Object>
        {
            LeadShare.UserOrGroupId => getGenericParentProvider(User.sObjectType),
            LeadShare.LeadId => getGenericParentProvider(Lead.sObjectType),
            LeadShare.LeadAccessLevel => 'Edit'
        },
        Note.sObjectType => new Map<SObjectField, Object>
        {
            Note.ParentId => getGenericParentProvider(Account.sObjectType),
            Note.Title => 'Some Note'
        },
        SObjectType.ObjectPermissions.getSObjectType() => new Map<SObjectField, Object>
        {
            ObjectPermissions.ParentId => getGenericParentProvider(PermissionSet.sObjectType),
            ObjectPermissions.SObjectType => String.valueOf(Account.sObjectType),
            ObjectPermissions.PermissionsRead => true
        },
        Opportunity.sObjectType => new Map<SObjectField, Object>
        {
            Opportunity.AccountId => getGenericParentProvider(Account.sObjectType),
            Opportunity.Name => 'Some Opportunity',
            Opportunity.StageName => 'Some Stage',
            Opportunity.CloseDate => Date.today()
        },
        OpportunityCompetitor.sObjectType => new Map<SObjectField, Object>
        {
            OpportunityCompetitor.OpportunityId => getGenericParentProvider(Opportunity.sObjectType)
        },
        OpportunityContactRole.sObjectType => new Map<SObjectField, Object>
        {
            OpportunityContactRole.OpportunityId => getGenericParentProvider(Opportunity.sObjectType),
            OpportunityContactRole.ContactId => getGenericParentProvider(Contact.sObjectType)
        },
        OpportunityLineItem.sObjectType => new Map<SObjectField, Object>
        {
            OpportunityLineItem.OpportunityId => getGenericParentProvider(Opportunity.sObjectType),
            OpportunityLineItem.PricebookEntryId => getGenericParentProvider(PricebookEntry.sObjectType),
            OpportunityLineItem.UnitPrice => 1,
            OpportunityLineItem.Quantity => 1
        },
        OpportunityShare.sObjectType => new Map<SObjectField, Object>
        {
            OpportunityShare.OpportunityId => getGenericParentProvider(Opportunity.sObjectType),
            OpportunityShare.UserOrGroupId => getGenericParentProvider(User.sObjectType),
            OpportunityShare.OpportunityAccessLevel => 'Edit'
        },
        Partner.sObjectType => new Map<SObjectField, Object>
        {
            Partner.AccountFromId => getGenericParentProvider(Account.sObjectType),
            Partner.AccountToId => SObjectFactory.provideGenericParent(Account.sObjectType)
        },
        PermissionSet.sObjectType => new Map<SObjectField, Object>
        {
            PermissionSet.Name => SObjectFactory.provideUniqueString('TestPermissions'),
            PermissionSet.Label => SObjectFactory.provideUniqueString('Test Permissions')
        },
        PermissionSetAssignment.sObjectType => new Map<SObjectField, Object>
        {
            PermissionSetAssignment.PermissionSetId => getGenericParentProvider(PermissionSet.sObjectType),
            PermissionSetAssignment.AssigneeId => getGenericParentProvider(User.sObjectType)
        },
        Pricebook2.sObjectType => new Map<SObjectField, Object>
        {
            Pricebook2.Name => 'Some Pricebook'
        },
        PricebookEntry.sObjectType => new Map<SObjectField, Object>
        {
            PricebookEntry.Product2Id => getGenericParentProvider(Product2.sObjectType),
            PricebookEntry.Pricebook2Id => Test.getStandardPricebookId(),
            PricebookEntry.IsActive => true,
            PricebookEntry.UnitPrice => 1
        },
        Product2.sObjectType => new Map<SObjectField, Object>
        {
            Product2.Name => 'Some Product'
        },
        PushTopic.sObjectType => new Map<SObjectField, Object>
        {
            PushTopic.Name => SObjectFactory.provideUniqueString('PushTopic'),
            PushTopic.Query => 'SELECT Id FROM Account WHERE Name = null',
            PushTopic.ApiVersion => 35
        },
        SObjectType.QueueSobject.getSObjectType() => new Map<SObjectField, Object>
        {
            QueueSobject.QueueId => SObjectFactory.provideGenericParent(Group.sObjectType, Group.Type, 'Queue'),
            QueueSobject.SobjectType => String.valueOf(Case.sObjectType)
        },
        QuickText.sObjectType => new Map<SObjectField, Object>
        {
            QuickText.Message => 'Some Message',
            QuickText.Name => 'Some Text'
        },
        QuickTextShare.sObjectType => new Map<SObjectField, Object>
        {
            QuickTextShare.ParentId => getGenericParentProvider(QuickText.sObjectType),
            QuickTextShare.UserOrGroupId => getGenericParentProvider(User.sObjectType),
            QuickTextShare.AccessLevel => 'Edit'
        },
        SearchPromotionRule.sObjectType => new Map<SObjectField, Object>
        {
            SearchPromotionRule.Query => 'some query'
        },
        Solution.sObjectType => new Map<SObjectField, Object>
        {
            Solution.SolutionName => 'Some Solution'
        },
        SetupEntityAccess.sObjectType => new Map<SObjectField, Object>
        {
            SetupEntityAccess.ParentId => getGenericParentProvider(PermissionSet.sObjectType),
            SetupEntityAccess.SetupEntityId => SObjectFactory.provideQueriedParent(
                'SELECT Id FROM ApexClass WHERE NamespacePrefix = null LIMIT 1'
            )
        },
        SocialPersona.sObjectType => new Map<SObjectField, Object>
        {
            SocialPersona.ParentId => getGenericParentProvider(Account.sObjectType),
            SocialPersona.Provider => 'Twitter',
            SocialPersona.Name => 'Somebody'
        },
        SocialPost.sObjectType => new Map<SObjectField, Object>
        {
            SocialPost.Name => 'Some Post'
        },
        SocialPostShare.sObjectType => new Map<SObjectField, Object>
        {
            SocialPostShare.ParentId => getGenericParentProvider(SocialPost.sObjectType),
            SocialPostShare.UserOrGroupId => getGenericParentProvider(User.sObjectType),
            SocialPostShare.AccessLevel => 'Edit'
        },
        StreamingChannel.sObjectType => new Map<SObjectField, Object>
        {
            StreamingChannel.Name => SObjectFactory.provideUniqueString('/u/TestChannel')
        },
        StreamingChannelShare.sObjectType => new Map<SObjectField, Object>
        {
            StreamingChannelShare.ParentId => getGenericParentProvider(StreamingChannel.sObjectType),
            StreamingChannelShare.UserOrGroupId => getGenericParentProvider(User.sObjectType),
            StreamingChannelShare.AccessLevel => 'Edit'
        },
        Topic.sObjectType => new Map<SObjectField, Object>
        {
            Topic.Name => SObjectFactory.provideUniqueString('Topic')
        },
        TopicAssignment.sObjectType => new Map<SObjectField, Object>
        {
            TopicAssignment.EntityId => getGenericParentProvider(FeedItem.sObjectType),
            TopicAssignment.TopicId => getGenericParentProvider(Topic.sObjectType)
        },
        User.sObjectType => new Map<SObjectField, Object>
        {
            User.LastName => 'Doe',
            User.LocaleSidKey => 'en_US',
            User.Email => 'jdoe@example.com',
            User.LanguageLocaleKey => 'en_US',
            User.EmailEncodingKey => 'ISO-8859-1',
            User.TimeZoneSidKey => 'America/Denver',
            User.ProfileId => SObjectFactory.provideStandardProfile(),
            User.Alias => SObjectFactory.provideUniqueFixedLengthString('jdoe', 7),
            User.CommunityNickname => SObjectFactory.provideUniqueString('johndoe'),
            User.Username => SObjectFactory.provideUniqueString('1234567890abcxyz@example.com')
        },
        UserPackageLicense.sObjectType => new Map<SObjectField, Object>
        {
            UserPackageLicense.UserId => getGenericParentProvider(User.sObjectType),
            UserPackageLicense.PackageLicenseId => SObjectFactory.provideQueriedParent(PackageLicense.sObjectType)
        },
        UserRole.sObjectType => new Map<SObjectField, Object>
        {
            UserRole.Name => 'Some Role'
        },
        UserShare.sObjectType => new Map<SObjectField, Object>
        {
            UserShare.UserId => getGenericParentProvider(User.sObjectType),
            UserShare.UserOrGroupId => getGenericParentProvider(User.sObjectType),
            UserShare.UserAccessLevel => 'Edit'
        }
    };
}
